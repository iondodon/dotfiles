#!/bin/bash
kitty --title KittyGlobal --override confirm_os_window_close=1 &
kdocker -n KittyGlobal -i ~/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png
