#!/bin/bash

# exit on failures and undeclared variables, echo commands
set -o errexit
set -o nounset
set -o pipefail

export MARKDOWN_SOCKET=/tmp/markdown
CMS=/home/builder/cms
VELOCITY=/home/velocity

# launch markdown daemon
$CMS/build/markdownd.py

# erase temporary files and target directory
find $VELOCITY/velocity-site/src/content -name "*~" | xargs -r rm
rm -rf $VELOCITY/velocity-site-target/* $VELOCITY/velocity-site-target/.htaccess

echo Generating site...

$CMS/build/build_site.pl --source-base $VELOCITY/velocity-site/src --target-base $VELOCITY/velocity-site/target

echo Copying to production directory...

rm -rf $VELOCITY/velocity-site-prod/* $VELOCITY/velocity-site-prod/.htaccess
cp -r $VELOCITY/velocity-site/target/content/* $VELOCITY/velocity-site-prod/
cp -r $VELOCITY/velocity-site/target/content/.htaccess $VELOCITY/velocity-site-prod/

echo Post processing...

find $VELOCITY/velocity-site-prod/ -name "*.html" | xargs sed -ri -e "s'<span></span>''g"

