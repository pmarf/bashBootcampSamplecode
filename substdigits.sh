#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code which replaces digits 0-9 with their textual representation
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

declare -A translate

while IFS='=' read -r digit text; do
	if [[ -z $digit ]]; then
		continue   # skip empty lines
	fi
	translate["$digit"]="$text"
done <<'EOF'
0=zero
1=one
2=two
3=thre
4=four
5=five
6=six
7=seven
8=eight
9=nine
EOF

if (( $# == 0 )); then
	error "Missing filename"
fi

if [[ ! -e "$1" ]]; then
	echo "$1 not found"
fi

while read -r line; do
	for (( i=0; i<${#line}; i++ )); do
		char=${line:i:1}
		if [[ -v translate["$char"] ]]; then
			echo -n "${translate["$char"]}"
		else
			echo -n "$char"
		fi
	done
	echo
done < "$1"
