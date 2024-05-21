alias now='date +"%A %Y-%m-%d %T %p %s"'
alias rs='exec -l $SHELL'
alias chrome='open -a "$HOME/Applications/Google Chrome.app"'
alias calc='open -a "/System/Applications/Calculator.app"'
alias word='open -a "/Applications/Microsoft Word.app"'
alias excel='open -a "/Applications/Microsoft Excel.app"'
alias lt="ls -ltaT | more"
alias cat='bat'
alias grep='grep --color=auto'

alias df='df -h'
alias free='free -m'
alias ls='eza -al --color=always --group-directories-first'
# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF ${colorflag}"
#ps
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem="ps auxf | sort -nr -k 4"
alias pscpu="ps auxf | sort -nr -k 3"


# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
alias mkdir="mkdir -p"
alias cp="cp -r"
alias ZZ="exit"
alias pip=pip3
alias fo='nvim "$(fzf --preview "bat --color=always --style=header,grid --line-range :500 {}")"'
alias python=python3
alias zc="eza -l -g --icons"
alias zh="zc -a"
alias zt="zh --tree --level=2"
# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Get macOS Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update; sudo gem cleanup'

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'
