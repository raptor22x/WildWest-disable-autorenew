#!/bin/bash
#
# Author: Jose Villasenor
# Date: Februrary 26, 2019
# Description: Batch disable of auto-renew of domains in provided list. 

#### VARIABLES #####
domainList=$1
apikey="INSERT KEY HERE"
apisecret="INSERT SECRET HERE"
apiEndPoint="https://api.godaddy.com/v1/domains"
errorDir=errorLog


###### CHECKS ######
#### DOES SOURCE DOMAIN FILE EXIST
##### IF SO, IS IT EMPTY
if [ -z "$domainList" ]
then
 echo -e "Please provide a file with list of domains\n"
 echo -e "Usage: $0 path-to-file\n\n"
 exit
elif [ ! -s "$domainList" ]
then
        echo -e "\n File is empty\n"
        exit
fi

##### CHECK API KEY AND SECRET ARE POPULATED WITH APPROPRIATE API INFO
if [ "$apikey" == "INSERT KEY HERE" ] || [ "$apisecret" == "INSERT SECRET HERE" ]; then
	echo -e "\n ************************************ \n- APIKEY and/or APISECRET are not set -\n ************************************ \n"
	exit
fi

##### CREATE ERROR DIRECTORY IF IT DOES NOT EXIST
if [ ! -d $errorDir ]; then
	mkdir $errorDir
fi

##### ERROR DIRECTORY IS NOT EMPTY, MANUAL DELETE REQUIRE
if [ "$(ls -A $errorDir)" ]; then
	echo "$errorDir directory is not empty. Please clear directory"
	echo "execute: rm -f $errorDir/*"
	exit
fi


#####  PROCESS DOMAIN LIST AND REPORT ANY ERRORS
while read domain; do
	results=$(curl -s -X PATCH -H "accept: application/json" -H "Content-Type: application/json" -H "Authorization: sso-key ${apikey}:${apisecret}" -d "{ \"renewAuto\": false }" "${apiEndPoint}/$domain")
	if [ ! -z "$results" ]; then
		echo -e "\nError with disabling auto-renew on $domain: \n Please review log file $domain.log"
		echo "$results" > $errorDir/$domain.log
	else
		echo -e "\n$domain auto-renew is disabled"
	fi
done < $domainList

