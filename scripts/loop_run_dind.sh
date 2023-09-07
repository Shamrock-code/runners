#!/bin/bash

while :
do
  
  echo restarting
  GH_OWNER=tdavidcl GH_REPOSITORY=shamrock ImageName=shamrunner-dind sh start_docker.sh
  echo sleeping
  sleep 5
  
done