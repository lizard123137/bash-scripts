#!/bin/bash

#
# Wrapper around pactl
#
# Lets the user view the currently selected audio devices.
# Lists the available devices and lets the user select the desired ones.
#

usage() {
	echo -e "pa_dev_picker - wrapper around pactl designed to simplify the process of changing the selected audio devices"
	echo -e ""
	echo -e "Usage:"
	echo -e "pa_dev_picker help\t\t\t\t\t\tdisplays this usage page." 
	echo -e "pa_dev_picker current\t\t\t\t\t\tshows the current input and output devices."
	echo -e "pa_dev_picker list (input|output)\t\t\t\tlists the available input/output devices."
	echo -e "pa_dev_picker select (input|output) <full_device_name>\t\tselects the provided device as the currently used one."
}

case $1 in
	help)
		usage
	;;
	current)
		echo "Current input device: $(pactl get-default-source)" 	
		echo "Current output device: $(pactl get-default-sink)"
	;;
	list)
		if [ $2 == "input" ]; then
			pactl list | grep "Monitor" | grep "pci" | grep ".monitor" | while IFS= read -r line; do
				device_info=$(echo "$line" | awk '{print $NF}')
				echo "$device_info"
			done
		elif [ $2 == "output" ]; then
			pactl list | grep "Monitor" | grep "pci" | grep -v ".monitor" | while IFS= read -r line; do
				device_info=$(echo "$line" | awk '{print $NF}')
				echo "$device_info"
			done
		else
			echo "Incorrect Usage!"
			usage
		fi	
	;;
	select)
		if [ $# -eq 3 ]; then
			if [ $2 == "input" ]; then
				pactl set-default-source $3
			elif [ $2 == "output" ]; then
				pactl set-default-sink $3
			else
				echo "Incorrect Usage!"
				usage
			fi
		else
			echo "Incorrect Usage!"
			usage
		fi
	;;
	*)
		echo "Incorrect Usage!"
		usage
	;;
esac
