# terminal prompt, shows hostname iff not local machine (i.e. hostname does not contains macbook)
PS1='$(if [[ "$HOSTNAME" == *macbook* ]]; then echo "\[\033[1;34m\]\u:\[\033[1;30m\]\w$\[\033[0m\] "; else echo "\[\033[1;34m\]\u@\[\033[1;32m\]\h:\[\033[1;30m\]\w$\[\033[0m\] "; fi)'

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

export PATH="$PATH:$HOME/bin"
