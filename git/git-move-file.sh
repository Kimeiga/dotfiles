#!/bin/bash

# git-move-file.sh - Move files to a different branch in an Aviator stack
# Usage: git-move-file.sh <target_branch> <file1> [<file2> ...]

if [ $# -lt 2 ]; then
    echo "Usage: git-move-file.sh <target_branch> <file1> [<file2> ...]"
    exit 1
fi

# Get the target branch and current branch
TARGET_BRANCH="$1"
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
shift  # Remove first argument (the branch name)

# Store the files to move
FILES=("$@")

# Check if target branch exists
if ! git show-ref --verify --quiet refs/heads/"$TARGET_BRANCH"; then
    echo "Error: Branch '$TARGET_BRANCH' does not exist"
    exit 1
fi

# Stash everything
echo "Stashing current changes..."
STASH_HASH=$(git stash create)
if [ -z "$STASH_HASH" ]; then
    # No changes to stash, create an empty one
    echo "No changes to stash"
    touch .git_move_file_temp
    git add .git_move_file_temp
    STASH_HASH=$(git stash create)
    git reset .git_move_file_temp
    rm .git_move_file_temp
    
    if [ -z "$STASH_HASH" ]; then
        echo "Failed to create stash"
        exit 1
    fi
fi
git stash store -m "git-move-file temp stash" "$STASH_HASH"
STASH_INDEX=0

# Switch to target branch
echo "Switching to branch '$TARGET_BRANCH'..."
git checkout "$TARGET_BRANCH"
if [ $? -ne 0 ]; then
    echo "Error: Failed to switch to branch '$TARGET_BRANCH'"
    git stash pop "$STASH_INDEX" 2>/dev/null
    exit 1
fi

# Extract only the specified files from stash
echo "Extracting specified files from stash..."
TEMP_PATCH=$(mktemp)
for FILE in "${FILES[@]}"; do
    git show "$STASH_HASH" -- "$FILE" > "$TEMP_PATCH" 2>/dev/null
    if [ -s "$TEMP_PATCH" ]; then
        # Apply the patch for this file
        git apply --index "$TEMP_PATCH" 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "Warning: Failed to apply changes for '$FILE'"
        else
            echo "Extracted '$FILE'"
        fi
    else
        echo "Warning: No changes found for '$FILE' in stash"
    fi
done
rm "$TEMP_PATCH"

# Amend the commit
if git diff --cached --quiet; then
    echo "No changes to amend"
else
    echo "Amending commit with extracted files..."
    git commit --amend --no-edit
    if [ $? -ne 0 ]; then
        echo "Error: Failed to amend commit"
        git reset
        git checkout "$CURRENT_BRANCH"
        git stash pop "$STASH_INDEX" 2>/dev/null
        exit 1
    fi
fi

# Run av sync
echo "Syncing changes up the stack..."
av sync
if [ $? -ne 0 ]; then
    echo "Warning: 'av sync' returned an error"
fi

# Return to original branch
echo "Switching back to '$CURRENT_BRANCH'..."
git checkout "$CURRENT_BRANCH"

# Pop the stash if it exists
echo "Restoring stashed changes..."
git stash pop "$STASH_INDEX" 2>/dev/null

echo "Done!"