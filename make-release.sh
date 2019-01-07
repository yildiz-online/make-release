#!/bin/bash

source release.txt

echo "----------------------------------------------------------------"
echo "                     Cloninig repository.                       "
echo "----------------------------------------------------------------"

git clone https://github.com/$REPO_OWNER_NAME/$REPO --quiet
cd $REPO
echo "----------------------------------------------------------------"
echo "                        Adding remote.                          "
echo "----------------------------------------------------------------"
git remote add myrepo https://$GH_TOKEN@github.com/$REPO_OWNER_NAME/$REPO --quiet
echo "----------------------------------------------------------------"
echo "                   Set new release version.                     "
echo "----------------------------------------------------------------"
mvn versions:set -DnewVersion=$RELEASE_VERSION -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
git commit pom.xml -m "[YE-0] Release $RELEASE_VERSION" --quiet
echo "----------------------------------------------------------------"
echo "                   Checkout master branch.                      "
echo "----------------------------------------------------------------"
git checkout master --quiet
git merge -X theirs develop --quiet
git push --set-upstream myrepo master --quiet
echo "----------------------------------------------------------------"
echo "                  Checkout develop branch.                      "
echo "----------------------------------------------------------------"
git checkout develop --quiet
echo "----------------------------------------------------------------"
echo "                Set new snapshot version.                       "
echo "----------------------------------------------------------------"
mvn versions:set -DnewVersion=$DEV_VERSION -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn
git commit pom.xml -m "[YE-0] Prepare next development version $DEV_VERSION." --quiet
git push --set-upstream myrepo develop --quiet

echo "Release complete."
