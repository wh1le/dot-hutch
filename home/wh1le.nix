{
  ...
}:
let
  mainUser = "wh1le";
in
{
  home = {
    username = "${mainUser}";
    homeDirectory = "/home/${mainUser}";
    stateVersion = "25.05";
  };

  programs.git = {
    enable = true;
    userName = "Nikita";
    userEmail = "nmiloserdov09@gmail.com";
  };

  # packages = with pkgs; [ ];
}
