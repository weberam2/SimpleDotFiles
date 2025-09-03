# to change shell to zsh: chsh -s $(which zsh)

#### Prompt
# Show working dir in blue, ❯ in green, and error code in red if last cmd failed
PS1='%F{blue}%B%~%b%f %(?..%F{red}[%?]%f )%F{green}❯%f '

#### Completion
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive
eval "$(dircolors -b 2>/dev/null)"   # safe if dircolors missing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#### Keybindings
bindkey -v                   # vim mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

#### Environment
export EDITOR=vim
export VISUAL=vim
export TERM="tmux-256color"
command -v firefox >/dev/null && export BROWSER="firefox"

#### Aliases
alias rm='rm --interactive=once'
alias mv='mv --interactive=once'
alias cp='cp --interactive=once'

alias sz='source ~/.zshrc'
alias q='exit'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ll='ls -lAh'        # long, human readable, hidden
alias lt='ls -ltrh'       # sort by time
alias du1='du -h --max-depth=1'   # disk usage summary
alias dfh='df -h'                  # human-readable disk free
alias mkdirp='mkdir -p'            # no error if exists
alias please='sudo $(fc -ln -1)'  # rerun last command with sudo
alias path='echo -e ${PATH//:/\\n}'         # show $PATH nicely

# Only define if program exists
command -v xclip >/dev/null && alias copy='xclip -selection clipboard'
command -v rename >/dev/null && alias removespaces='rename s/\ /_/g'

#### Options for interactivity
setopt autocd   # typing a dir name = cd into it

#### Functions
# universal extractor
extract () {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1" ;;
      *.tar.gz)    tar xzf "$1" ;;
      *.bz2)       bunzip2 "$1" ;;
      *.rar)       unrar x "$1" ;;
      *.gz)        gunzip "$1" ;;
      *.tar)       tar xf "$1" ;;
      *.tbz2)      tar xjf "$1" ;;
      *.tgz)       tar xzf "$1" ;;
      *.zip)       unzip "$1" ;;
      *.Z)         uncompress "$1" ;;
      *.7z)        7z x "$1" ;;
      *)           echo "Don't know how to extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

