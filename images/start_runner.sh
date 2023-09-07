#!/bin/bash

GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
REG_TOKEN=$REG_TOKEN
RUNNER_NAME=$RUNNER_NAME
RUNLABEL=$RUNLABEL

cd /home/docker/actions-runner

./config.sh --unattended --ephemeral --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels ${RUNLABEL}

cleanup() {
    echo "Removing runner..."
        ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
#bash