#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code which counts characters in a file and prints the sorted frequency 
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

source functions.sh # helperfunctions

declare -r PS4='|${LINENO}> \011${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

declare -A frequency

if (( $# == 0 )); then
	error "Missing filename"
fi

if [[ ! -e "$1" ]]; then
	echo "$1 not found"
fi

filename="$1"
sumchars=0

while read -r line; do
	for (( i=0; i<${#line}; i++ )); do
		(( sumchars++ ))
		char=${line:i:1}
		if [[ -v frequency[$char] ]]; then
			(( frequency[$char]++ ))
		else
			(( frequency[$char]=1 ))
		fi
	done
done < "$filename"

echo "Sum chars: $sumchars"

sortfilename="$(mktemp)"
unprintable=0
for char in "${!frequency[@]}"; do
	count="${frequency[$char]}"
	frequency="$(bc <<< "scale=2; ( $count / $sumchars ) * 100")"
	if [[ $char =~ [[:print:]] ]]; then
		echo "$char $frequency $count" >> "$sortfilename"
	else
		(( unprintable++ ))
	fi		
done
frequency="$(bc <<< "scale=2; ( $unprintable / $sumchars ) * 100")"
echo "NOP $frequency $unprintable" >> "$sortfilename"

sort -n -r -k 3 "$sortfilename"

rm "$sortfilename"
