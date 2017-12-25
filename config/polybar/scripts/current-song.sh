#!/usr/bin/env bash

player_status=$(playerctl status 2> /dev/null)
if [[ $? -eq 0 ]]; then
    metadata="$(playerctl metadata artist) - $(playerctl metadata title)"
fi

# Foreground color formatting tags are optional
if [[ $player_status = "Playing" ]]; then
    echo "%{F#00AA00}$metadata"       # Orange when playing
elif [[ $player_status = "Paused" ]]; then
    echo "%{F#65737E} $metadata"       # Greyed out info when paused
fi
