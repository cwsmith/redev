#!/bin/sh
set -e

SITE=redev
BRANCH=gh-pages

if [ -d $SITE ]; then
   cd $SITE && git checkout . && git clean -df && git pull && cd ..
else
   git clone git@github.com:SCOREC/${SITE}.git
fi || {
   echo "Error cloning/updating '$SITE'."
   exit 1
}

if [ ! -d pyEnv ]; then
  python3 -m venv pyEnv
  source pyEnv/bin/activate
  python -m pip install sphinx-rtd-theme
  python -m pip install breathe
  python -m pip install sphinx-sitemap
  python -m pip install sphinx
else
  source pyEnv/bin/activate
fi

cd $SITE/docsDoxySphinx
make html
git checkout gh-pages
cp -r build/html docs
git add -A docs
git commit -m "Deploying the Redev documentation"
git push

