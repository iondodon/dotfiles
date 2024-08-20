#!/bin/bash

# Define workspace names as per i3 configuration
ws1="🌍"
ws2="🛠"
ws3="💬"
ws4="⌘"
ws5="📝"


# Start applications on specific workspaces

i3-msg "workspace $ws1"
i3-msg "exec google-chrome"
i3-msg "exec firefox"
i3-msg "layout tabbed"
i3-msg "exec flameshot"
i3-msg "[workspace=$ws1] focus child"

sleep 2

i3-msg "workspace $ws2"
#i3-msg "exec code"
i3-msg "exec dbeaver"
i3-msg "exec /home/ion/.local/share/JetBrains/Toolbox/apps/intellij-idea-community-edition/bin/idea.sh"
i3-msg "layout tabbed"
i3-msg "[workspace=$ws2] focus child"

sleep 10

i3-msg "workspace $ws3"
i3-msg "exec teams-for-linux"
i3-msg "exec outlook-for-linux"
i3-msg "layout tabbed"
i3-msg "[workspace=$ws3] focus child"

sleep 2

i3-msg "workspace $ws4"
i3-msg "exec terminator --layout=magentus"
i3-msg "layout tabbed"
i3-msg "[workspace=$ws4] focus child"

sleep 2

i3-msg "workspace $ws5"
i3-msg "exec cherrytree"
i3-msg "layout tabbed"
is-msg "[workspace=$ws5] focus child"

sleep 1

i3-msg "workspace $ws1"

sleep 1

# i3-msg "exec --no-startup-id i3-switcher-x11 > ~/.i3-switcher-x11.log 2>&1"
