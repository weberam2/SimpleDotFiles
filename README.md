# Purpose

Sometimes I find keeping a proper `.dotfile` repo a little tedious, when all I want is a resource for some simple configuration of things like `tmux`, `vim`, `zsh`, etc.

# Install

Simply copy/paste the install.sh file, `chmod +x install.sh` and run it: `./install.sh`

## OR: 
```
wget https://raw.githubusercontent.com/weberam2/SimpleDotFiles/main/install.sh
chmod +x install.sh
./install.sh
```

## During Install

- For fzf, I choose no auto-complete, yes key-bindings, no to zsh update
- At the end, run `zsh`. This will take some extra time and install zsh plugins.
- When you first run vim, you will have to run `:PlugInstall`
