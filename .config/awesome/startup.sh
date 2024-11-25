#!/bin/bash

# Start applications on specific workspaces

awesome-client 'awful.util.spawn("google-chrome")'
awesome-client 'awful.util.spawn("teams-for-linux")'
awesome-client 'awful.util.spawn("slack --startup --silent")'
awesome-client 'awful.util.spawn("outlook-for-linux")'
awesome-client 'awful.util.spawn("/home/ion/.local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh")'

awesome-client 'awful.util.spawn("/home/ion/.config/awesome/kitty_startup.sh")'

