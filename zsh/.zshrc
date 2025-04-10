# Helper function for sourcing files if they exist
include () {
  test -f "$@" && source "$@"
}

### Zinit Setup ###
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load Zinit annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# Initialize Homebrew early - before NVM setup
# eval "$(/opt/homebrew/bin/brew shellenv)"

# ZSH History settings
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

# Environment Variables
export EDITOR=nvim
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/dotfiles/av:$HOME/dotfiles/spells:$GOPATH/bin:$HOME/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$PATH
export LESSHISTFILE=-
export GPG_TTY=$(tty)
export BAT_THEME=base16
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export LEDGER_FILE=$HOME/Documents/finance/ledger/journals/current.journal

# Syntax highlighting, autosuggestions and completions (with turbo mode)
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

# Pure theme
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure
PURE_PROMPT_SYMBOL=»

# Git plugin - load from local file
zinit snippet ~/git.plugin.zsh

# NVM setup - optimized for speed
export NVM_DIR="$HOME/.nvm"
# Simple configuration for NVM
export NVM_COMPLETION=true
export NVM_SYMLINK_CURRENT="true"

# Load NVM with minimal configuration
zinit wait lucid light-mode for lukechilds/zsh-nvm

# pnpm
export PNPM_HOME="/Users/hakan.alpay/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
zinit ice wait lucid
zinit snippet "/Users/hakan.alpay/.bun/_bun"

# pyenv setup (proper initialization)
if command -v pyenv &> /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  zinit ice wait lucid atinit'eval "$(pyenv init --path)"; eval "$(pyenv init -)"'
  zinit snippet OMZP::pyenv
fi

# jenv setup (direct loading instead of using PZTM snippet)
if command -v jenv &> /dev/null && [[ ! -n $JENV_LOADED ]]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  export JENV_LOADED=1
  eval "$(jenv init -)"
fi

# ZSH Completions configuration
# Load after plugins that might add completion functions
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

# FZF
include ~/.fzf.zsh
include /usr/share/fzf/key-bindings.zsh
include /usr/share/fzf/completion.zsh
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden 2>/dev/null'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --preview-window right:70%'

# Kubernetes
# Lazy load kubectl and completions
zinit ice wait lucid as"program" pick"kubectl" blockf
zinit snippet OMZP::kubectl

# Set the default kube context if present
DEFAULT_KUBE_CONTEXTS="$HOME/.kube/config"
if [ -f "${DEFAULT_KUBE_CONTEXTS}" ]
then
  export KUBECONFIG="$DEFAULT_KUBE_CONTEXTS"
fi
# Additional contexts should be in ~/.kube/contexts
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/contexts"
mkdir -p "$CUSTOM_KUBE_CONTEXTS"
for context_file in `fd '.*.yaml' -t f "$CUSTOM_KUBE_CONTEXTS"`
do
  export KUBECONFIG="$context_file:$KUBECONFIG"
done

# Aliases
alias ls='ls --color=auto'
alias l='ls -lah'
alias ll='ls -la'
alias rg='rg --hidden'
alias g='git'
alias t='tmux'
alias v=$EDITOR
alias rr='ranger'
alias irc='weechat'
alias less='less -R'
alias sc='maim -s ~/screenshot.png'
alias mpv='mpv --af=rubberband'
alias emacs='emacs -nw'
alias dc='docker-compose'
alias d='docker'
alias tf='terraform'

# Lazy load kubectl with completions
if [ -x "$(command -v kubectl)" ]; then
  # Properly lazy-load kubectl and its completions
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

alias ze="$EDITOR $HOME/dotfiles/zsh/.zshrc"
alias ve="$EDITOR $HOME/dotfiles/nvim/.config/nvim/init.lua"
alias hl=hledger

alias bigyarn='NODE_OPTIONS=--max-old-space-size=8192 yarn'

# Google Cloud SDK
zinit ice wait lucid
zinit snippet '/Users/hakan.alpay/google-cloud-sdk/path.zsh.inc'
zinit ice wait lucid
zinit snippet '/Users/hakan.alpay/google-cloud-sdk/completion.zsh.inc'

# Key bindings
bindkey -e
bindkey "\e[3~" delete-char

# Stack workflow functions
transform_branch_to_commit_msg() {
    echo "$1" | 
        sed 's/_/ /g' |
        sed -E 's/^([A-Z]+-[0-9]+)(.*)/[\1]\2/'
}

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



