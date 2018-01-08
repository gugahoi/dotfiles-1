#!/usr/bin/env bash

##
# Author: Gustavo Hoirisch
# This script will toggle a monitor on/off based on what it sees from xrandr
# I wrote this mainly to toggle the laptop display from a key binding
##

MONITOR=$1
MONITOR=${MONITOR:-eDP-1}

# Available monitors
# xrandr --query | grep " connected" | cut -d" " -f1

# off
# status="eDP-1 connected primary (normal left inverted right x axis y axis)"

# on
# status="eDP-1 connected primary 1920x1080+0+0 (normal left inverted right x axis y axis) 309mm x 174mm"

status=$(xrandr -q | grep "${MONITOR}")

regex="^${MONITOR} connected (primary.)?([0-9x\+]*)*.*\(normal left inverted right x axis y axis\).*$"

if [[ ${status} =~ ${regex} ]]
then
	echo "${BASH_REMATCH[2]}"
	if [ -z "${BASH_REMATCH[2]}" ]
	then
	      echo "Monitor is off, turning it on"
	      xrandr --output ${MONITOR} --auto
	else
	      echo "Monitor is on, turning it off"
	      xrandr --output ${MONITOR} --off
	fi
else
	echo "no match" >&2 
fi

