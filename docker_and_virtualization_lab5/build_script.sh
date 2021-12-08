#!/usr/bin/env bash

#Build the image
dockerfile_folder="/home/infinte_lambda_work_acc/bin/TAP_devops_track/docker_and_virtualization_lab5/app"
image_name="todo-manager:latest"
docker build -t "$image_name" "$dockerfile_folder"

#Create the volume
vol_name="todo-vol"
docker volume create --name "$vol_name" 

#Create the containers
docker run -dp 127.0.0.1:3001:3000 --name manager-instance-1 --mount source="$vol_name",target=/etc/todos "$image_name" 
docker run -dp 127.0.0.1:3002:3000 --name manager-instance-2 --mount source="$vol_name",target=/etc/todos "$image_name" 
docker run -dp 127.0.0.1:3003:3000 --name manager-instance-3 --mount source="$vol_name",target=/etc/todos "$image_name" 

#Setting the cron job to backup every hour and listing it
crontab -l > crontab_append
echo "0 * * * * /usr/bin/docker cp manager-instance-1:/etc/todos/todo.db $(echo "$dockerfile_folder" | sed 's/app/backup/')" >> crontab_append
crontab crontab_append
rm crontab_append
echo
crontab -l | tail -n 1
