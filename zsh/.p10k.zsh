# Powerlevel10k configuration - Starship-like minimal theme
# Optimized for speed with gitstatus

# Instant prompt mode (critical for speed)
typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

# Prompt layout (similar to Starship)
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir                   # current directory
  vcs                   # git status
  kubecontext           # kubernetes context (IMPORTANT for safety!)
  newline               # line break
  prompt_char           # prompt character
  status                # exit code (only shown on error)
)

typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  command_execution_time  # command duration
  node_version           # node version (when relevant)
  python_version         # python version (when relevant)
  java_version           # java version (when relevant)
)

# Prompt character (like Starship's »)
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=green
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=red
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='»'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='»'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='»'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='»'
typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''  # No space after »

# Directory - Show full path
typeset -g POWERLEVEL9K_DIR_FOREGROUND=cyan
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=  # Empty = show full path
typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=0   # 0 = no limit

# Git status (VCS)
typeset -g POWERLEVEL9K_VCS_FOREGROUND=purple
typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=244

# Git status symbols (matching Starship)
typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
typeset -g POWERLEVEL9K_VCS_UNSTAGED_ICON='!'
typeset -g POWERLEVEL9K_VCS_STAGED_ICON='+'
typeset -g POWERLEVEL9K_VCS_CONFLICTED_ICON='='
typeset -g POWERLEVEL9K_VCS_AHEAD_ICON='⇡'
typeset -g POWERLEVEL9K_VCS_BEHIND_ICON='⇣'
typeset -g POWERLEVEL9K_VCS_DIVERGED_ICON='⇕'
typeset -g POWERLEVEL9K_VCS_STASH_ICON='$'

# Show git status
typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=yellow
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=yellow

# Git branch format
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''
typeset -g POWERLEVEL9K_VCS_PREFIX='on '

# Command execution time (show if > 2 seconds, like Starship)
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=2
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=yellow
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX='took '

# Node version (only show when relevant)
typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=green
typeset -g POWERLEVEL9K_NODE_VERSION_PREFIX='via ⬢ '
typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true

# Python version (only show when relevant)
typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND=yellow
typeset -g POWERLEVEL9K_PYTHON_VERSION_PREFIX='via 🐍 '
typeset -g POWERLEVEL9K_PYTHON_VERSION_PROJECT_ONLY=true

# Java version (only show when relevant)
typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND=red
typeset -g POWERLEVEL9K_JAVA_VERSION_PREFIX='via ☕ '
typeset -g POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY=true

# Kubernetes context (IMPORTANT: shows which cluster you're operating on)
typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=blue
typeset -g POWERLEVEL9K_KUBECONTEXT_BACKGROUND=none
# Only show when using kubectl commands (keeps prompt clean)
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|k9s|helmfile|flux|stern'
typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_DEFAULT_NAMESPACE=true
typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX='☸ '

# Transient prompt (clean up old prompts)
typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

# Status segment (show exit code on error)
typeset -g POWERLEVEL9K_STATUS_OK=false                    # Don't show on success
typeset -g POWERLEVEL9K_STATUS_ERROR=true                  # Show on error
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=none
typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✘'
typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL=true           # Show signal name (e.g., SIGTERM)
typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE=true             # Show exit code of failed pipe command

# Disable verbose background jobs
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false

# Performance optimizations
typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1  # No limit on repo size
typeset -g POWERLEVEL9K_VCS_STAGED_MAX_NUM=1
typeset -g POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM=1
typeset -g POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM=1
typeset -g POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM=1

# Minimal spacing
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '

# Remove leading/trailing spaces
typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''  # No space before first segment
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''     # No space after last segment
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='' # No space before right prompt
typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=' '   # One space after right prompt

# No icons/powerline symbols (clean look)
typeset -g POWERLEVEL9K_MODE=ascii
typeset -g POWERLEVEL9K_ICON_PADDING=none

# Colors
typeset -g POWERLEVEL9K_DIR_BACKGROUND=none
typeset -g POWERLEVEL9K_VCS_BACKGROUND=none
typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=none
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=none
typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=none
typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND=none
typeset -g POWERLEVEL9K_JAVA_VERSION_BACKGROUND=none

