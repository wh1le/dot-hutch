{ ... }:
{
  programs.git = {
    enable = true;


    settings = {
      user = {
        name = "Nikita M";
        email = "nmiloserdov@proton.me";
      };
      core.excludesFile = "~/.config/git/ignore";
    };
  };
}
