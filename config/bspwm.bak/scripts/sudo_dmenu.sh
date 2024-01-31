#!/bin/bash
command=$(echo "" | dmenu -p "Enter sudo command:" -fn 'Monospace-12' -nb '#1E1E1E' -nf '#CCCCCC' -sb '#285577' -sf '#FFFFFF')
[ -n "$command" ] && sudo $command

