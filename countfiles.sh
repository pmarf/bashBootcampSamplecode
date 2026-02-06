#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code which counts number of files with a given extension
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

if (( $# < 1 )); then
	error "Missing directory and optional extension"
fi

directory="$1"
extension="${2:-"*.sh"}"

echo "Found $(find "$directory" -iname "$extension" | wc -l) files with extension $extension in $directory"
