#!/bin/bash

source release.txt

echo "----------------------------------------------------------------"
echo "                     Cloninig repository.                       "
echo "----------------------------------------------------------------"

git clone https://github.com/$REPO_OWNER_NAME/$REPO
cd $REPO
echo "----------------------------------------------------------------"
echo "                        Adding remote.                          "
echo "----------------------------------------------------------------"
git remote add myrepo https://$GH_TOKEN@github.com/$REPO_OWNER_NAME/$REPO
echo "----------------------------------------------------------------"
echo "                   Set new release version.                     "
echo "----------------------------------------------------------------"
mvn versions:set -DremoveSnapshot=true -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
git commit pom.xml -m "[YE-0] Release"
echo "----------------------------------------------------------------"
echo "                   Checkout master branch.                      "
echo "----------------------------------------------------------------"
git checkout master
git merge -X theirs develop
git push --set-upstream myrepo master 
echo "----------------------------------------------------------------"
echo "                  Checkout develop branch.                      "
echo "----------------------------------------------------------------"
git checkout develop
echo "----------------------------------------------------------------"
echo "                Set new snapshot version.                       "
echo "----------------------------------------------------------------"
mvn versions:set -DnextSnapshot=true -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
git commit pom.xml -m "[YE-0] Prepare next development version."
git push --set-upstream myrepo develop 

echo "Release complete."
