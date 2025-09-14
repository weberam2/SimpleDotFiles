# to change shell to zsh: chsh -s $(which zsh)

# Auto start/attach to tmux:
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#### Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" # Set the directory we want to store zinit and plugins
if [ ! -d "$ZINIT_HOME" ]; then # Download Zinit, if it's not there yet
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh" # Source/Load zinit

zinit ice depth=1; zinit light romkatv/powerlevel10k # Add in Powerlevel10k

#### Completion
autoload -Uz compinit
compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive
eval "$(dircolors -b 2>/dev/null)"   # safe if dircolors missing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#### More zinit plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions # greyed-out suggestions based on your history
zinit light zsh-users/zsh-syntax-highlighting # colored commands
zinit snippet OMZP::colored-man-pages

#### History

HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase # Erase duplicates
setopt appendhistory # append instead of overwrite?
setopt sharehistory # share between sessions
setopt hist_ignore_space # include a space first before command to not write to history
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

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
# alias mv='mv --interactive=once'
# alias cp='cp --interactive=once'

alias bat='batcat'
alias fd='fdfind'
alias tmux='tmux -u'

alias sz='source ~/.zshrc'
alias q='exit'
alias c='clear'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ls='eza'
alias ll='ls -lAh'        # long, human readable, hidden
alias lt='ls -lrht modified'       # sort by time

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

export PATH="$PATH:~/.local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# fzf settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
