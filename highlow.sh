#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code for a high low implementation to demonstrate some bash capabilities
#
#######################################################################################################################
#
#    Copyright (c) 2026 
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

LOW=0
HIGH=100
NUMBER=$(( RANDOM % ( HIGH + 1 ) ))

isInteger() { # number
	[[ "$1" =~ ^[0-9]+$ ]]
}

error() {
	echo "$@" >&2
	exit 1
}

nextTrial() { # number trial trialCount min max
	local number trial trialCount min max
	
	read -r number trial trialCount min max <<< "$*"
	
	if (( number != trial )); then
		(( trialCount++ ))
		if (( trial < number )); then
			(( min=trial+1 ))
		else
			(( max=trial-1 ))
		fi
		echo "$trialCount $min $max"
		return $(( number != trial ))
	fi
}

if (( $# == 1 )); then
	if ! isInteger "$1"; then
		error "$1 is no integer"
	fi
	HIGH="$1"
fi

min="$LOW"
max="$HIGH"
trialCount=1

while :; do
	inputOK=0
	while (( ! inputOK )); do
		read -r -p "Trial $trialCount: Enter a number between $min and $max -> " trial
		if isInteger "$trial"; then
			if (( trial < min )) || (( trial > max )); then
				echo "? Trial $trial not betwwen $min and $max"
			else
				inputOK=1
			fi
		else
			echo "? Invalid number $trial"
		fi
	done

	if result="$(nextTrial "$NUMBER" "$trial" "$trialCount" "$min" "$max")"; then
		echo "! Found $NUMBER in $trialCount trials"
		break
	else
		read -r trialCount min max <<< "$result"
	fi
done

myTrials="$trialCount"

min="$LOW"
max="$HIGH"

trialCount=1
(( trial = min+(max-min)/2 ))

echo "Computer trials ..."
while :; do
	echo -n "$trial "
	if result="$(nextTrial $NUMBER "$trial" "$trialCount" "$min" "$max")"; then
		echo
		echo "! Found $NUMBER in $trialCount trials"
		break
	else
		read -r trialCount min max <<< "$result"
		(( trial = min+(max-min)/2 ))
	fi
done

if (( myTrials == trialCount )); then
	echo "Identical trials $trialCount"
elif (( myTrials > trialCount )); then
	echo "$(( myTrials - trialCount )) trials worse than computer"
else 
	echo "$(( trialCount - myTrials )) trials better than computer"
fi
