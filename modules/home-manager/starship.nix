{ lib, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#273533)"
        "[ ](bg:#637783 fg:#04364E)"
        "[](bg:#637783 fg:#637783)"
        "$directory"
        "[](fg:#637783 bg:#374349)"
        "$git_branch"
        "$git_status"
        "[](fg:#374349 bg:#2C333A)"
        "[](fg:#2C333A bg:#21282C)"
        "[ ](fg:#21282C)"
        ''

          $character''
      ];

      directory = {
        style = "fg:#e3e5e5 bg:#637783";
        format = lib.concatStrings [ "[ $path ]" "($style)" ];
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      directory.substitutions = {
        Documents = " ";
        Downloads = " ";
        Music = " ";
        Pictures = " ";
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = lib.concatStrings [
          "[[ $symbol $branch ](fg:#000000 bg:#374349)]"
          "($style)"
        ];
      };

      git_status = {
        style = "bg:#394260";
        format = lib.concatStrings [
          "[[($all_status$ahead_behind )](fg:#FFFFFF bg:#374349)]"
          "($style)"
        ];
      };

    };
  };
}
