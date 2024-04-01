#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
if [ -z ${TASKSET+x} ]; then
  source $controlfolder/tasksetter
fi

get_controls

GAMEDIR=/$directory/ports/derclou
cd $GAMEDIR

$ESUDO chmod 666 /dev/uinput

$GPTOKEYB "derclou" -c "./derclou.gptk" &
LD_LIBRARY_PATH="$PWD/libs" SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig" ./derclou 2>&1 | tee -a ./log.txt

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &

printf "\033c" > /dev/tty0

