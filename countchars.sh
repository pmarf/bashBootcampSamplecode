#!/usr/bin/env bash
#######################################################################################################################
#
#   Sample bash code which counts characters in a file and prints the 10 most frequent characters
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

source functions.sh                                         # source helperfunctions

declare -A frequency                                        # dictionary which hols the count of every char

if (( $# == 0 )); then
    error "Missing filename"
fi

if [[ ! -e "$1" ]]; then
    echo "$1 not found"
fi

filename="$1"
sumchars=0

while read -r line; do                                      # process every line of file
    for (( i=0; i<${#line}; i++ )); do                      # process every char in line
        (( sumchars++ ))                                    # increase sum counter to have number of all chars read
        char=${line:i:1}
        if [[ -v frequency[$char] ]]; then                  # if char already detected
            (( frequency[$char]++ ))                        # increase counter
        else
            (( frequency[$char]=1 ))                        # else initialize counter
        fi
    done
done < "$filename"

echo "Sum chars: $sumchars"

sortfilename="$(mktemp)"                                    # create a temporary filename in /tmp
for char in "${!frequency[@]}"; do                          # loop over all keys/chars
    count="${frequency[$char]}"                             # retrieve the count
    (( frequency=(count * 100 ) / sumchars ))               # calculate frequency
    echo "${frequency} $count '$char' " >> "$sortfilename"  # append result to temporary file
done

sort -r -n -k1 -k2 "$sortfilename" > "${sortfilename}2"     # sort temporary file

head -n 10 "${sortfilename}2"                               # print first 10 chars

rm "${sortfilename}"*                                       # cleanup
