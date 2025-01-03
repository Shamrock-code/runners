#!/bin/bash
/usr/local/bin/entrypoint.sh

echo "------------ testing Docker ------------"
docker run hello-world
echo "------------ ------------ ------------"
echo ""

echo "---------- Starting runner -----------"
echo "GH_GIT_URL =$GH_GIT_URL"
echo "REG_TOKEN  =$REG_TOKEN"
echo "RUNNER_NAME=$RUNNER_NAME"
echo "GHLABELS   =$GHLABELS"

export RUNNER_ALLOW_RUNASROOT="1"

echo "Running cmd : ./config.sh --unattended --url https://github.com/${GH_GIT_URL} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels ${GHLABELS}"
./config.sh --unattended --url https://github.com/${GH_GIT_URL} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels ${GHLABELS}

cleanup() {
    echo "Removing runner..."

    echo "Running cmd : ./config.sh remove --token ${REG_TOKEN}"
    ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

echo "Running cmd : ./run.sh & wait $!"
./run.sh & wait $!

echo "---------- End runner -----------"
