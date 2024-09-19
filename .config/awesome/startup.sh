#!/bin/bash

# Start applications on specific workspaces

awesome-client 'run_on_tag("1", "firefox")'
awesome-client 'run_on_tag("1", "google-chrome")'
awesome-client 'run_on_tag("1", "teams-for-linux")'
awesome-client 'run_on_tag("1", "outlook-for-linux")'
awesome-client 'run_on_tag("1", "cherrytree")'

sleep 5

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "2"):view_only()'
awesome-client 'run_on_tag("2", "/home/ion/.local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh")'
awesome-client 'run_on_tag("2", "dbeaver")'
awesome-client 'awful.util.spawn_with_shell("kitty --session ~/.config/kitty/magentus")'

sleep 5

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "1"):view_only()'


