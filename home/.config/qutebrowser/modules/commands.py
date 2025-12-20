def apply_commands(c,config):
    c.editor.command = ["kitty", "--class", "qute-editor", "nvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]
    c.fileselect.handler = "external"

    c.fileselect.single_file.command = [
        "kitty", "--class", "floating-yazi",
        "yazi", "--chooser-file={}"
    ]

    c.fileselect.multiple_files.command = [
        "kitty", "--class", "floating-yazi",
        "yazi", "--chooser-file={}"
    ]

    c.fileselect.folder.command = [
        "kitty", "--class", "floating-yazi",
        "yazi", "--cwd-file={}"
    ]
