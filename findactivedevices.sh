#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code which scans for active slocal systems
#
#######################################################################################################################
#
#    Copyright (c) 2026 https://github.com/pmarf
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#######################################################################################################################

declare -r PS4='|${LINENO}> \011${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

source functions.sh # helperfunctions

declare -A names
declare -A ips

sortrequested=0
if [[ "$2" == "-i" || "$2" == "-n" ]]; then
	sortrequested=1
	sortrequest="$2"
fi

while read -r line; do

	name="$(cut -f 5 -d " " <<< "$line")"
	ip="$(cut -f 6 -d " " <<< "$line" | tr -d '()')"

	if (( ! sortrequested )); then
		echo "$name $ip"
	fi

	if [[ -n "$name" && -n "$ip" ]]; then
		names["$name"]="$ip"
		ips["$ip"]="$name"
	fi

done < <(nmap -sP "$1" | grep -i "scan report")

if (( sortrequested )); then

	sortfilename="$(mktemp)"

	case $sortrequest in
	
	"-n") echo "name sorted"
		for name in "${!names[@]}"; do
			echo "$name" >> "$sortfilename"
		done

		while read -r name; do 
			echo "$name: ${names["$name"]}"
		done < <(sort "$sortfilename")
		;;

	"-i") echo "IP sorted"
		for ip in "${!ips[@]}"; do
			echo "$ip" >> "$sortfilename"
		done

		while read -r ip; do 
			echo "$ip: ${ips["$ip"]}"
		done < <(sort -V "$sortfilename")
		;;
	esac

	rm "$sortfilename"
fi
