PS1='%F{blue}%B%~%b%f %F{green}❯%f ' # prompt

autoload -Uz compinit

bindkey -v # vim mode
bindkey '^p' history-search-backward # search currently typed command history
bindkey '^n' history-search-forward # search currently typed command history

## History
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

## Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' # case insensitive
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#### set vim as editor in terminal
export EDITOR=vim
export VISUAL=vim
export TERM="tmux-256color"
export BROWSER="firefox"
