#!/usr/bin/env bash
# Push HTML files to gh-pages automatically.

# Fill this out with the correct org/repo
ORG=trufflesuite
REPO=proposal-artifacts-format
# This probably should match an email for one of your users.
NAME="Travis Deployer"
EMAIL="no-reply@trufflesuite.com"

set -e

DRY_RUN=
if [ "$1" != "dry" ]; then
  DRY_RUN="true"
fi


###############################################################################
# authenticate deployment
###############################################################################

setup_gh () {
  echo "Decrypting deploy key..."
  openssl aes-256-cbc \
    -K $encrypted_ed68d7c9ebd1_key \
    -iv $encrypted_ed68d7c9ebd1_iv \
    -in deploy-key.enc \
    -out deploy-key -d

  chmod 600 deploy-key

  echo "Configuring git..."
  eval `ssh-agent -s`
  ssh-add deploy-key
  git config user.name "${NAME}"
  git config user.email "${GIT_EMAIL}"
}


###############################################################################
# clone gh-pages branch
###############################################################################

clone_gh_pages () {
  echo "Cloning gh-pages branch..."

  # Clone the gh-pages branch outside of the repo and cd into it.
  cd ..
  git clone -b gh-pages "git@github.com:$ORG/$REPO.git" gh-pages
  cd gh-pages
}


###############################################################################
# copy docs build
###############################################################################

copy_docs () {
  local author
  local branch
  local directory

  if [ "${TRAVIS_PULL_REQUEST_SLUG}" != "" ];
  then
    author=$( dirname "${TRAVIS_PULL_REQUEST_SLUG}" )
  else
    author=$( dirname "${TRAVIS_REPO_SLUG}" )
  fi

  if [ "${TRAVIS_PULL_REQUEST_BRANCH}" != "" ];
  then
    branch="${TRAVIS_PULL_REQUEST_BRANCH}"
  else
    branch="${TRAVIS_BRANCH}"
  fi

  # nested directories for authors and branches
  directory="${author}/${branch}/"

  echo "Making gh-pages directory ${directory}..."
  # ensure output directory exists
  mkdir -p "${directory}"

  echo "Copying build output to ${directory}..."
  # copy gh-pages output
  cp -R ../${REPO}/_build/html/* ${directory}
}


###############################################################################
# add / commit / push
###############################################################################

publish () {
  echo "Committing..."
  # Add and commit changes.
  git add -A .
  git commit -m "Update docs"

  if [ "${DRY_RUN}" != "true" ]; then
    echo "Pushing..."
    git push origin gh-pages
  fi
}


###############################################################################
# main
###############################################################################

main () {
  setup_gh
  clone_gh_pages
  copy_docs
  publish
}

main
