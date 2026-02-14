# shellcheck disable=1090,1091

# Current shell
case $1 in
    from-zsh)
        current_shell=zsh
        ;;
    '')
        current_shell=bash
        ;;
    *)
        echo >&2 "Unexpected ~/.bashrc args ${*}"
esac

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Common startup utilities
function prepend_to_path() {
    export PATH="${1}:${PATH}"
}
function source_if_exists() {
    if [[ -f $1 ]]; then
        source "$1"
    fi
}

# Secrets, machine-specific stuff
source_if_exists ~/.private

# Local programs
prepend_to_path ~/.local/bin
prepend_to_path ~/.mcabal/bin

# OpenTofu/Terraform
export TF_PLUGIN_CACHE_DIR=~/.terraform.d/plugin-cache

# kubectl
if command -v kubectl >/dev/null; then
    source <(kubectl completion "$current_shell")
fi

# Haskell
source_if_exists ~/.ghcup/env
if command -v stack >/dev/null; then
    eval "$(stack --bash-completion-script stack)"
fi
function hackage-upload() {
    curl \
        -u "$HACKAGE_CREDS" \
        -F package="@${1}" \
        https://hackage.haskell.org/packages/candidates/
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

# vim-open and highlight all files containing a given regex
function rgvim() {
    rg -l "$1" | xargs -d '\n' vim -c "/\\v${1}" -O
}

# Miscellaneous shell settings
export EDITOR=vim
alias ls='ls --color=auto'
alias l='ls -CF'
alias grep='grep --color=auto'

unset current_shell
