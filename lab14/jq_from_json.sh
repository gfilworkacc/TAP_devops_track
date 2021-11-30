#!/usr/bin/env bash

#Variables

#Functions

curl_and_jq () {
	curl --silent "https://jsonplaceholder.typicode.com/comments" | jq '[.[]| select (.postId == 66)] |.[] | select (.id > 327) | .email,.body'
}

#Main code

curl_and_jq

