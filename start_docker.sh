RUNNER_SUFFIX=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 8 | head -n 1)
RUNNER_NAME="dockerNode-${RUNNER_SUFFIX}"

GH_OWNER=$GH_OWNER
GH_REPOSITORY=$GH_REPOSITORY

echo $GH_OWNER
echo $GH_REPOSITORY
echo $RUNNER_NAME
echo $ImageName

REP=$(gh api \
  --method POST \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  /repos/$GH_OWNER/$GH_REPOSITORY/actions/runners/registration-token)


echo $REP

REG_TOKEN=$(echo $REP | jq .token --raw-output)

echo $REG_TOKEN

docker run -ti --rm -e GH_OWNER=$GH_OWNER -e GH_REPOSITORY=$GH_REPOSITORY -e REG_TOKEN=$REG_TOKEN -e RUNNER_NAME=$RUNNER_NAME $ImageName
