set -e

RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
RUNNER_NAME="$(hostname)-${RUNNER_SUFFIX}"

GH_ORGA=tdavidcl
GH_REPOSITORY=Shamrock

echo " ------------ Config ------------"
echo "GH_ORGA = ${GH_ORGA}"
echo "RUNNER_NAME = ${RUNNER_NAME}"
echo " ------------ ------ ------------"

echo "-> getting github runner token"
REP=$(gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  orgs/${ORGANIZATION}/actions/runners/registration-token)

echo " Rep = ${REP}"

REG_TOKEN=$(echo $REP | jq .token --raw-output)

echo " REG_TOKEN = $REG_TOKEN"

echo " ------------ Building image ------------"
docker build -t testing-runner .
echo " ----------------------------------------"

echo " ----------- Starting runner ------------"
docker run --privileged -ti \
  -e GH_GIT_URL=${ORGANIZATION} \
  -e REG_TOKEN=$REG_TOKEN \
  -e RUNNER_NAME=$RUNNER_NAME \
  -e GHLABELS=docker-runner \
  testing-runner
echo " ----------------- Done -----------------"
