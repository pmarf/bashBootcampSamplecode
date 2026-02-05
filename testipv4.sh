#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code which tests for a valid ipv4
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

isValidIPv4() {
	local -a nibbles
	
	IFS="." read -r -a nibbles <<< "$1"	
	
	if (( ${#nibbles[@]} != 4 )); then
		error "4 Nibbles required in $1" ""
		return 1
	fi
	
	for nibble in "${nibbles[@]}"; do
		if ! isInteger "$nibble"; then
			error "$nibble is not a valid nibble" ""
			return 1
		fi
		if (( nibble < 0 || nibble > 255 )); then
			error "$nibble in $1 is < 0 or > 255" ""
			return 1
		fi
	done
}

#	10.0.0.0 – 10.255.255.255 (Klasse A)
#	172.16.0.0 – 172.31.255.255 (Klasse B)
#	192.168.0.0 – 192.168.255.255 (Klasse C)
#	169.254.0.0 – 169.254.255.255 (Link-Local)

isLocalIPv4() {
	
	if ! isValidIPv4 "$1"; then
		error "$1 is no valid IPv4" ""
	fi
	
	local -a nibbles
	
	IFS="." read -r -a nibbles <<< "$1"	

	case "$1" in
	
		10*)
			return 0
			;;
		172*)
			(( nibbles[1] == 31 ))
			return 
			;;
		192*)
			(( nibbles[1] == 168 ))
			return 
			;;
		169*)
			(( nibbles[1] == 254 ))
			return 
			;;
		*)
			return 1
			;;
	esac
	
}

testIPv4() {
	if isValidIPv4 "$1"; then
		if isLocalIPv4 "$1"; then
			echo "$1 is a local IPv4 address"
		else
			echo "$1 is an external IPv4 address"	
		fi	
	fi
	}

if (( $# != 0 )); then
	testIPv4 "$1"
else
	ips="10.9.8.5 192.168.8.9 1.2.3.4 -4.6.7. 1.2.3.500 169.253.0.0 " 
	for ip in $ips; do
		echo "Testing $ip"
		testIPv4 "$ip"
	done

	
fi
