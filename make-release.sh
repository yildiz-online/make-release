#!/bin/bash

source release.txt

echo "Preparing a new release..."

git clone https://github.com/$REPO_OWNER_NAME/$REPO
git config --global user.name "$REPO_OWNER_NAME"
git config --global user.email "$REPO_OWNER_EMAIL"
cd $REPO
git remote add myrepo https://$GH_TOKEN@github.com/$REPO_OWNER_NAME/$REPO
mvn versions:set -B -q -DremoveSnapshot=true
VERSION=`cd $project_loc && mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | sed -n -e '/^\[.*\]/ !{ /^[0-9]/ { p; q } }'`
git commit pom.xml -m "[YE-0] Release $VERSION"
git checkout master
git merge -X theirs develop
git push --quiet --set-upstream myrepo master 
git checkout develop
mvn versions:set -B -q -DnextSnapshot=true
git commit pom.xml -m "[YE-0] Prepare next development version."
git push --quiet --set-upstream myrepo develop 

echo "Release complete."
