{ den, ... }:
{
  den.aspects.tui._.ai.homeManager =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        qwen-code
        # claude-code
        # claude-monitor
        # claude-code-acp
        gemini-cli
        codex
      ];
    };
}
