ZSH_THEME="wedisagree"
source ~/zshrc.alias && echo "source ~/zshrc.alias"

source ~/zshrc.export && echo "source ~/zshrc.export"

echo "--------- PATH ----------"
echo $PATH
echo "--------- PATH ----------"

autoload -Uz add-zsh-hook

### git関連のショートカット
function peco-git-recent-branches () {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | \
        perl -pne 's{^refs/heads/}{}' | \
        peco)
    if [ -n "$selected_branch" ]; then
        BUFFER="git checkout ${selected_branch}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-git-recent-branches

function peco-git-recent-all-branches () {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads refs/remotes | \
        perl -pne 's{^refs/(heads|remotes)/origin/}{}' | \
#         perl -pne 's{^refs/(heads|remotes)/}{}' | \
        grep -v "refs"| peco)
    if [ -n "$selected_branch" ]; then
        BUFFER="git checkout ${selected_branch}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-git-recent-all-branches


bindkey '^x^b' peco-git-recent-branches
bindkey '^xb' peco-git-recent-all-branches

autoload -U compinit
compinit -u

export VAGRANT_HOME=~/Google\ Drive/Jetdrive/vagrant_home

if command -v brew >/dev/null 2>&1; then
    # Load rupa's z if installed
    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

KEYTIMEOUT=1

function peco-history-selection() {
    BUFFER=`\history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
