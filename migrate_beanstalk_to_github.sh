#!/bin/bash

# CONFIGURE THIS
GITHUB_ORG="buddyboss"
VISIBILITY="private"  # or "public"
REPO_LIST="beanstalk_repos.txt"
LOG_FILE="migration_log.txt"

# Check if gh CLI is authenticated
if ! gh auth status >/dev/null 2>&1; then
  echo "❌ GitHub CLI is not authenticated. Run 'gh auth login' first."
  exit 1
fi

# Check if repo list file exists
if [ ! -f "$REPO_LIST" ]; then
  echo "❌ Repo list file '$REPO_LIST' not found."
  exit 1
fi

echo "🚀 Starting migration process..." > "$LOG_FILE" # Clear old log file

while IFS='|' read -r repo_url new_repo_name || [ -n "$repo_url" ]; do
  # Remove leading/trailing whitespace
  repo_url=$(echo "$repo_url" | xargs)
  new_repo_name=$(echo "$new_repo_name" | xargs)

  # Skip empty lines and comments
  [[ -z "$repo_url" || "$repo_url" =~ ^# ]] && continue

  # Validate input format
  if [[ -z "$repo_url" || -z "$new_repo_name" ]]; then
    echo "⚠️  Skipping invalid line: '$repo_url | $new_repo_name'" | tee -a "$LOG_FILE"
    continue
  fi

  echo "🔄 Processing '$new_repo_name'..." | tee -a "$LOG_FILE"

  # Clone from Beanstalk
  if ! git clone --mirror "$repo_url" "$new_repo_name.git" >>"$LOG_FILE" 2>&1; then
    echo "❌ Failed to clone from $repo_url" | tee -a "$LOG_FILE"
    continue
  fi

  cd "$new_repo_name.git" || { echo "❌ Cannot enter $new_repo_name.git directory"; continue; }

  # Create GitHub repo
  if ! gh repo create "$GITHUB_ORG/$new_repo_name" --$VISIBILITY -y >>"$LOG_FILE" 2>&1; then
    echo "❌ Failed to create GitHub repo $new_repo_name" | tee -a "$LOG_FILE"
    cd ..
    rm -rf "$new_repo_name.git"
    continue
  fi

  # Push to GitHub
  if ! git push --mirror "git@github.com:$GITHUB_ORG/$new_repo_name.git" >>"$LOG_FILE" 2>&1; then
    echo "❌ Failed to push to GitHub for $new_repo_name" | tee -a "$LOG_FILE"
    cd ..
    rm -rf "$new_repo_name.git"
    continue
  fi

  cd ..
  rm -rf "$new_repo_name.git"
  echo "✅ Successfully migrated '$new_repo_name'" | tee -a "$LOG_FILE"

done < "$REPO_LIST"

echo "🏁 Migration completed. Check '$LOG_FILE' for details."
