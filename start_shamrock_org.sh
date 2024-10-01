DIRRUNNER=$(realpath $(dirname "$0")/.runner)
echo $DIRRUNNER

rm -rf $DIRRUNNER
mkdir -p $DIRRUNNER

cd $DIRRUNNER
curl -o actions-runner-linux-x64.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz
tar xzf ./actions-runner-linux-x64.tar.gz

sudo ./bin/installdependencies.sh


RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
RUNNER_NAME="$(hostname)-${RUNNER_SUFFIX}"

ORGANIZATION=Shamrock-code

echo " ------------ Config ------------"
echo "ORGANIZATION = ${ORGANIZATION}"
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

echo $REG_TOKEN


echo " ------------ testing Docker ------------"
docker run hello-world
echo " ------------ ------------ ------------"
echo ""

echo " ---------- Starting runner -----------"
ORGANIZATION=$ORGANIZATION
REG_TOKEN=$REG_TOKEN
RUNNER_NAME=$RUNNER_NAME

./config.sh --unattended --url https://github.com/$ORGANIZATION --token ${REG_TOKEN} --name ${RUNNER_NAME} --labels docker-runner

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
echo " ---------- End runner -----------"
