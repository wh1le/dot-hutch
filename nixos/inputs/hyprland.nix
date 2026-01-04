{
	hyprland = {
		type = "git";
		url = "https://github.com/hyprwm/Hyprland";
		ref = "refs/tags/v0.52.0";
		submodules = true;
	};

	hyprland-plugins = {
		url = "github:hyprwm/hyprland-plugins/v0.52.0";
		inputs.hyprland.follows = "hyprland";
	};

	hypr-darkwindow = {
		url = "github:micha4w/Hypr-DarkWindow/v0.52.0";
		inputs.hyprland.follows = "hyprland";
	};

	hyprspace = {
		url = "github:KZDKM/Hyprspace";
		inputs.hyprland.follows = "hyprland";
	};
}
