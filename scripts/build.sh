if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    exit 0
fi

echo "building and publishing docker image";

DOCKER_REPO="leankit/cowpoke"
GIT_SHORT_COMMIT=$(git rev-parse --short HEAD)
APP_VERSION=$(node -e "console.log(require('./package.json').version);")
DOCKER_TAG=""

#create release tag or testing tag based off the current branch
if [ "$TRAVIS_BRANCH" = "master" ]; then
    DOCKER_TAG="v${APP_VERSION}"
else
    DOCKER_TAG="${TRAVIS_BRANCH}_${APP_VERSION}"
    #TODO: add ability to detect CI build context (Travis, Drone, etc) and pull specific build number vars
    if [ -n "$TRAVIS_BUILD_NUM" ]; then
        DOCKER_TAG="${DOCKER_TAG}_${TRAVIS_BUILD_NUM}_${GIT_SHORT_COMMIT}"
    else
        DOCKER_TAG="${DOCKER_TAG}_${GIT_SHORT_COMMIT}"
    fi
fi

DOCKER_IMAGE="${DOCKER_REPO}:${DOCKER_TAG}"
docker build --rm=false -t ${DOCKER_IMAGE}:${DOCKER_TAG} .

echo $DOCKER_IMAGE
