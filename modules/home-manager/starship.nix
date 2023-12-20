{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#352727)"
          "[ ](bg:#836363 fg:#4e0404)"
          "[](bg:#836363 fg:#836363)"
          "$directory"
          "[](fg:#836363 bg:#493737)"
          "$git_branch"
          "$git_status"
          "[](fg:#493737 bg:#3a2c2c)"
          "[](fg:#3a2c2c bg:#2c2121)"
          "[ ](fg:#2c2121)"
          "\n$character"
      ];
      directory = {
        style = "fg:#e3e5e5 bg:#836363";
        format = lib.concatStrings [
          "[ $path ]"
            "($style)"
        ];
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
          "[[ $symbol $branch ](fg:#000000 bg:#493737)]"
            "($style)"
        ];
      };
      git_status = { 
        style = "bg:#394260";
        format = lib.concatStrings [ 
          "[[($all_status$ahead_behind )](fg:#FFFFFF bg:#493737)]"
          "($style)"
        ];
      };
    };
  };
}
