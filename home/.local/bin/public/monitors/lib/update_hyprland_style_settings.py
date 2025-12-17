from .cmd_helper import execute, show_notification
from .config import MONITORS_CONFIG


class UpdateHyprlandStyleSettings:
    def __init__(self, setup):
        self.configuration = MONITORS_CONFIG[setup]

    def call(self):
        for monitor_config in self.configuration:
            # TODO: continue
            
            for workspace in monitor_config["workspaces"]:
                pass

                # commands = [
                #     "hyprctl keyword workspace",
                #     workspace,
                #     f", monitor:{monitor_config["name"]},",
                # ].append(monitor_config["commands"])
                #
                # execute(" ".join(commands))
                #
                # # monitor_config["hyprland_settings"]
                #
                # windowrulev2_commands = [
                #     "hyprctl keyword windowrulev2",
                #     *monitor_config["windowrulev2_settings"],
                #     f" onworkspace:{workspace}'"
                # ]
                #
                # execute(" ".join(windowrulev2_commands))


    def write_files(self):
        pass

    def relaunch_applications(self):
        pass

    # def add_hyprland_command_to_batch(self, rules, workspace):
    #     self.hyprland_commands.append(f"keyword workspace {workspace}, monitor:{EINK_DATA['name']}, {rules}")

    # def __count_monitors(self):
    #     result = execute( "hyprctl monitors -j | jq -r 'length'")
    #
    #     return int(result)

    # def __hyprland_batch_execute(self):
    #     execute(["hyprctl --batch", "; ".join(self.hyprland_commands)])


    # def __workspaces(self):
    #     if self.__count_monitors() > 1:
    #         return self.__get_workspaces().split("\n")
    #     else:
    #         return WORKSPACES

    # def __get_workspaces(self):
    #     pass
    # command = f"hyprctl workspaces -j | jq -r --arg mon {EINK_DATA["port"]} '.[] | select(.monitor == $mon) | .name'"

    # return execute(command)

# def apps_running():
#     command = execute("hyprctl clients -j | jq '.[] | (.workspace.name + \":\" + .initialClass)'")
#     result = command.split('\n')
#
#     mapping = defaultdict(list)
#
#     for app in result:
#         cleaned = app.replace('"', '')
#
#         workspace, app_name = cleaned.split(":", 1)
#
#         if workspace in mapping is False:
#             mapping[workspace] = [app_name]
#         else:
#             mapping[workspace].append(app_name)
#
#     return mapping
