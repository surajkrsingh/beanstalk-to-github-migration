#!/bin/bash

# CONFIGURE THIS
GITHUB_ORG="abc"
VISIBILITY="private"  # or "public"
REPO_LIST="beanstalk_repos.txt"
while IFS= read -r repo_url; do
  # Get repo name from the URL
  repo_name=$(basename "$repo_url" .git)

  echo "Processing $repo_name..."
  # Clone from Beanstalk
  git clone --mirror "$repo_url" "$repo_name.git"
  cd "$repo_name.git" || continue

  # Create GitHub repo (using gh CLI)
  gh repo create "$GITHUB_ORG/$repo_name" --$VISIBILITY -y

  # Push to GitHub using SSH
  git push --mirror "git@github.com:$GITHUB_ORG/$repo_name.git"

  cd ..
  rm -rf "$repo_name.git"

  echo "✅ Migrated $repo_name successfully."
done < "$REPO_LIST"
