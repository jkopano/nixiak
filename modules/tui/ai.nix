{ den, ... }:
{
  den.aspects.tui._.ai.homeManager =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        qwen-code
        claude-code
        claude-monitor
        claude-agent-acp
        gemini-cli
        codex
      ];
    };
}
