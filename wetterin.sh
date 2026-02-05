#!/usr/bin/env bash
#######################################################################################################################
#
#	Sample bash code which retrieves coordinates of a city and retrieves temperature and windspeed and -direction
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

source functions.sh	# helperfunctions

declare -r PS4='|${LINENO}> \011${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

readonly OPENSTREATMAP_URL="https://nominatim.openstreetmap.org"
readonly OPENMETEO_URL="https://api.open-meteo.com"

readonly DEBUG=0	# set to 1 to enable debug output of received curl data

jqAvailable=0
if which jq > /dev/null; then	# sudo apt install jq
	jqAvailable=1
fi	

cityWeather() {
	
	local city resultCity resultWeather latitude longitude temperature winddirection windspeed
	if (( $# == 0 )); then
		error "Missing city"
	fi

	city="$1"

	resultCity="$(curl -s ${OPENSTREATMAP_URL}/search?q="$city"\&format=json\&limit=1)"
	if [[ "$resultCity" == "[]" ]]; then
		error "$city not found"
	fi
	
	if (( DEBUG )); then
		if (( jqAvailable )); then
			jq <<< "$resultCity"
		else
			echo "$resultCity"
		fi
	fi

	if (( jqAvailable )); then
		if ! latitude="$(jq -r .[0].lat <<< "$resultCity")"; then
			error "Unable to parse $latitude"
		fi
		longitude="$(jq -r .[0].lon <<< "$resultCity")"	
		
	elif [[ "$resultCity" =~ \"lat\":\"([0-9\.]+)\".+\"lon\":\"([0-9\.]+)\" ]]; then
		latitude=${BASH_REMATCH[1]}
		longitude=${BASH_REMATCH[2]}
	else
		error "Unable to find latitude and logitude for $city"
	fi	

	echo "Found lat $latitude and lon $longitude for $city"

	if ! resultWeather="$(curl -s $OPENMETEO_URL/v1/forecast?latitude="$latitude"\&longitude="$longitude"\&current_weather=true)"; then
		error "Weather data not found for $city"
	fi	

	if (( DEBUG )); then
		if (( jqAvailable )); then
			jq <<< "$resultWeather"
		else
			echo "$resultWeather"
		fi
	fi

	if (( jqAvailable )); then
		temperature="$(jq -r '.current_weather.temperature' <<< "$resultWeather")"
		windspeed="$(jq -r '.current_weather.windspeed' <<< "$resultWeather")"	
		winddirection="$(jq -r '.current_weather.winddirection' <<< "$resultWeather")"	
		
	elif [[ "$resultWeather" =~ \"temperature\":([\-0-9\.]+).+\"windspeed\":([0-9\.]+).+\"winddirection\":([0-9\.]+) ]]; then
		temperature=${BASH_REMATCH[1]}
		windspeed=${BASH_REMATCH[2]}
		winddirection=${BASH_REMATCH[3]}
		
	else
		error "Unable to find temp, windspeed and winddirection for $city"
	fi	

	echo "Found temp $temperature, windspeed $windspeed and winddirection $winddirection for $city"
}

if (( $# != 0 )); then
	cityWeather "$1"
else
	cities="Hamburg Berlin Frankfurt München Kiew Peking"
	for city in $cities; do
		cityWeather "$city"
	done
fi	
