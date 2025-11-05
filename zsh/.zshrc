# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# P10k config
[[ -f ~/dotfiles/zsh/.p10k.zsh ]] && source ~/dotfiles/zsh/.p10k.zsh

# asdf
zinit ice wait lucid
zinit snippet /opt/homebrew/opt/asdf/libexec/asdf.sh

# Syntax highlighting, autosuggestions
zinit wait lucid for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

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
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden 2>/dev/null'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --preview-window right:70%'

# Artifactory (DoorDash)
export ARTIFACTORY_USERNAME=hakan.alpay@doordash.com
export ARTIFACTORY_PASSWORD=***REMOVED***
export artifactoryUser=${ARTIFACTORY_USERNAME}
export artifactoryPassword=${ARTIFACTORY_PASSWORD}
export ARTIFACTORY_URL=https://${ARTIFACTORY_USERNAME/@/%40}:${ARTIFACTORY_PASSWORD}@ddartifacts.jfrog.io/ddartifacts/api/pypi/pypi-local/simple/
export PIP_EXTRA_INDEX_URL=${ARTIFACTORY_URL}

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
