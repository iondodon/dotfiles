#!/bin/bash

# Start applications on specific workspaces

# awesome-client 'awful.util.spawn("firefox")'
awesome-client 'awful.util.spawn("google-chrome")'
awesome-client 'awful.util.spawn("teams-for-linux")'
awesome-client 'awful.util.spawn("outlook-for-linux")'
# awesome-client 'awful.util.spawn("cherrytree")'

# sleep 2

# awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "dev"):view_only()'
awesome-client 'awful.util.spawn("/home/ion/.local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh")'
# awesome-client 'awful.util.spawn("dbeaver")'
awesome-client 'awful.util.spawn_with_shell("kitty --session ~/.config/kitty/magentus")'


