# shellcheck disable=1090,1091

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Common startup utilities
function current_shell() {
    ps co pid,command | awk "{
        if (\$1 == $$) { print \$2; exit }
    }" | sed -e 's/^-//'
}
function prepend_to_path() {
    export PATH="${1}:${PATH}"
}
function source_if_exists() {
    if [[ -f $1 ]]; then
        source "$1"
    fi
}

# Local programs
prepend_to_path ~/.local/bin

# OpenTofu/Terraform
export TF_PLUGIN_CACHE_DIR=~/.terraform.d/plugin-cache

# kubectl
if [[ $(current_shell) == bash ]]; then
    source <(kubectl completion bash)
fi

# Haskell
source_if_exists ~/.ghcup/env
eval "$(stack --bash-completion-script stack)"
function my-stackage-snapshot() {
    ruby <~/.stack/global-project/stack.yaml -e '
        require "yaml"
        puts YAML.load(STDIN)["resolver"]
    '
}

# Nix
prepend_to_path ~/.nix-profile/bin

# Liquidprompt
source_if_exists ~/code/liquidprompt/liquidprompt

# GPG pinentry
export GPG_TTY; GPG_TTY="$(tty)"

# Python
function venv() {
    source "${1:-venv}/bin/activate"
}

# Git
function doit() {
    git add -A && git commit --amend --no-edit && git push --force
}

# Miscellaneous shell settings
export EDITOR=vim
alias ls='ls --color=auto'
alias l='ls -CF'
alias grep='grep --color=auto'
alias lua='rlwrap lua'
