#!/usr/bin/env bash

#Variables
dockerfile_folder="/home/infinte_lambda_work_acc/bin/TAP_devops_track/docker_and_virtualization_lab5/app"
image_name="todo-manager:latest"
vol_name="todo-vol"

#Stop and destroy the containers
docker stop manager-instance-{1..3}
docker rm manager-instance-{1..3}

#Destroy and recreate todo-vol
docker volume rm "$vol_name"
docker volume create --name "$vol_name" 

#Create the containers
docker create -p 127.0.0.1:3001:3000 --name manager-instance-1 --mount source="$vol_name",target=/etc/todos "$image_name" 
docker create -p 127.0.0.1:3002:3000 --name manager-instance-2 --mount source="$vol_name",target=/etc/todos "$image_name" 
docker create -p 127.0.0.1:3003:3000 --name manager-instance-3 --mount source="$vol_name",target=/etc/todos "$image_name" 

#Copy the backup to container manager-instance-1
docker cp $(echo "$dockerfile_folder" | sed 's/app/backup/')/todo.db manager-instance-1:/etc/todos/todo.db

#Start the containers
docker start  manager-instance-{1..3}
