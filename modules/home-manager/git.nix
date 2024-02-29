{ ... }: {
  programs.git = {
    enable = true;
    userName = "Abdo .AlGhoul";
    userEmail = "Abdo.AlGhouul@gmail.com";
    extraConfig = {
      url = { "ssh://git@github.com" = { insteadOf = "https://github.com"; }; };
    };
  };
}
