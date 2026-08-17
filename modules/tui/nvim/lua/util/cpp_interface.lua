local M = {}

local header_extensions = {
  h = true,
  hh = true,
  hpp = true,
  hxx = true,
  ixx = true,
  mpp = true,
  cppm = true,
}

local source_extensions = {
  cc = true,
  cpp = true,
  cxx = true,
}

local module_extensions = {
  ixx = true,
  mpp = true,
  cppm = true,
}

local header_candidates = { "ixx", "mpp", "cppm", "hpp", "hxx", "hh", "h" }

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "C++ interface/implementation" })
end

local function extension(path)
  return vim.fn.fnamemodify(path, ":e"):lower()
end

local function stem(path)
  return vim.fn.fnamemodify(path, ":r")
end

local function node_text(node, bufnr)
  return vim.treesitter.get_node_text(node, bufnr)
end

local function cpp_root(bufnr)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "cpp")
  if not ok or not parser then
    return nil
  end
  local trees = parser:parse()
  return trees[1] and trees[1]:root() or nil
end

local function walk(node, callback)
  if callback(node) == false then
    return
  end
  for child in node:iter_children() do
    walk(child, callback)
  end
end

local function ancestor(node, wanted)
  while node do
    if wanted[node:type()] then
      return node
    end
    node = node:parent()
  end
end

local function node_at_cursor(bufnr)
  local root = cpp_root(bufnr)
  if not root then
    return nil
  end
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = math.max(cursor[1] - 1, 0)
  local col = math.max(cursor[2], 0)
  return root:named_descendant_for_range(row, col, row, col)
end

local function module_name(bufnr)
  for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
    local name = line:match("^%s*export%s+module%s+([^;]+)%s*;%s*$")
    if name then
      return vim.trim(name)
    end
  end
end

local function save_buffer(bufnr)
  local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
    vim.cmd("silent noautocmd write")
  end)
  if not ok then
    notify("Could not save the target file: " .. tostring(err), vim.log.levels.ERROR)
  end
  return ok
end

local function ensure_preamble(source_path, interface_path, interface_bufnr)
  local existed = vim.uv.fs_stat(source_path) ~= nil
  if not existed then
    local ok, result = pcall(vim.fn.writefile, {}, source_path)
    if not ok or result ~= 0 then
      notify("Could not create " .. source_path .. ".", vim.log.levels.ERROR)
      return false
    end
  end

  local source_bufnr = vim.fn.bufadd(source_path)
  vim.fn.bufload(source_bufnr)
  local lines = vim.api.nvim_buf_get_lines(source_bufnr, 0, -1, false)
  local mod = module_name(interface_bufnr)
  local preamble = mod and ("module " .. mod .. ";") or ('#include "' .. vim.fs.basename(interface_path) .. '"')

  for _, line in ipairs(lines) do
    if vim.trim(line) == preamble then
      return true
    end
    if
      not mod and line:match('^%s*#%s*include%s*[<"][^>"]*' .. vim.pesc(vim.fs.basename(interface_path)) .. '[>"]')
    then
      return true
    end
  end

  local was_modified = vim.bo[source_bufnr].modified
  if was_modified and existed and source_bufnr ~= vim.api.nvim_get_current_buf() then
    notify(
      "The target " .. source_path .. " has unsaved changes; save it and run the action again.",
      vim.log.levels.WARN
    )
    return false
  end

  local insertion = 0
  if mod then
    for index, line in ipairs(lines) do
      if line:match("^%s*module%s*;%s*$") or line:match("^%s*#") or line:match("^%s*$") then
        insertion = index
      else
        break
      end
    end
  end

  local added = { preamble, "" }
  vim.api.nvim_buf_set_lines(source_bufnr, insertion, insertion, false, added)
  if was_modified then
    notify("Added " .. preamble .. " to the current buffer (the change remains unsaved).")
    return true
  end
  if not save_buffer(source_bufnr) then
    return false
  end

  if not existed then
    notify("Created " .. source_path)
  else
    notify("Added " .. preamble .. " to " .. vim.fs.basename(source_path))
  end
  return true
end

local function clangd(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr, name = "clangd", method = "textDocument/codeAction" })[1]
end

local function declarator_name(declarator)
  local name = declarator
  while name:field("declarator")[1] do
    name = name:field("declarator")[1]
  end
  if name:type() == "qualified_identifier" and name:field("name")[1] then
    name = name:field("name")[1]
  end
  return name
end

local function function_position(node)
  local declarator = node:field("declarator")[1]
  if declarator then
    local name = declarator_name(declarator)
    local row, col = name:start()
    return { row = row, col = col }
  end
  local row, col = node:start()
  return { row = row, col = col }
end

local function is_braced_method_definition(node)
  if node:type() ~= "field_declaration" then
    return false
  end
  local declarator = node:field("declarator")[1]
  local default_value = node:field("default_value")[1]
  return declarator ~= nil
    and declarator:type() == "function_declarator"
    and default_value ~= nil
    and default_value:type() == "initializer_list"
end

local function is_method_declaration(node)
  if node:type() ~= "field_declaration" or node:field("default_value")[1] then
    return false
  end
  local declarator = node:field("declarator")[1]
  return declarator ~= nil and declarator:type() == "function_declarator"
end

local function method_declaration_ancestor(node)
  while node do
    if is_method_declaration(node) then
      return node
    end
    node = node:parent()
  end
end

local function function_definition_ancestor(node)
  while node do
    if node:type() == "function_definition" or is_braced_method_definition(node) then
      return node
    end
    node = node:parent()
  end
end

local function is_template_definition(node)
  return ancestor(node:parent(), { template_declaration = true }) ~= nil
end

local function inline_functions_at_cursor(bufnr)
  local node = node_at_cursor(bufnr)
  if not node then
    return {}, "Could not identify a C++ symbol at the cursor."
  end

  local fn = function_definition_ancestor(node)
  if fn then
    if is_template_definition(fn) then
      return {}, "Template definitions must remain reachable from the interface so importers can instantiate them."
    end
    return { function_position(fn) }
  end

  local class = ancestor(node, { class_specifier = true, struct_specifier = true })
  if not class then
    local declaration = ancestor(node, { declaration = true, field_declaration = true })
    if declaration then
      local text = node_text(declaration, bufnr)
      if text:match("%f[%w]inline%f[%W]") and text:match("%f[%w]constexpr%f[%W]") then
        return {},
          "An inline constexpr variable must keep its initializer in the interface to remain a constant expression."
      end
      return {}, "Only function definitions and class/struct methods can be moved to the implementation file."
    end
    return {}, "Place the cursor on a function definition or a class/struct name."
  end

  if is_template_definition(class) then
    return {}, "Definitions belonging to a class template must remain reachable from the interface."
  end

  local positions = {}
  local skipped_templates = 0
  local body = class:field("body")[1]
  if body then
    walk(body, function(child)
      if child:type() == "function_definition" or is_braced_method_definition(child) then
        if is_template_definition(child) then
          skipped_templates = skipped_templates + 1
        else
          positions[#positions + 1] = function_position(child)
        end
        return false
      end
    end)
  end
  table.sort(positions, function(left, right)
    return left.row > right.row or (left.row == right.row and left.col > right.col)
  end)
  if #positions == 0 and skipped_templates > 0 then
    return {}, "Template method definitions must remain reachable from the interface."
  end
  return positions, nil
end

local function point_in_node(node, row, col)
  local start_row, start_col, end_row, end_col = node:range()
  local after_start = row > start_row or (row == start_row and col >= start_col)
  local before_end = row < end_row or (row == end_row and col <= end_col)
  return after_start and before_end
end

local function namespace_at_position(bufnr, position)
  local root = cpp_root(bufnr)
  if not root then
    return nil
  end

  local names = {}
  walk(root, function(node)
    if node:type() == "namespace_definition" and point_in_node(node, position.line, position.character) then
      local name = node:field("name")[1]
      if name then
        local row, col = node:start()
        names[#names + 1] = {
          row = row,
          col = col,
          name = vim.trim(node_text(name, bufnr)),
        }
      end
    end
  end)
  table.sort(names, function(left, right)
    return left.row < right.row or (left.row == right.row and left.col < right.col)
  end)

  local result = {}
  for _, item in ipairs(names) do
    result[#result + 1] = item.name
  end
  return #result > 0 and table.concat(result, "::") or nil
end

local function range_text(bufnr, range)
  return table.concat(
    vim.api.nvim_buf_get_text(
      bufnr,
      range.start.line,
      range.start.character,
      range["end"].line,
      range["end"].character,
      {}
    ),
    "\n"
  )
end

local function redirect_module_edit(edit, source_path, interface_bufnr)
  if not edit.changes then
    return nil, "clangd returned an unsupported workspace edit for this module interface."
  end

  local redirected = vim.deepcopy(edit)
  local interface_uri = vim.uri_from_bufnr(interface_bufnr)
  local interface_edits = redirected.changes[interface_uri]
  if not interface_edits then
    return nil, "clangd did not return edits for the current module interface."
  end

  local definition
  local retained = {}
  for _, text_edit in ipairs(interface_edits) do
    local replaces_only_whitespace = range_text(interface_bufnr, text_edit.range):match("^%s*$") ~= nil
    if replaces_only_whitespace and vim.trim(text_edit.newText) ~= ";" then
      if definition then
        return nil, "clangd returned more than one generated definition."
      end
      definition = text_edit
    else
      retained[#retained + 1] = text_edit
    end
  end
  if not definition then
    return nil, "Could not identify clangd's generated out-of-line definition."
  end
  if not range_text(interface_bufnr, definition.range):match("^%s*$") then
    return nil, "clangd wanted to replace non-whitespace while inserting the definition; no edits were applied."
  end

  redirected.changes[interface_uri] = retained
  local source_bufnr = vim.fn.bufadd(source_path)
  vim.fn.bufload(source_bufnr)
  local source_lines = vim.api.nvim_buf_get_lines(source_bufnr, 0, -1, false)
  local eof = {
    line = #source_lines - 1,
    character = #(source_lines[#source_lines] or ""),
  }

  local generated = vim.trim(definition.newText)
  local namespace = namespace_at_position(interface_bufnr, definition.range.start)
  if namespace then
    generated = ("namespace %s {\n%s\n}"):format(namespace, generated)
  end

  local source_uri = vim.uri_from_fname(source_path)
  redirected.changes[source_uri] = redirected.changes[source_uri] or {}
  redirected.changes[source_uri][#redirected.changes[source_uri] + 1] = {
    range = { start = eof, ["end"] = eof },
    newText = "\n" .. generated .. "\n",
  }
  return redirected
end

local function append_definition(source_path, generated)
  local source_bufnr = vim.fn.bufadd(source_path)
  vim.fn.bufload(source_bufnr)
  local source_line_count = vim.api.nvim_buf_line_count(source_bufnr)
  local generated_lines = vim.split("\n" .. generated .. "\n", "\n", { plain = true })
  vim.api.nvim_buf_set_lines(source_bufnr, source_line_count, source_line_count, false, generated_lines)
end

local function declarator_without_defaults(declarator, bufnr)
  local text = node_text(declarator, bufnr)
  local _, _, declarator_byte = declarator:start()
  local removals = {}
  walk(declarator, function(node)
    if node:type() ~= "optional_parameter_declaration" then
      return
    end
    local default_value = node:field("default_value")[1]
    if not default_value then
      return
    end
    local _, _, parameter_byte = node:start()
    local _, _, default_byte = default_value:start()
    local _, _, default_end_byte = default_value:end_()
    local prefix_start = parameter_byte - declarator_byte
    local prefix_end = default_byte - declarator_byte
    local prefix = text:sub(prefix_start + 1, prefix_end)
    local equals = prefix:match(".*()=")
    if equals then
      local whitespace = prefix:sub(1, equals - 1):find("%s*$") or equals
      removals[#removals + 1] = {
        start_offset = prefix_start + whitespace - 1,
        end_offset = default_end_byte - declarator_byte,
      }
    end
  end)
  table.sort(removals, function(left, right)
    return left.start_offset > right.start_offset
  end)
  for _, removal in ipairs(removals) do
    text = text:sub(1, removal.start_offset) .. text:sub(removal.end_offset + 1)
  end
  return text
end

local function define_module_method_locally(bufnr, source_path, declaration)
  local class = ancestor(declaration:parent(), { class_specifier = true, struct_specifier = true })
  local class_name_node = class and class:field("name")[1] or nil
  local declarator = declaration:field("declarator")[1]
  if not class_name_node or not declarator then
    return false, "The local module generator supports class/struct methods only."
  end

  local name = declarator_name(declarator)
  local method_name = node_text(name, bufnr)
  local class_name = node_text(class_name_node, bufnr)
  local declarator_text = declarator_without_defaults(declarator, bufnr)
  local name_offset = declarator_text:find(method_name, 1, true)
  if not name_offset then
    return false, "Could not qualify the generated method definition."
  end
  declarator_text = declarator_text:sub(1, name_offset - 1)
    .. class_name
    .. "::"
    .. method_name
    .. declarator_text:sub(name_offset + #method_name)

  local start_row, start_col = declaration:start()
  local declarator_row, declarator_col = declarator:start()
  local prefix =
    table.concat(vim.api.nvim_buf_get_text(bufnr, start_row, start_col, declarator_row, declarator_col, {}), "\n")
  for _, keyword in ipairs({ "inline", "static", "virtual", "explicit" }) do
    prefix = prefix:gsub("%f[%w]" .. keyword .. "%f[%W]%s*", "")
  end

  local generated = vim.trim(prefix .. declarator_text) .. " {}"
  local namespace = namespace_at_position(bufnr, { line = start_row, character = start_col })
  if namespace then
    generated = ("namespace %s {\n%s\n}"):format(namespace, generated)
  end
  append_definition(source_path, generated)
  return true, method_name
end

local function outline_module_locally(bufnr, source_path, position)
  local root = cpp_root(bufnr)
  if not root then
    return false, "The C++ Tree-sitter parser is unavailable."
  end
  local selected = root:named_descendant_for_range(position.row, position.col, position.row, position.col)
  local fn = function_definition_ancestor(selected)
  if not fn then
    return false, "Could not identify the selected method definition."
  end

  local class = ancestor(fn:parent(), { class_specifier = true, struct_specifier = true })
  local class_name_node = class and class:field("name")[1] or nil
  local declarator = fn:field("declarator")[1]
  local body = fn:field("body")[1] or fn:field("default_value")[1]
  if not class_name_node or not declarator or not body then
    return false, "The local module fallback currently supports class/struct methods only."
  end

  local name = declarator_name(declarator)
  local method_name = node_text(name, bufnr)
  local class_name = node_text(class_name_node, bufnr)
  local declarator_text = node_text(declarator, bufnr)
  local name_offset = declarator_text:find(method_name, 1, true)
  if not name_offset then
    return false, "Could not qualify the generated method definition."
  end
  declarator_text = declarator_text:sub(1, name_offset - 1)
    .. class_name
    .. "::"
    .. method_name
    .. declarator_text:sub(name_offset + #method_name)

  local start_row, start_col = fn:start()
  local declarator_row, declarator_col = declarator:start()
  local prefix =
    table.concat(vim.api.nvim_buf_get_text(bufnr, start_row, start_col, declarator_row, declarator_col, {}), "\n")
  for _, keyword in ipairs({ "inline", "static", "virtual", "explicit" }) do
    prefix = prefix:gsub("%f[%w]" .. keyword .. "%f[%W]%s*", "")
  end
  local generated = vim.trim(prefix .. declarator_text) .. " " .. node_text(body, bufnr)
  local namespace = namespace_at_position(bufnr, { line = start_row, character = start_col })
  if namespace then
    generated = ("namespace %s {\n%s\n}"):format(namespace, generated)
  end

  append_definition(source_path, generated)

  local body_start_row, body_start_col = body:start()
  local body_end_row, body_end_col = body:end_()
  local declarator_end_row, declarator_end_col = declarator:end_()
  local gap = table.concat(
    vim.api.nvim_buf_get_text(bufnr, declarator_end_row, declarator_end_col, body_start_row, body_start_col, {}),
    "\n"
  )
  if gap:match("^%s*$") then
    body_start_row, body_start_col = declarator_end_row, declarator_end_col
  end
  if is_braced_method_definition(fn) then
    body_end_row, body_end_col = fn:end_()
  end
  vim.api.nvim_buf_set_text(bufnr, body_start_row, body_start_col, body_end_row, body_end_col, { ";" })
  return true
end

local function apply_action(client, action, bufnr, source_path, redirect_module, callback)
  if action.edit then
    local edit = action.edit
    if redirect_module then
      local err
      edit, err = redirect_module_edit(edit, source_path, bufnr)
      if not edit then
        notify(err, vim.log.levels.ERROR)
        callback(false)
        return
      end
    end
    vim.lsp.util.apply_workspace_edit(edit, client.offset_encoding)
  end

  if not action.command then
    callback(true)
    return
  end

  if not redirect_module then
    client:exec_cmd(action.command, { bufnr = bufnr }, function(err)
      if err then
        notify("clangd command failed: " .. err.message, vim.log.levels.ERROR)
      end
      callback(not err)
    end)
    return
  end

  local method = "workspace/applyEdit"
  local previous_handler = client.handlers[method]
  local fallback_handler = previous_handler or vim.lsp.handlers[method]
  local handled = false

  client.handlers[method] = function(err, params, context, config)
    client.handlers[method] = previous_handler
    handled = true
    if err then
      notify("clangd workspace edit failed: " .. err.message, vim.log.levels.ERROR)
      callback(false)
      return { applied = false, failureReason = err.message }
    end

    local transformed, transform_err = redirect_module_edit(params.edit, source_path, bufnr)
    if not transformed then
      notify(transform_err, vim.log.levels.ERROR)
      callback(false)
      return { applied = false, failureReason = transform_err }
    end

    local redirected_params = vim.deepcopy(params)
    redirected_params.edit = transformed
    local result = fallback_handler(nil, redirected_params, context, config)
    callback(result == nil or result.applied ~= false)
    return result
  end

  client:exec_cmd(action.command, { bufnr = bufnr }, function(err)
    if handled then
      return
    end
    client.handlers[method] = previous_handler
    local message = err and err.message or "clangd completed without sending a workspace edit."
    notify("clangd command failed: " .. message, vim.log.levels.ERROR)
    callback(false)
  end)
end

local function outline_at_positions(bufnr, client, positions, index, moved, source_path, redirect_module)
  if index > #positions then
    if moved > 0 then
      notify(("Moved implementations: %d"):format(moved))
    else
      notify("clangd did not provide an out-of-line action for the selected symbol.", vim.log.levels.WARN)
    end
    return
  end

  local pos = positions[index]
  local mark = { pos.row + 1, pos.col }
  local params = vim.lsp.util.make_given_range_params(mark, mark, bufnr, client.offset_encoding)
  params.context = { diagnostics = {}, only = { "refactor" } }

  client:request("textDocument/codeAction", params, function(err, actions)
    if err then
      notify("clangd code action failed: " .. err.message, vim.log.levels.ERROR)
      return
    end

    local selected
    for _, action in ipairs(actions or {}) do
      if action.title and action.title:lower():find("out%-of%-line") then
        selected = action
        break
      end
    end
    if selected then
      apply_action(client, selected, bufnr, source_path, redirect_module, function(applied)
        vim.schedule(function()
          outline_at_positions(
            bufnr,
            client,
            positions,
            index + 1,
            applied and moved + 1 or moved,
            source_path,
            redirect_module
          )
        end)
      end)
      return
    end
    if redirect_module then
      local applied, local_err = outline_module_locally(bufnr, source_path, pos)
      if not applied then
        notify(local_err, vim.log.levels.ERROR)
      end
      vim.schedule(function()
        outline_at_positions(
          bufnr,
          client,
          positions,
          index + 1,
          applied and moved + 1 or moved,
          source_path,
          redirect_module
        )
      end)
      return
    end
    vim.schedule(function()
      outline_at_positions(bufnr, client, positions, index + 1, moved, source_path, redirect_module)
    end)
  end, bufnr)
end

local function move_to_implementation(bufnr, path)
  local selected = node_at_cursor(bufnr)
  local declaration = selected and method_declaration_ancestor(selected) or nil
  if declaration then
    if is_template_definition(declaration) then
      notify("Template definitions must remain reachable from the interface.", vim.log.levels.WARN)
      return
    end
    local source_path = stem(path) .. ".cpp"
    if not ensure_preamble(source_path, path, bufnr) then
      return
    end
    if not module_extensions[extension(path)] then
      notify(
        "Generating definitions from declarations is currently supported for module interfaces.",
        vim.log.levels.WARN
      )
      return
    end
    local applied, result = define_module_method_locally(bufnr, source_path, declaration)
    if applied then
      notify("Generated definition for " .. result .. " in " .. vim.fs.basename(source_path))
    else
      notify(result, vim.log.levels.ERROR)
    end
    return
  end

  local positions, reason = inline_functions_at_cursor(bufnr)
  if #positions == 0 then
    notify(reason or "Place the cursor on a function definition or a class/struct name.", vim.log.levels.WARN)
    return
  end

  local source_path = stem(path) .. ".cpp"
  if not ensure_preamble(source_path, path, bufnr) then
    return
  end

  if module_extensions[extension(path)] then
    local moved = 0
    for _, position in ipairs(positions) do
      local applied, local_err = outline_module_locally(bufnr, source_path, position)
      if applied then
        moved = moved + 1
      else
        notify(local_err, vim.log.levels.ERROR)
      end
    end
    if moved > 0 then
      notify(("Moved implementations: %d"):format(moved))
    end
    return
  end

  local client = clangd(bufnr)
  if not client then
    notify("clangd is not attached to this buffer.", vim.log.levels.ERROR)
    return
  end

  outline_at_positions(bufnr, client, positions, 1, 0, source_path, false)
end

local function find_interface(source_path)
  local base = stem(source_path)
  for _, ext in ipairs(header_candidates) do
    local candidate = base .. "." .. ext
    if vim.uv.fs_stat(candidate) then
      return candidate
    end
  end
end

local function qualified_name(declarator, bufnr)
  local qualified
  walk(declarator, function(node)
    if not qualified and node:type() == "qualified_identifier" then
      qualified = node
      return false
    end
  end)
  if not qualified then
    return nil
  end

  local name_node = qualified:field("name")[1]
  if not name_node then
    return nil
  end
  local full = node_text(qualified, bufnr)
  local name = node_text(name_node, bufnr)
  local owner = full:sub(1, #full - #name):gsub("::%s*$", "")
  return full, name, owner:match("([^:]+)$")
end

local function declaration_from_definition(node, bufnr)
  if ancestor(node:parent(), { template_declaration = true }) then
    return nil, "Function templates must remain visible in the interface."
  end

  local declarator = node:field("declarator")[1]
  local body = node:field("body")[1]
  if not declarator or not body then
    return nil, "Could not recognize the function signature."
  end

  local full_name, name, class_name = qualified_name(declarator, bufnr)
  if not full_name or not class_name then
    return nil, "Only method definitions written as Type::method(...) are currently supported."
  end

  local start_row, start_col = node:start()
  local decl_row, decl_col = declarator:start()
  local prefix = table.concat(vim.api.nvim_buf_get_text(bufnr, start_row, start_col, decl_row, decl_col, {}), "\n")
  prefix = prefix:gsub("%f[%w]inline%f[%W]%s*", "")
  local declaration = node_text(declarator, bufnr)
  local at = declaration:find(full_name, 1, true)
  if not at then
    return nil, "Could not remove the class qualifier from the definition."
  end
  declaration = declaration:sub(1, at - 1) .. name .. declaration:sub(at + #full_name)
  declaration = vim.trim(prefix .. declaration):gsub("%s+", " ") .. ";"
  return {
    class_name = vim.trim(class_name),
    method_name = vim.trim(name),
    text = declaration,
  }
end

local function find_class(root, bufnr, class_name)
  local found
  walk(root, function(node)
    if node:type() == "class_specifier" or node:type() == "struct_specifier" then
      local name = node:field("name")[1]
      if name and node_text(name, bufnr) == class_name then
        found = node
        return false
      end
    end
  end)
  return found
end

local function add_declaration(bufnr, declaration)
  local root = cpp_root(bufnr)
  if not root then
    return false, "The C++ Tree-sitter parser is unavailable."
  end
  local class = find_class(root, bufnr, declaration.class_name)
  if not class then
    return false, "Could not find class/struct " .. declaration.class_name .. " in the interface."
  end

  local body = class:field("body")[1]
  if not body then
    return false, "Could not find the body of " .. declaration.class_name .. "."
  end

  local class_text = node_text(class, bufnr)
  if class_text:find("%f[%w]" .. vim.pesc(declaration.method_name) .. "%s*%(") then
    return false, "A declaration for " .. declaration.method_name .. " already appears to exist in the interface."
  end

  local effective_access = class:type() == "struct_specifier" and "public" or "private"
  for child in body:iter_children() do
    if child:type() == "access_specifier" then
      effective_access = node_text(child, bufnr):gsub(":", ""):gsub("%s", "")
    end
  end

  local end_row, end_col = body:end_()
  local close_row = end_row
  local close_col = end_col - 1
  local close_line = vim.api.nvim_buf_get_lines(bufnr, close_row, close_row + 1, false)[1] or ""
  local close_indent = close_line:sub(1, close_col):match("^%s*") or ""
  local shiftwidth = vim.bo[bufnr].shiftwidth
  if shiftwidth == 0 then
    shiftwidth = vim.bo[bufnr].tabstop
  end
  local member_indent = close_indent .. string.rep(" ", shiftwidth)
  local replacement = { "" }
  if effective_access ~= "public" then
    replacement[#replacement + 1] = close_indent .. "public:"
  end
  replacement[#replacement + 1] = member_indent .. declaration.text
  replacement[#replacement + 1] = close_indent
  vim.api.nvim_buf_set_text(bufnr, close_row, close_col, close_row, close_col, replacement)
  return true
end

local function move_to_interface(bufnr, path)
  local node = node_at_cursor(bufnr)
  local fn = node and ancestor(node, { function_definition = true }) or nil
  if not fn then
    notify("Place the cursor on a method definition.", vim.log.levels.WARN)
    return
  end

  local declaration, err = declaration_from_definition(fn, bufnr)
  if not declaration then
    notify(err, vim.log.levels.WARN)
    return
  end

  local interface_path = find_interface(path)
  if not interface_path then
    notify("Could not find a same-stem interface (.ixx/.mpp/.cppm/.hpp/.hxx/.hh/.h).", vim.log.levels.ERROR)
    return
  end

  local interface_bufnr = vim.fn.bufadd(interface_path)
  vim.fn.bufload(interface_bufnr)
  if not ensure_preamble(path, interface_path, interface_bufnr) then
    return
  end
  local ok, add_err = add_declaration(interface_bufnr, declaration)
  if not ok then
    notify(add_err, vim.log.levels.WARN)
    return
  end

  notify(
    "Added declaration "
      .. declaration.class_name
      .. "::"
      .. declaration.method_name
      .. " to "
      .. vim.fs.basename(interface_path)
  )
end

function M.toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    notify("The current buffer has no file name.", vim.log.levels.WARN)
    return
  end

  local ext = extension(path)
  if header_extensions[ext] then
    move_to_implementation(bufnr, path)
  elseif source_extensions[ext] then
    move_to_interface(bufnr, path)
  else
    notify("This action supports C++ headers/module interfaces and .cpp/.cc/.cxx files.", vim.log.levels.WARN)
  end
end

function M.code_action()
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
  local custom_action = {
    action = {
      title = "Sync C++ interface/implementation",
      edit = { changes = {} },
    },
    cpp_sync = true,
  }
  if clients[1] then
    custom_action.ctx = {
      bufnr = bufnr,
      client_id = clients[1].id,
      method = "textDocument/codeAction",
    }
  end
  local actions = { custom_action }

  local function apply_lsp_action(choice)
    local client = vim.lsp.get_client_by_id(choice.ctx.client_id)
    if not client then
      notify("The language server that supplied this action is no longer available.", vim.log.levels.ERROR)
      return
    end

    local function apply(action)
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
      end
      local command = action.command
      if command then
        client:exec_cmd(type(command) == "table" and command or action, choice.ctx)
      end
    end

    local action = choice.action
    if type(action.title) == "string" and type(action.command) == "string" then
      apply(action)
    elseif action.disabled then
      notify(action.disabled.reason, vim.log.levels.ERROR)
    elseif not (action.edit and action.command) and client:supports_method("codeAction/resolve") then
      client:request("codeAction/resolve", action, function(err, resolved)
        if err then
          if action.edit or action.command then
            apply(action)
          else
            notify("Could not resolve code action: " .. err.message, vim.log.levels.ERROR)
          end
        else
          apply(resolved)
        end
      end, bufnr)
    else
      apply(action)
    end
  end

  local function show_picker()
    vim.ui.select(actions, {
      prompt = "Code actions:",
      kind = clients[1] and "codeaction" or "cpp-codeaction",
      format_item = function(item)
        if item.cpp_sync then
          return item.action.title
        end
        local title = item.action.title:gsub("\r\n", "\\r\\n"):gsub("\n", "\\n")
        if item.action.disabled then
          title = title .. " (disabled)"
        end
        local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
        if #clients > 1 then
          local client = vim.lsp.get_client_by_id(item.ctx.client_id)
          title = title .. " [" .. (client and client.name or "LSP") .. "]"
        end
        return title
      end,
    }, function(choice)
      if not choice then
        return
      end
      if choice.cpp_sync then
        M.toggle()
      else
        apply_lsp_action(choice)
      end
    end)
  end

  if #clients == 0 then
    show_picker()
    return
  end

  local remaining = #clients
  for _, client in ipairs(clients) do
    local params = vim.lsp.util.make_range_params(win, client.offset_encoding)
    local diagnostics = {}
    local namespace = vim.lsp.diagnostic.get_namespace(client.id)
    for _, diagnostic in
      ipairs(vim.diagnostic.get(bufnr, {
        namespace = namespace,
        lnum = vim.api.nvim_win_get_cursor(win)[1] - 1,
      }))
    do
      if diagnostic.user_data and diagnostic.user_data.lsp then
        diagnostics[#diagnostics + 1] = diagnostic.user_data.lsp
      end
    end
    params.context = {
      diagnostics = diagnostics,
      triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
    }

    client:request("textDocument/codeAction", params, function(err, result, context)
      if not err then
        for _, action in ipairs(result or {}) do
          actions[#actions + 1] = { action = action, ctx = context }
        end
      end
      remaining = remaining - 1
      if remaining == 0 then
        show_picker()
      end
    end, bufnr)
  end
end

return M
