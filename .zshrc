# oh-my-zsh
export ZSH=~/.oh-my-zsh
CASE_SENSITIVE=true
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS=true
source "${ZSH}/oh-my-zsh.sh"

# Opts post-zsh initialization
unsetopt autocd
unsetopt autopushd
unsetopt histexpiredupsfirst
unsetopt histignoredups
unsetopt histignorespace
unsetopt pushdignoredups
unsetopt pushdminus
setopt histignorealldups

# Initialize completion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit

source ~/.bashrc

source_if_exists ~/.private

# kubectl
source <(kubectl completion zsh)

# OpenTofu/Terraform
if [[ -x /usr/bin/tofu ]]; then
    complete -o nospace -C /usr/bin/tofu tofu
fi

# zsh doesn't have help
function help() {
    bash -c "help $(printf "%q " "$@")"
}
