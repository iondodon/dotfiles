#!/bin/bash

# Start applications on specific workspaces

awesome-client 'run_on_tag("1", "google-chrome")'
awesome-client 'run_on_tag("1", "firefox")'

sleep 2

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "2"):view_only()'
awesome-client 'run_on_tag("2", "dbeaver")'
awesome-client 'run_on_tag("2", "/home/ion/.local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh")'

sleep 10

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "3"):view_only()'
# awesome-client 'run_on_tag("3", "terminator --layout=magentus")'
awesome-client 'awful.util.spawn_with_shell("kitty --session ~/.config/kitty/magentus")'

sleep 2

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "4"):view_only()'
awesome-client 'run_on_tag("4", "teams-for-linux")'
awesome-client 'run_on_tag("4", "outlook-for-linux")'

sleep 2

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "5"):view_only()'
awesome-client 'run_on_tag("5", "cherrytree")'
awesome-client 'run_on_tag("5", "outlook-for-linux")'

sleep 1

awesome-client 'awful.tag.find_by_name(awful.screen.focused(), "1"):view_only()'


