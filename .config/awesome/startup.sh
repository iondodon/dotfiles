#!/bin/bash

# Start applications on specific workspaces

awesome-client 'awful.util.spawn("google-chrome")'
awesome-client 'awful.util.spawn("teams-for-linux")'
awesome-client 'awful.util.spawn("slack --startup --silent")'
awesome-client 'awful.util.spawn("outlook-for-linux")'
awesome-client 'awful.util.spawn("/home/ion/.local/share/JetBrains/Toolbox/apps/intellij-idea-ultimate/bin/idea.sh")'

awesome-client 'awful.util.spawn_with_shell("kitty --title KittyGlobal --override confirm_os_window_close=1 & kdocker -n KittyGlobal -i ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png")'

# awesome-client 'awful.util.spawn_with_shell("kdocker cherrytree")'

