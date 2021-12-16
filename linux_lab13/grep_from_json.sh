#!/usr/bin/env bash

#Variables

#Functions

curl_and_grep () {
	curl --silent "https://jsonplaceholder.typicode.com/comments" | egrep -i -A 5 "\"postId\": 66" | egrep -A 3 "32[89]|330" | egrep "email|body"
}

#Main code

curl_and_grep

