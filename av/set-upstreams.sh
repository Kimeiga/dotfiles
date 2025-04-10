#!/bin/bash

# --- Configuration ---
# Change this if your remote is not named 'origin'
REMOTE_NAME="origin"
# --- End Configuration ---

echo "Attempting to set upstream branches based on 'av tree' output..."

# Get the av tree output
AV_TREE_OUTPUT=$(av tree)

# Variable to keep track of the most recently parsed branch name
current_branch=""

# Process the output line by line
echo "$AV_TREE_OUTPUT" | while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace (helps with matching)
    trimmed_line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Check if the line indicates a branch (starts with optional │, then *, ○, or ● followed by space)
    # Extracts the branch name as the first word after the marker.
    if [[ "$trimmed_line" =~ ^[│[:space:]]*[\*○●][[:space:]]+([^[:space:]]+) ]]; then
        # Found a branch line, extract name
        current_branch="${BASH_REMATCH[1]}"
        # echo "DEBUG: Found branch line for: $current_branch" # Uncomment for debugging
        continue # Move to the next line to check for URL or "No pull request"
    fi

    # Check if we have a branch context AND the line contains a GitHub PR URL
    if [[ -n "$current_branch" && "$trimmed_line" =~ ^https://github.com/([^/]+)/([^/]+)/pull/([0-9]+) ]]; then
        pr_url="$trimmed_line"
        # Assume the remote branch name is the same as the local branch name
        # This is usually the case with av stacks originating from the same repo
        remote_branch_name="$current_branch"

        echo "Found PR for '$current_branch'. Setting upstream to '$REMOTE_NAME/$remote_branch_name'."

        # --- Execute the git command ---
        if git branch --set-upstream-to="$REMOTE_NAME/$remote_branch_name" "$current_branch"; then
            : # Successfully set upstream
        else
            echo "WARN: Failed to set upstream for branch '$current_branch'. Does the remote branch '$REMOTE_NAME/$remote_branch_name' exist?"
        fi
        # --- End execute git command ---

        # Reset current_branch since we've processed it
        current_branch=""

    # Check if we have a branch context AND the line indicates no PR
    elif [[ -n "$current_branch" && "$trimmed_line" =~ No\ pull\ request ]]; then
        echo "Skipping branch '$current_branch' (No pull request associated)."
        # Reset current_branch since we've processed it
        current_branch=""
    
    # Reset if the line doesn't match expected follow-ups (URL or No PR)
    elif [[ -n "$current_branch" ]]; then
         # echo "DEBUG: Line for $current_branch was not URL or 'No pull request': $trimmed_line" # Uncomment for debugging
         # It might be an empty line or connector line, keep current_branch context for the next line.
         : # No-op, keep context
    fi
done

echo "Finished processing branches."