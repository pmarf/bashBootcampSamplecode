#!/usr/bin/env bash
#######################################################################################################################
#
#   Sample bash code which scans for active local systems
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

source functions.sh                                                         # source helperfunctions

declare -A names                                                            # dictionary for the DNS names
declare -A ips                                                              # dictionary for the IPs

if (( $# == 0 )); then
    error "Missing subnet, e.g. 192.168.178.0/24 and optional args -i or -n"
fi

sortrequested=0
if [[ -n "$2"&& ( "$2" == "-i" || "$2" == "-n" ) ]]; then                   # check if a second parameter was passed to define the sort sequence
    sortrequested=1
    sortrequest="$2"
fi

while read -r line; do                                                      # process the result of nmap

    name="$(cut -f 5 -d " " <<< "$line")"                                   # extract name
    ip="$(cut -f 6 -d " " <<< "$line" | tr -d '()')"                        # extract ip

    if (( ! sortrequested )); then
        echo "$name $ip"
    fi

    if [[ -n "$name" && -n "$ip" ]]; then                                   # skip systems if there does not exist a DNS or IP
        names["$name"]="$ip"
        ips["$ip"]="$name"
    fi

done < <(nmap -sP "$1" | grep -i "scan report")                             # scan the local network for active systems

if (( sortrequested )); then

    sortfilename="$(mktemp)"                                                # create temporary filename in /tmp

    case $sortrequest in
    
    "-n") echo "name sorted"                                                # sort dictionary contents according name
        for name in "${!names[@]}"; do
            echo "$name" >> "$sortfilename"
        done

        while read -r name; do 
            echo "$name: ${names["$name"]}"
        done < <(sort "$sortfilename")
        ;;

    "-i") echo "IP sorted"                                                  # sort dictionary contents according IP
        for ip in "${!ips[@]}"; do
            echo "$ip" >> "$sortfilename"
        done

        while read -r ip; do 
            echo "$ip: ${ips["$ip"]}"
        done < <(sort -V "$sortfilename")                                   # note option -V to sort the IPs the correct way ;-)
        ;;
    esac

    rm "$sortfilename"                                                      # cleanup
fi
