# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INSTANT PROMPT - Must be at the very top!
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Helper Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
include() {
  test -f "$@" && source "$@"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Zinit Setup
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ZSH History Settings
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
setopt hist_save_no_dups
setopt hist_ignore_space
setopt hist_verify
setopt interactivecomments
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=10000

# Load Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# P10k config
[[ -f ~/dotfiles/zsh/.p10k.zsh ]] && source ~/dotfiles/zsh/.p10k.zsh

# asdf
zinit ice wait lucid
zinit snippet /opt/homebrew/opt/asdf/libexec/asdf.sh

# Git plugin (lazy loaded)
zinit ice wait lucid
zinit snippet ~/git.plugin.zsh

# Syntax highlighting, autosuggestions
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

# ZSH Completions configuration
zinit ice wait lucid atinit'
zstyle ":completion:*:*:*:*:*" menu select
zstyle ":completion:*" matcher-list "m:{a-zA-Z-_}={A-Za-z_-}" "r:|=*" "l:|=* r:|=*"
zstyle ":completion:*" list-colors ""
zstyle ":completion:*" list-dirs-first true
zstyle ":completion:*:matches" group "yes"
zstyle ":completion:*:options" description "yes"
zstyle ":completion:*:options" auto-description "%d"
zstyle ":completion:*:corrections" format " %F{green}-- %d (errors: %e) --%f"
zstyle ":completion:*:descriptions" format " %F{yellow}-- %d --%f"
zstyle ":completion:*:messages" format " %F{purple} -- %d --%f"
zstyle ":completion:*:warnings" format " %F{red}-- no matches found --%f"
zstyle ":completion:*:default" list-prompt "%S%M matches%s"
zstyle ":completion:*" format " %F{yellow}-- %d --%f"
zstyle ":completion:*" group-name ""
zstyle ":completion:*" verbose yes
zstyle ":completion:*" completer _complete _match _approximate
zstyle ":completion:*:match:*" original only
zstyle ":completion:*:approximate:*" max-errors 1 numeric
zstyle -e ":completion:*:approximate:*" max-errors "reply=($((($#PREFIX+$#SUFFIX)/3))numeric)"
zstyle ":completion:*:manuals" separate-sections true
zstyle ":completion:*:manuals.(^1*)" insert-sections true
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01"
zstyle ":completion:*:*:*:*:processes" command "ps -u $USER -o pid,user,comm"
zstyle ":completion:*:*:kill:*" menu yes select
'
zinit ice wait lucid blockf
zinit light zsh-users/zsh-completions

# kubectl completions (lazy loaded)
zinit ice wait lucid as"program" pick"kubectl" blockf
zinit snippet OMZP::kubectl

# Google Cloud SDK (lazy loaded to avoid console output during instant prompt)
if [ -f '/Users/hakan.alpay/google-cloud-sdk/path.zsh.inc' ]; then
  zinit ice wait lucid
  zinit snippet '/Users/hakan.alpay/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/hakan.alpay/google-cloud-sdk/completion.zsh.inc' ]; then
  zinit ice wait lucid
  zinit snippet '/Users/hakan.alpay/google-cloud-sdk/completion.zsh.inc'
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Environment Variables
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

export EDITOR=nvim
export GOPATH=$HOME/go
export PATH=$HOME/dotfiles/av:$HOME/dotfiles/spells:$HOME/dotfiles/git-spells:$GOPATH/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$PATH
export LESSHISTFILE=-
export GPG_TTY=$(tty)
export BAT_THEME=base16
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export LEDGER_FILE=$HOME/Documents/finance/ledger/journals/current.journal
export PNPM_HOME="/Users/hakan.alpay/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# FZF
include ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden 2>/dev/null'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --preview-window right:70%'

# Key bindings
bindkey -e
bindkey "\e[3~" delete-char

# Artifactory (DoorDash)
export ARTIFACTORY_USERNAME=hakan.alpay@doordash.com
export ARTIFACTORY_PASSWORD=***REMOVED***
export artifactoryUser=${ARTIFACTORY_USERNAME}
export artifactoryPassword=${ARTIFACTORY_PASSWORD}
export ARTIFACTORY_URL=https://${ARTIFACTORY_USERNAME/@/%40}:${ARTIFACTORY_PASSWORD}@ddartifacts.jfrog.io/ddartifacts/api/pypi/pypi-local/simple/
export PIP_EXTRA_INDEX_URL=${ARTIFACTORY_URL}

# Kubernetes contexts
DEFAULT_KUBE_CONTEXTS="$HOME/.kube/config"
if [ -f "${DEFAULT_KUBE_CONTEXTS}" ]; then
  export KUBECONFIG="$DEFAULT_KUBE_CONTEXTS"
fi

# Additional contexts in ~/.kube/contexts
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/contexts"
if [ -d "$CUSTOM_KUBE_CONTEXTS" ]; then
  setopt local_options null_glob  # Don't error on no matches
  for context_file in "$CUSTOM_KUBE_CONTEXTS"/*.yaml(N); do
    [ -f "$context_file" ] && export KUBECONFIG="$context_file:$KUBECONFIG"
  done
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Aliases
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# General
alias ls='ls --color=auto'
alias l='ls -lah'
alias ll='ls -la'
alias rg='rg --hidden'
alias less='less -R'
alias sc='maim -s ~/screenshot.png'
alias mpv='mpv --af=rubberband'
alias emacs='emacs -nw'

# Tools
alias g='git'
alias t='tmux'
alias v=$EDITOR
alias rr='ranger'
alias irc='weechat'
alias dc='docker-compose'
alias d='docker'
alias tf='terraform'
alias hl=hledger
alias tm='task-master'
alias taskmaster='task-master'

# Config editing
alias ze="$EDITOR $HOME/dotfiles/zsh/.zshrc"
alias ve="$EDITOR $HOME/dotfiles/nvim/.config/nvim/init.lua"

# Node/Yarn
alias bigyarn='NODE_OPTIONS=--max-old-space-size=8192 yarn'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Lazy load kubectl with completions and kubecolor
if [ -x "$(command -v kubectl)" ]; then
  kubectl() {
    unfunction kubectl
    source <(command kubectl completion zsh)
    if [ -x "$(command -v kubecolor)" ]; then
      compdef kubecolor=kubectl
      alias kubectl='kubecolor'
    fi
    command kubectl "$@"
  }
  alias k='kubectl'
fi

# Transform branch name to commit message (for Aviator workflow)
transform_branch_to_commit_msg() {
    echo "$1" |
        sed 's/_/ /g' |
        sed -E 's/^([A-Z]+-[0-9]+)(.*)/[\1]\2/'
}

# Aviator (av) workflow helper
a() {
    case "$1" in
        "j")
            av stack tree
            ;;
        "w")
            av stack switch
            ;;
        "b")
            if [ -n "$(git status --porcelain)" ]; then
                av stack branch "$2"
                commit_msg=$(transform_branch_to_commit_msg "$2")
                git add -A && git commit -m "$commit_msg" && av stack sync --push yes
                av pr create
            else
                av stack branch "$2"
            fi
            ;;
        "a")
            if [ -n "$2" ]; then
                git add -A && git commit -m "$2" && av stack sync --push yes
            else
                parent_branch=$(git merge-base --fork-point HEAD origin/master || git merge-base --fork-point HEAD master)
                if [ "$(git rev-list HEAD...$parent_branch)" = "" ] && [ "$(git rev-list $parent_branch...HEAD)" = "" ]; then
                    branch_name=$(git rev-parse --abbrev-ref HEAD)
                    commit_msg=$(transform_branch_to_commit_msg "$branch_name")
                    git add -A && git commit -m "$commit_msg" && av stack sync --push yes
                else
                    git add -A && av commit amend --no-edit && av stack sync --push yes
                fi
            fi
            ;;
        "p")
            av stack submit
            ;;
        "s")
            av stack sync --rebase-to-trunk
            ;;
        "ss")
            av stack sync --rebase-to-trunk --all
            ;;
        "sc")
            av stack sync --continue
            ;;
        "setupstreams")
            set-upstreams.sh
            ;;
        *)
            av stack "$@"
            ;;
    esac
}
