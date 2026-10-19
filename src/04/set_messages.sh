#!/bin/bash

set_messages () {
	values=(1 6 5 4)
	colors=("default (white)" "default (black)" "default (purple)" "default (blue)")

	counter=0
	for param in "$@"; do
		case "$param" in
			1) colors[$counter]="(white)" ;;
			2) colors[$counter]="(red)" ;;
			3) colors[$counter]="(green)" ;;
			4) colors[$counter]="(blue)" ;;
			5) colors[$counter]="(purple)" ;;
			6) colors[$counter]="(black)" ;;
		esac
		if [[ $param ]]; then 
		       values[$counter]=$param
		fi
		((counter++))
	done	

	message1="Column 1 background = ${values[0]} ${colors[0]}"
	message2="Column 1 font color = ${values[1]} ${colors[1]}"
	message3="Column 2 background = ${values[2]} ${colors[2]}"
	message4="Column 2 font color = ${values[3]} ${colors[3]}"
}
