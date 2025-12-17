class GenerateConfigFiles:
    def __init__(self, setup):
        self.configuration = MONITORS_CONFIG[setup]

    def write_config_files(self):
        # self.__write_hyprland()
        self.__write_waybar()

    def __write_hyprland(self):
        self.configuration.
        pass

    def __hyprland_workspace_line(self, workspace):
        return f"workspace = {workspace},  persistent:true"

    def __write_waybar(self):
        pass

