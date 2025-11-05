# Git Spells

A collection of custom Git commands and aliases to enhance your Git workflow.

## Table of Contents

- [Installation](#installation)
- [Commands by Category](#commands-by-category)
  - [File Management](#file-management)
  - [Branch Management](#branch-management)
  - [Commit Management](#commit-management)
  - [Stash Management](#stash-management)
  - [Diff and Viewing](#diff-and-viewing)
  - [GitHub Integration](#github-integration)
  - [Workflow Automation](#workflow-automation)
- [Detailed Command Reference](#detailed-command-reference)

## Installation

1. Make sure the `git-spells` directory is in your PATH:

```bash
export PATH=$PATH:/path/to/git-spells
```

2. Ensure all scripts are executable:

```bash
chmod +x git-spells/*
```

3. Git will automatically recognize commands named `git-*` as custom Git commands, allowing you to use them as `git command`.

## Commands by Category

### File Management

| Command                 | Description                                              | Source                          |
| ----------------------- | -------------------------------------------------------- | ------------------------------- |
| `git keep`              | Selectively revert changes, keeping only specified files | Script: `git-keep`              |
| `git m`                 | Move files to a different branch                         | Script: `git-move-file`         |
| `git diff-filter`       | Filter JSON files from git diff and copy to clipboard    | Script: `git-diff-filter`       |
| `git remove-large-file` | Find and remove a large file from Git history            | Script: `git-remove-large-file` |
| `git re`                | Checkout all files (reset working directory)             | Alias                           |

### Branch Management

| Command             | Description                                       | Source                      |
| ------------------- | ------------------------------------------------- | --------------------------- |
| `git find-branch`   | Find which repositories contain specific branches | Script: `git-find-branch`   |
| `git squash-branch` | Apply a GitHub PR as a single commit              | Script: `git-squash-branch` |
| `git bb`            | List all branches                                 | Alias                       |
| `git bcc`           | Clean up merged branches                          | Alias                       |
| `git bd`            | Delete a branch                                   | Alias                       |
| `git bdf`           | Delete a branch using fuzzy finder                | Alias                       |
| `git bf`            | Checkout a branch using fuzzy finder              | Alias                       |
| `git go`            | Create or checkout a branch                       | Alias                       |
| `git bu`            | Set upstream to origin/current branch and pull    | Alias                       |

### Commit Management

| Command          | Description                                      | Source                   |
| ---------------- | ------------------------------------------------ | ------------------------ |
| `git a`          | Add all, amend, and submit                       | Alias                    |
| `git al`         | Add all and amend                                | Alias                    |
| `git aa`         | Create branch, commit, push, and create PR       | Alias                    |
| `git b`          | Add all, commit, and push                        | Alias                    |
| `git c`          | Amend commit without editing message             | Alias                    |
| `git ac`         | Add all and amend commit without editing message | Alias                    |
| `git cm`         | Add all and commit with message                  | Alias                    |
| `git cherry-pit` | Rebase to remove a specific commit               | Alias                    |
| `git squash-all` | Squash all commits in the current branch         | Script: `git-squash-all` |

### Stash Management

| Command  | Description                           | Source |
| -------- | ------------------------------------- | ------ |
| `git st` | Stash including untracked files       | Alias  |
| `git sa` | Apply stash including untracked files | Alias  |
| `git sp` | Pop stash                             | Alias  |

### Diff and Viewing

| Command              | Description                                            | Source                       |
| -------------------- | ------------------------------------------------------ | ---------------------------- |
| `git d`              | Show diff                                              | Alias                        |
| `git sd`             | Show staged diff                                       | Alias                        |
| `git l`              | Show log with graph (last 10 commits)                  | Alias                        |
| `git la`             | Show log with graph for all branches (last 10 commits) | Alias                        |
| `git ll`             | Show log with graph (all commits)                      | Alias                        |
| `git lla`            | Show log with graph for all branches (all commits)     | Alias                        |
| `git s`              | Show status                                            | Alias                        |
| `git sh`             | Show commit details                                    | Alias                        |
| `git bc`             | Show diff between current branch and main/master       | Alias                        |
| `git files-changed`  | Show files changed in current branch with A/M/D status | Script: `git-files-changed`  |
| `git branch-changes` | Show branch changes with pattern filtering             | Script: `git-branch-changes` |

### GitHub Integration

| Command  | Description                    | Source |
| -------- | ------------------------------ | ------ |
| `git pr` | Open current PR in web browser | Alias  |

### Workflow Automation

| Command   | Description                                             | Source |
| --------- | ------------------------------------------------------- | ------ |
| `git y`   | Initialize branchless and sync with merge               | Alias  |
| `git yy`  | Initialize branchless and sync                          | Alias  |
| `git r`   | Add all and continue rebase                             | Alias  |
| `git t`   | Checkout theirs and continue rebase                     | Alias  |
| `git ae`  | Initialize branchless, add all, and amend               | Alias  |
| `git aer` | Initialize branchless, add all, and amend with reparent | Alias  |
| `git rg`  | Restack with merge                                      | Alias  |

## Detailed Command Reference

### git-keep

Selectively revert changes, keeping only specified files. This is a powerful tool when you need to discard most of your changes but preserve specific files.

```bash
git keep [options] <file1> <file2> ...
```

**When to use it:**

- When you've made changes to multiple files but only want to keep a few of them
- When you want to undo a commit but preserve changes to specific files
- When you need to clean up your working directory but keep certain modifications
- When you're experimenting with changes and want to selectively discard some while keeping others

**How it works:**

- In working copy mode (default), it reverts all changes except for the specified files
- In commit mode (`-C`), it reverts the current commit but preserves changes to specified files
- Handles various file states (modified, deleted, untracked) correctly
- Provides safety features like confirmation prompts and dry run mode

**Options:**

- `-C`: Operate on current commit instead of working copy
- `-n`: Dry run - show what would happen without making changes
- `-y`: Skip confirmation prompt
- `-h`: Show help message

**Examples:**

```bash
# Keep changes to file1.txt, revert all other changes in working copy
git keep file1.txt

# Keep changes to multiple files
git keep file1.txt path/to/file2.txt

# Keep changes to a file with spaces in the name
git keep 'file with spaces.txt'

# Revert the current commit, keeping only changes to file1.txt
git keep -C file1.txt

# Dry run to see what would happen without making changes
git keep -n file1.txt
```

**Testing:**
The script comes with a comprehensive test suite (`git-keep-test.sh`) that verifies its functionality in various scenarios, including:

- Working with files in subdirectories
- Handling files with spaces and special characters
- Preserving multiple files while reverting others
- Operating on both working copy and commits
- Handling untracked and deleted files

### git-move-file

Move files to a different branch in an Aviator stack while preserving changes.

```bash
git m <target_branch> <file1> [<file2> ...]
```

**When to use it:**

- When you've made changes to a file but realize it belongs on a different branch
- When you need to move specific files between branches in a stack
- When you want to extract specific changes from your current work and apply them elsewhere
- When you're working on multiple features and need to reorganize your changes

**How it works:**

- Stashes your current changes
- Switches to the target branch
- Extracts only the specified files from the stash
- Amends the commit on the target branch
- Syncs changes up the stack
- Returns to your original branch and restores other stashed changes

**Examples:**

```bash
# Move a file to another branch
git m feature-branch path/to/file.js

# Move multiple files to another branch
git m feature-branch file1.js file2.js
```

### git-diff-filter

Filter JSON files from git diff and copy to clipboard. This is particularly useful when reviewing changes that include large JSON files (like package-lock.json) that clutter the diff output.

```bash
git diff-filter [base_branch]
```

**When to use it:**

- When reviewing changes that include large JSON files that aren't relevant to code review
- When preparing a diff to share with colleagues and want to focus on code changes
- When you want to see what changed in your codebase without the noise of auto-generated JSON files
- When you're about to commit and want to verify your changes without JSON noise

**How it works:**

- Runs `git diff` against the specified base branch (defaults to master)
- Uses awk to filter out any diffs for files with .json extension
- Copies the filtered diff to your clipboard for easy pasting

**Examples:**

```bash
# Filter JSON files from diff against master
git diff-filter

# Filter JSON files from diff against specific branch
git diff-filter develop
```

### git-squash-branch

Apply a GitHub PR as a single commit and optionally rebase a branch on top. This is useful for incorporating changes from a PR while maintaining a clean commit history.

```bash
git squash-branch PR_NUMBER [YOUR_BRANCH] [--keep-temp]
```

**When to use it:**

- When you want to incorporate changes from a PR as a single clean commit
- When you need to apply a PR's changes to your feature branch
- When you want to try out changes from a PR without the messy commit history
- When you're maintaining a clean branch and want to incorporate PR changes without merge commits

**How it works:**

- Creates a temporary branch from your main branch
- Fetches the PR diff using GitHub CLI
- Applies the changes as a single commit with proper attribution
- Optionally rebases your branch on top of these changes
- Cleans up temporary branches by default

**Examples:**

```bash
# Apply PR #123 as a single commit
git squash-branch 123

# Apply PR #123 and rebase your-branch on top
git squash-branch 123 your-branch

# Apply PR #123 and keep temporary branch
git squash-branch 123 --keep-temp
```

### git-remove-large-file

Find and remove large files from Git history while preserving them on disk and adding them to .gitignore.

```bash
git remove-large-file [options] <file_path_or_pattern> [<file_path_or_pattern> ...]
```

**When to use it:**

- When you've accidentally committed large files that exceed GitHub's file size limits
- When you need to clean up your repository history to reduce its size
- When you want to keep large files locally but exclude them from Git tracking
- When you're getting "remote rejected" errors due to large files during push
- When you need to remove multiple files matching a pattern (like all JPEG files)
- When you need to remove multiple specific files in a single operation

**How it works:**

- For single files:

  - Identifies which commit introduced the specified file
  - Uses git-filter-repo to remove the file from Git history
  - Adds the file to .gitignore to prevent it from being committed again
  - Preserves the file on disk so you don't lose your data

- For glob patterns:

  - Finds all files in the repository matching the pattern
  - Removes all matching files from Git history in a single operation
  - Adds the pattern to .gitignore to prevent future commits
  - Preserves all files on disk so you don't lose your data

- For multiple files or patterns:

  - Processes each file or pattern individually
  - Combines all matching files into a single operation
  - Performs a single Git history rewrite for better performance
  - Adds all files/patterns to .gitignore in a single commit

- Provides safety features:
  - Confirmation prompts before making changes
  - Dry run mode to preview changes
  - Preserves and restores remote configurations
  - Shows detailed list of files to be removed

**Options:**

- `-n`: Dry run - show what would happen without making changes
- `-y`: Skip confirmation prompt
- `-g`: Treat the file paths as glob patterns (e.g., '\*.jpg')
- `-h`: Show help message

**Examples:**

```bash
# Remove a specific large file from Git history
git remove-large-file path/to/large/file.bin

# Remove multiple specific files from Git history
git remove-large-file file1.bin file2.json path/to/file3.pdf

# Remove all JPEG files from Git history
git remove-large-file -g '*.jpg'

# Remove all files in a directory from Git history
git remove-large-file -g 'path/to/dir/*'

# Remove multiple patterns from Git history
git remove-large-file -g '*.jpg' '*.pdf' 'logs/*.log'

# Dry run to see what would happen
git remove-large-file -n -g '*.pdf'
```

**Requirements:**

This command requires git-filter-repo to be installed. You can install it with:

```bash
pip install git-filter-repo
```

### git-files-changed

Show files changed in current branch with status (A/M/D), similar to what you see in a GitHub PR sidebar.

```bash
git files-changed [base_branch]
```

**When to use it:**

- When you want to see which files were changed in your current branch compared to the base branch
- When you need a quick overview of what your PR will contain (like GitHub's PR sidebar)
- When you want to see the status of each file (Added, Modified, or Deleted)
- When you're preparing to create a PR and want to review what files you've touched
- When you need to understand the scope of changes in your feature branch

**How it works:**

- Finds the merge base between your current branch and the specified base branch (main/master by default)
- Uses `git diff --name-status` to show files with their change status
- Shows cumulative changes across all commits in your branch
- Provides clear A/M/D status indicators like GitHub

**Output format:**

```
A    new-file.txt      (Added)
M    changed-file.txt  (Modified)
D    deleted-file.txt  (Deleted)
```

**Examples:**

```bash
# Show files changed compared to main/master
git files-changed

# Show files changed compared to develop branch
git files-changed develop
```

### git-branch-changes

Show changes between current branch and main/master with the ability to filter out specific files or patterns.

```bash
git branch-changes [options] [exclude_pattern1] [exclude_pattern2] ...
```

**When to use it:**

- When you want to see branch changes but exclude certain files (like READMEs or config files)
- When reviewing changes and want to focus on specific file types
- When preparing a diff to share with colleagues and want to exclude irrelevant changes
- When you want to see what changed in your branch without the noise of auto-generated files
- When you need to focus on specific parts of your codebase during code review

**How it works:**

- Finds the merge base between your current branch and main/master
- Shows the diff between that merge base and your current branch
- Allows you to exclude files matching specified glob patterns
- Can show just the file names or the full diff
- Optionally copies the result to your clipboard

**Options:**

- `-b, --base <branch>`: Specify base branch (default: main or master)
- `-c, --copy`: Copy output to clipboard (requires pbcopy)
- `-n, --name-only`: Show only names of changed files
- `-h, --help`: Show help message

**Examples:**

```bash
# Show all changes between current branch and main/master
git branch-changes

# Show changes excluding markdown files
git branch-changes '*.md'

# Show changes excluding multiple patterns
git branch-changes '*.md' '*.json' 'docs/*'

# Show changes against a specific base branch
git branch-changes -b develop

# Show only names of changed files, excluding markdown files
git branch-changes -n '*.md'

# Copy changes to clipboard, excluding markdown and JSON files
git branch-changes -c '*.md' '*.json'
```

### git-find-branch

Find which Git repositories contain specific branches. This is particularly useful when you have multiple clones of the same repository across different directories and need to locate where specific branches are checked out.

```bash
git find-branch [options] <branch_name> [branch_name2] ...
```

**When to use it:**

- When you have multiple clones of the same repository and forget which one has which branches
- When you need to locate a specific branch across multiple repositories
- When you want to see which repositories contain certain feature branches
- When you're managing multiple projects and need to find where development branches are located
- When you need to audit branch distribution across your local repositories

**How it works:**

- Searches for Git repositories starting from the current directory
- Recursively searches subdirectories up to a specified depth (default: 3 levels)
- Checks each repository for the specified branch name(s)
- Can search local branches, remote branches, or both
- Provides clean output showing which repositories contain the branches
- Handles multiple branch names in a single command

**Options:**

- `-r`: Search only remote branches
- `-a`: Search both local and remote branches (default: local only)
- `-v`: Verbose output - show branch details
- `-d <depth>`: Maximum directory depth to search (default: 3)
- `-h`: Show help message

**Examples:**

```bash
# Find repositories containing branch 'feature-x'
git find-branch feature-x

# Find repositories containing multiple branches
git find-branch feature-x bugfix-y

# Search remote branches only
git find-branch -r origin/feature-x

# Search both local and remote branches with verbose output
git find-branch -av feature-x

# Search with custom depth (5 levels deep)
git find-branch -d 5 feature-x

# Search from a parent directory containing multiple repo clones
cd ~/projects
git find-branch my-feature-branch
```

**Testing:**
The script comes with a comprehensive test suite (`git-find-branch-test`) that verifies its functionality in various scenarios, including:

- Finding branches that exist in multiple repositories
- Finding branches that exist in only one repository
- Handling nonexistent branches gracefully
- Testing verbose output
- Validating error handling for invalid inputs

### git-squash-all

Automatically squash all commits in the current branch, even when dealing with complex branch hierarchies.

```bash
git squash-all [options]
```

**When to use it:**

- When you want to clean up your branch's commit history before merging
- When you have a feature branch with many small, incremental commits
- When your branch is based on another branch that's based on main/master
- When you want to simplify your branch history without manually counting commits
- When you need to consolidate changes from multiple commits into a single, coherent commit

**How it works:**

- Automatically finds the base branch from which your current branch diverged
- Works with complex branch hierarchies (branches off branches off branches)
- Counts the number of commits unique to your branch
- Performs a `git reset --soft HEAD~N` where N is that number
- Creates a new commit with all the changes
- Preserves all your files and changes in the working directory

**Options:**

- `-b, --base <branch>`: Specify a base branch to find the merge point
- `-n, --dry-run`: Show what would happen without making changes
- `-m, --message <msg>`: Specify commit message for the squashed commit
- `-h, --help`: Show help message

**Examples:**

```bash
# Squash all commits in the current branch
git squash-all

# Dry run to see what would happen
git squash-all --dry-run

# Specify a base branch
git squash-all --base develop

# Specify a commit message
git squash-all --message "Implement feature X"
```
