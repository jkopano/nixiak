{ den, ... }:
{
  den.aspects.cli._.starship.homeManager =
    { ... }:
    {
      programs.starship = {
        enable = true;
        enableNushellIntegration = true;

        settings = {
          add_newline = false;
          character = {
            "success_symbol" = "[->](bold green)";
            "error_symbol" = "[->](bold red)";
          };
          hostname = {
            ssh_symbol = "🌏";
          };
          os = {
            disabled = true;
            style = "bold blue";
            symbols = {
              EndeavourOS = "󰣇 ";
            };
          };

          directory = {
            truncation_length = 4;
          };
        };
      };
    };
}
