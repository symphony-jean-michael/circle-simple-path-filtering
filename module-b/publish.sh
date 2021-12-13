#!/bin/bash
set -e
# Execute publish
function executePublish {
    cp package.json dist/
    cp README.md dist/
    cd dist
    yarn pack
    cd ..
    git add package.json
    git config --global user.email "$GIT_USEREMAIL"
    git config --global user.name "$GIT_USERNAME"
    git commit -m "[skip ci] AUTO Bump version"
    git push origin HEAD:master3
}

# Set version
function setVersion {
    echo "Found tag, setting version to $CIRCLE_TAG"
    yarn version --no-git-tag-version --new-version ${CIRCLE_TAG//v}
}

# Version and publish logic
function publish() {
    echo "Running publish..."
    setVersion;
    executePublish;
    echo "Publish End"
}

# ====> Start
if [ -z "$CIRCLE_TAG" ]; then
    echo "No tag, skip publish ..."
    exit 0;
else
    publish
fi

