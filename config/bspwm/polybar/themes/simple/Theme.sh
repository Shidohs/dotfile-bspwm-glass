#!/bin/bash

# Set bspwm configuration
set_bspwm_config() {
    bspc config border_width 2
    bspc config window_gap 12
    bspc config split_ratio 0.52
    bspc config borderless_monocle true
    bspc config gapless_monocle true
    bspc config focus_follows_pointer true
}

# Launch the bar
launch_bars() {
	pgrep -x polybar && pkill -x polybar
	for mon in $(polybar --list-monitors | cut -d":" -f1); do
		MONITOR=$mon polybar -q simple-bar -c ${rice_dir}/config.ini &
	done
	
}
set_bspwm_config
launch_bars
