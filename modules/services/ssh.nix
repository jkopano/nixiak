{ den, ... }:
{
  den.aspects.services._.ssh.homeManager =
    { ... }:
    {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            # Twoje obecne ustawienia
            addKeysToAgent = "yes";
            forwardAgent = true;

            # Dodajemy brakujące elementy, aby plik wynikowy był identyczny
            serverAliveInterval = 0;
            serverAliveCountMax = 3;
            compression = false;
            hashKnownHosts = false;
            userKnownHostsFile = "~/.ssh/known_hosts";
            controlMaster = "no";
            controlPath = "~/.ssh/master-%r@%n:%p";
            controlPersist = "no";
          };
        };
      };
      services.ssh-agent.enable = true;
    };
}
