#!/usr/bin/env bash

# Prevent ^C from being printed
stty -ctlecho

# Configuration
cse_dir=$( dirname $( readlink -f "${0}" ) )

cse_webapp="${cse_dir}/webapp/app.php"
cse_api="${cse_dir}/api.py"

cse_webapp_output="${cse_dir}/webapp/www/index.html"

cse_webapp_host="127.0.0.1"
cse_webapp_port=5010

cse_api_host="127.0.0.1"
cse_api_port=5020

# Exit routine
function cse_exit {
    # Delete HTML file
    if [ -f "${cse_webapp_output}" ]
    then
	rm "${cse_webapp_output}"
    fi   

    # Kill listeners
    kill ${cse_api_pid} ${cse_webapp_pid} 2> /dev/null

    echo -e "\nListeners stopped."
}
trap "cse_exit" SIGINT

# Check arguments
if ! [ -f "${1}" ]
then
    if [ -z "${1}" ] || [ -z "${2}" ]
    then
	echo "Usage: ${0} <source.css> <destination.css>"
    else
	echo "${1} is not a file."
    fi

    exit 22
fi

# Get colors
export cse_colors_list=$( grep -E -o '[0-9a-f]{6}\b' "${1}" | sort | uniq )

# Run API listener
. "${cse_dir}/env/bin/activate"
"${cse_api}" "${1}" "${2}" "${cse_api_host}" "${cse_api_port}" \
    > /dev/null \
    2> "${cse_dir}/api.log"  &
cse_api_pid=${!}
echo "API: http://${cse_api_host}:${cse_api_port}"

# Generate index
"${cse_webapp}" <( echo "${cse_colors_list}" ) \
    "http://${cse_api_host}:${cse_api_port}" \
    > "${cse_webapp_output}"

# Run WebApp listener
cd `dirname "${cse_webapp_output}"`
php -S "${cse_webapp_host}:${cse_webapp_port}" \
    > /dev/null \
    2> "${cse_dir}/webapp.log" &
cse_webapp_pid=${!}
echo "WebApp: http://${cse_webapp_host}:${cse_webapp_port}"

# Wait for servers
wait ${cse_api_pid} ${cse_webapp_pid}
