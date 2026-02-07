#!/usr/bin/env bash
#######################################################################################################################
#
#   Sample bash code of a high low implementation to demonstrate some bash capabilities
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

source functions.sh                                                                     # source helperfunctions

LOW=0                                                                                   # lower and upper bound
HIGH=100
NUMBER=$(( RANDOM % ( HIGH + 1 ) ))                                                     # number to find

nextTrial() { # number trial trialCount min max                                         # execute a trial sequence and return the updated trial count and new min and max
    local number trial trialCount min max
    
    read -r number trial trialCount min max <<< "$*"                                    # extract the parameters passed into variables
    
    if (( number != trial )); then                                                      # number not found
        (( trialCount++ ))                                                              # another trial executed
        if (( trial < number )); then                                                   # update min
            (( min=trial+1 ))
        else
            (( max=trial-1 ))                                                           # update max
        fi
        echo "$trialCount $min $max"                                                    # return the modified variables
        return $(( number != trial ))                                                   # and whether the number was found
    fi
}

demo=0
if (( $# == 1 )); then                                                                  # if "demo" is passed the games was executed by script
    if [[ "$1" == "demo" ]]; then
        demo=1
    elif ! isInteger "$1"; then
        error "$1 is no integer"
    else
        HIGH="$1"
    fi
fi

min="$LOW"
max="$HIGH"
trialCount=1

if (( !demo )); then
    while :; do
        inputOK=0                                                                               # var to check input
        while (( ! inputOK )); do
            read -r -p "Trial $trialCount: Enter a number between $min and $max -> " trial      # read trial
            if isInteger "$trial"; then                                                         # and check input
                if (( trial < min )) || (( trial > max )); then
                    echo "? Trial $trial not betwwen $min and $max"
                else
                    inputOK=1
                fi
            else
                echo "? Invalid number $trial"
            fi
        done

        if result="$(nextTrial "$NUMBER" "$trial" "$trialCount" "$min" "$max")"; then           # now exeute a trial sequence
            echo "! Found $NUMBER in $trialCount trials"
            break
        else
            read -r trialCount min max <<< "$result"                                            # no success, update local variables with new values
        fi
    done

    myTrials="$trialCount"                                                                      # remember the trial number for comparison with script trials
fi  

min="$LOW"
max="$HIGH"

# now execute high low by code

trialCount=1
(( trial = min+(max-min)/2 ))                                                                   # start in the middle

echo "Computer trials ..."
while :; do
    echo -n "$trial->"
    if result="$(nextTrial $NUMBER "$trial" "$trialCount" "$min" "$max")"; then
        echo
        echo "! Found $NUMBER in $trialCount trials"
        break
    else
        read -r trialCount min max <<< "$result"
        (( trial = min+(max-min)/2 ))
    fi
done

if (( ! demo )); then
    if (( myTrials == trialCount )); then
        echo "Identical trials $trialCount"
    elif (( myTrials > trialCount )); then
        echo "$(( myTrials - trialCount )) trials worse than computer"
    else 
        echo "$(( trialCount - myTrials )) trials better than computer"
    fi
fi
