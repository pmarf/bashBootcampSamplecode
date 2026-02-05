#!/usr/bin/env bash

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

	result="$(nextTrial $NUMBER $trial $trialCount $min $max)"
	if (( $? == 0 )); then
		echo "! Found $NUMBER in $trialCount trials"
		#exit 0
		break
	else
		read -r trialCount min max <<< "$result"
	fi
done

myTrials="$trials"

min="$LOW"
max="$HIGH"

found=0
trialCount=1
(( trial = min+(max-min)/2 ))

echo "Computer trials ..."
while :; do
	echo -n "$trial "
	result="$(nextTrial $NUMBER $trial $trialCount $min $max)"
	if (( $? == 0 )); then
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
elif (( myTrials > trial )); then
	echo "$(( myTrials -trialCount )) trials better than computer"
else 
	echo "$(( trialCount - myTrials )) trials worse than computer"
fi
