#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code of the calculation of fibonacci number recursive and interative
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

fak_r() {
	local fm1 result
	if (( $1 < 1 )); then
		echo "1"
	else
		(( fm1 = $1 -1 ))
		fm1="$(fak_r "$fm1")"
		(( result =$1 * fm1 ))
		echo "$result"
	fi
}

fak_i() {
	local result=1
	for ((i=2; i<=$1; i++)); do
		(( result *= i ))
	done
	echo "$result"
}

fibonacci() { # number

	local result

	if (( $# == 0 )); then
		error "Missing number"
	fi

	if (( $1 < 0 || $1 > 20 )); then
		error "Number out of bounds"
	fi	

	result="$(fak_r "$1")"
	echo -n "$1! = $result (recursive)"

	echo
	result=$(fak_i "$1")
	echo -n "$1! = $result (iterative)"
	echo
}

if (( $# != 0 )); then
	fibonacci "$1"
else
	for i in $(seq 0 5 20);do
		fibonacci "$i"
	done
fi	

