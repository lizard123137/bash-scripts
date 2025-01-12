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
	echo -e "pa_dev_picker help\t\t\t\tdisplays this usage page." 
	echo -e "pa_dev_picker current\t\t\t\tshows the current input and output devices."
	echo -e "pa_dev_picker list (input|output)\t\tlists the available input/output devices."
	echo -e "pa_dev_picker select (input|output)\t\tlists the available input/output devices and lets the user select the desired one as the currently used one."
}

get_devices() {
	local devices=()

	if [[ $1 == "input" ]]; then
		while IFS= read -r line; do
			devices+=("$(echo "$line" | awk '{print $NF}')")
		done < <(pactl list | grep "Monitor" | grep "pci" | grep ".monitor")
	else	
		while IFS= read -r line; do
			devices+=("$(echo "$line" | awk '{print $NF}')")
		done < <(pactl list | grep "Monitor" | grep "pci" | grep -v ".monitor")
	fi

	echo "${devices[@]}"
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
		if [[ $2 == "input" ]]; then
			i=0
			for dev in $(get_devices $2); do
				let "i=i+1"
				echo "$i -> $dev"
			done
		elif [[ $2 == "output" ]]; then
			i=0
			for dev in $(get_devices $2); do
				let "i=i+1"
				echo "$i -> $dev"
			done
		else
			echo "Incorrect Usage!"
			usage
		fi	
	;;
	select)
		if [[ $2 == "input" ]]; then
			devices=($(get_devices $2))
			
			i=0
			for dev in "${devices[@]}"; do
				let "i=i+1"
				echo "$i -> $dev"
			done

			echo ""
			read -p "Select desired device number: " number
			n=$((number - 1))
			pactl set-default-source ${devices[n]}
		elif [[ $2 == "output" ]]; then
			devices=($(get_devices $2))

			i=0
			for dev in "${devices[@]}"; do
				let "i=i+1"
				echo "$i -> $dev"
			done
			i=0
				
			echo ""
			read -p "Select desired device number: " number
			n=$((number - 1))
			pactl set-default-sink ${devices[n]}
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
