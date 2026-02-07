#!/usr/bin/env bash
#######################################################################################################################
#
#   Sample bash code functions 
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

declare -r PS4='|${LINENO}> \011${FUNCNAME[0]:+${FUNCNAME[0]}(): }'     # enhance debug message with line numbers

error() {
    echo "$@" >&2                                           # print the passed text to stderr
    if (( $# == 1 )); then                                  # if no second parameter was passed just exit
        exit 1
    else
        return 1                                            # and otherwise just return error
    fi
}

isInteger() { # number                                      # use regex to check if passed text is an integer
    [[ "$1" =~ ^[0-9]+$ ]]                                  # return 0 (success) and 1 (failure)
}
