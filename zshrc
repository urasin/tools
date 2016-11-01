source ~/zsh_dot/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  && echo "source  ~/zsh_dot/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source ~/zsh_dot/oh_my_zshrc && echo "source oh_my_zshrc"
ZSH_THEME="wedisagree"
source ~/zsh_dot/zshrc.alias && echo "source ~/zshrc.alias"

source ~/zsh_dot/zshrc.export && echo "source ~/zshrc.export"


export PATH=$PATH:~/Library/Python/2.7/bin

echo "--------- PATH ----------"
echo $PATH
echo "--------- PATH ----------"

# pyenvの環境をプロンプトの前に表示させるスクリプト
function precmd_function1() {
	PY_ENV_TMP="(`pyenv version | awk '{print $1}'`)"
	if [ -z "${PY_ENV}" ]; then
		export PY_ENV="(`pyenv version | awk '{print $1}'`)"
		PROMPT=${PY_ENV_TMP}${PROMPT}
	else [ "${PY_ENV_TMP}" != "${PY_ENV}" ]
		PROMPT=`echo ${PROMPT} | sed s/${PY_ENV}//`
		export PY_ENV="(`pyenv version | awk '{print $1}'`)"
		PROMPT=${PY_ENV_TMP}${PROMPT}
	fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_function1

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

## direnv
export EDITOR=vi
eval "$(direnv hook zsh)"

fpath=($(brew --prefix)/share/zsh/site-functions $fpath)

autoload -U compinit
compinit -u

export VAGRANT_HOME=~/Google\ Drive/Jetdrive/vagrant_home
export EDITOR="/usr/local/bin/vim"

if command -v brew >/dev/null 2>&1; then
    # Load rupa's z if installed
    [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi
# for iterm2
echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"
function chpwd() { echo -ne "\033]0;$(pwd | rev | awk -F \/ '{print "/"$1"/"$2}'| rev)\007"}

# tmux

while read line
do
    ssh-add $line
done << EOS
/Users/urasin/.ssh/ssh_pems/urasin/github/urasin_git
EOS

export PATH=$HOME/.nodebrew/current/bin:$PATH

KEYTIMEOUT=1

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# for pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# alias ssh=~/bin/ssh-host-color
apep8 () {
echo "### auto pep8 ###"
 find . -name '*py' -type f | grep -v 'git'| grep -v 'migrations' | while read line
do
  autopep8 --ignore E501 $line > ./tmpfile
  cat ./tmpfile > $line
  /bin/rm -fr ./tmpfile
done
echo "### pyflakes ###"
pyflakes .
}


export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

#export PATH="/Users/urasin/.phpenv/bin:$PATH"
#eval "$(phpenv init -)"
#
export LC_ALL='ja_JP.UTF-8'
alias k2pdfopt="k2pdfopt -dev kv"

# for cordva
export PATH=$HOME/Library/Android/sdk/platform-tools:$PATH
export PATH=$HOME/Library/Android/sdk/tools:$PATH

function peco-history-selection() {
    BUFFER=`\history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection
