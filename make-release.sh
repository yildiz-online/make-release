#!/bin/bash

source release.txt

echo "Preparing a new release..."

git clone https://github.com/$REPO_OWNER_NAME/$REPO
git config --global user.name "$REPO_OWNER_NAME"
git config --global user.email "$REPO_OWNER_EMAIL"
cd $REPO
mvn versions:set -DremoveSnapshot=true
git commit pom.xml -m "[YE-0] Release"
git checkout master
git merge -X theirs develop
git push origin master
git checkout develop
mvn versions:set -DnextSnapshot=true
git commit pom.xml -m "[YE-0] Prepare next development version."
git push

echo "Release complete."
