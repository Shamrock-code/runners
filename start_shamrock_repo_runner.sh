DIRRUNNER=$(realpath $(dirname "$0")/.runner)
echo $DIRRUNNER

rm -rf $DIRRUNNER
mkdir -p $DIRRUNNER

cd $DIRRUNNER
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.315.0/actions-runner-linux-x64-2.315.0.tar.gz
tar xzf ./actions-runner-linux-x64.tar.gz

sudo ./bin/installdependencies.sh


RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
RUNNER_NAME="$(hostname)-${RUNNER_SUFFIX}"

GH_OWNER=tdavidcl
GH_REPOSITORY=Shamrock

echo " ------------ Config ------------"
echo "GH_OWNER = ${GH_OWNER}"
echo "GH_REPOSITORY = ${GH_REPOSITORY}"
echo "RUNNER_NAME = ${RUNNER_NAME}"
echo " ------------ ------ ------------"

echo "-> getting github runner token"
REP=$(gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$GH_OWNER/$GH_REPOSITORY/actions/runners/registration-token)

echo " Rep = ${REP}"

REG_TOKEN=$(echo $REP | jq .token --raw-output)

echo $REG_TOKEN


echo " ------------ testing Docker ------------"
docker run hello-world
echo " ------------ ------------ ------------"
echo ""

echo " ---------- Starting runner -----------"
GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY
REG_TOKEN=$REG_TOKEN
RUNNER_NAME=$RUNNER_NAME

./config.sh --unattended --ephemeral --url https://github.com/${GH_OWNER}/${GH_REPOSITORY} --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels docker-runner

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
echo " ---------- End runner -----------"