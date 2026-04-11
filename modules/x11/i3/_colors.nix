{
  lib,
  colors,
  ...
}:
lib.mkForce {
  focused = {
    border = colors.base0A;
    background = colors.base0A;
    text = colors.base01;
    indicator = colors.base05;
    childBorder = colors.base05;
  };
  focusedInactive = {
    border = colors.base0A;
    background = colors.base0A;
    text = colors.base01;
    indicator = colors.base02;
    childBorder = colors.base02;
  };
  unfocused = {
    border = colors.base00;
    text = colors.base05;
    background = colors.base00;
    indicator = colors.base02;
    childBorder = colors.base02;
  };
  urgent = {
    border = colors.base09;
    background = colors.base09;
    text = colors.base01;
    indicator = colors.base03;
    childBorder = colors.base09;
  };
  placeholder = {
    border = colors.base03;
    text = colors.base05;
    background = colors.base00;
    indicator = colors.base03;
    childBorder = colors.base02;
  };
  background = colors.base00;
}
