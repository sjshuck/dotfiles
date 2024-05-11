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
