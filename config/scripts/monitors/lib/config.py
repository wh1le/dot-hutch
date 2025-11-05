# from pathlib import Path
# home_path =  Path.home()

CONFIG_PATHS = {
    "waybar_custom":   "$HOME/.config/waybar/generated_by_scripts/hyprland_workspaces.jsonc",
    "hyprland_custom": "$HOME/.config/hypr/generated_by_scripts/workspaces_per_monitor.conf",
    "waybar_config":   "$HOME/.config/waybar/config.jsonc",
}

MONITORS = {
    "eink": {
        "name": "desc:DSC Paperlike13K 0x00003400",
        "port": "HDMI-A-1",
        "theme":             "$HOME/.config/wal/colorschemes/dark/eink.json",
        "default_wallpaper": "$HOME/.config/wallpapers/white.jpg",
        "hyprland_settings": [
            "gapsin:2,",
            "gapsout:15,",
            "rounding:4,",
            "shadow:0,",
            "bluring:0,",
            "animation:0,",
            "bordersize:2,",
        ],
        "windowrulev2_settings": [
            "'bordercolor 0xFF808080 0xFFF5F5F5,",
            "noanim,",
        ],
    },
    "lg": {
        "name":"LG Electronics LG HDR 4K 0x00013533",
        "port":"DP-1",
        # "theme": "$HOME/.config/wal/colorschemes/dark/purple_high.json",
        "default_wallpaper": "$HOME/.config/wallpapers/forest.jpg",
        "hyprland_settings": [
            # "gapsin:6,",
            # "gapsout:17,",
            # "rounding:4,", 
            # "shadow:0,",
            # "bluring:3,",
            # "animation:0,",
            # "bordersize:2,",
        ],
        "windowrulev2_settings": [ ]
    }
}

MONITORS_CONFIG = {
    "home_office": [
        {**MONITORS["eink"], "workspaces": ["1","2","3","4","5","6","7"]},
        {**MONITORS["lg"],   "workspaces": ["8","9","10"]},
    ],

    "home_office_eink": [
        {**MONITORS["eink"], "workspaces": ["1","2","3","4","5","6","7","8","9","10"]},
    ],

    "home_office_lg": [
        {**MONITORS["lg"], "workspaces": ["1","2","3","4","5","6","7","8","9","10"]},
    ],
}
