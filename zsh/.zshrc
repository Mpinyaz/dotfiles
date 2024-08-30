##################################################################
#
#       ███╗   ███╗██████╗ ██╗███╗   ██╗██╗   ██╗ █████╗ ███████╗
#       ████╗ ████║██╔══██╗██║████╗  ██║╚██╗ ██╔╝██╔══██╗╚══███╔╝
#       ██╔████╔██║██████╔╝██║██╔██╗ ██║ ╚████╔╝ ███████║  ███╔╝
#       ██║╚██╔╝██║██╔═══╝ ██║██║╚██╗██║  ╚██╔╝  ██╔══██║ ███╔╝
#       ██║ ╚═╝ ██║██║     ██║██║ ╚████║   ██║   ██║  ██║███████╗
#       ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
#################################################################
export PATH="$PATH:/opt/nvim-linux64/bin"
export HISTFILE=~/.zsh_history
export PATH="/usr/local/opt/llvm/bin:$PATH"
export HISTSIZE=100000000
export HISTFILESIZE=100000000
export HISTDUP=erase
export HISTCONTROL=ignoreboth:erasedups
setopt appendhistory
setopt sharehistory
setopt HIST_FIND_NO_DUPS
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
if [ -d "$HOME/.oh-my-zsh" ]; then
else
    echo "Oh My Zsh is not installed. Installing now..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
fi

export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zoxide zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q


ZSH_THEME="powerlevel10k/powerlevel10k"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto # update automatically without asking
DISABLE_MAGIC_FUNCTIONS="false"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"

source $ZSH/oh-my-zsh.sh
# You may need to manually set your language environment
export LANG=en_US.UTF-8

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

mkdir -p ${ZDOTDIR:-~}/.zsh_functions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export EDITOR='nvim'

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
	export TERM='xterm-256color'
else
        command
	export TERM='xterm-256color'
fi

# Detect which `ls` flavor is in use
if ls --color >/dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
	export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# ----------------------------------------------------------------------------
function cpwd() {
        pwd | tr -d '\n' | pbcopy
        echo -n "Copied to clipboard: "
        pwd
}
# ----------------------------------------------------------------------------
eval "$(zoxide init --cmd cd zsh)"
source <(fzf --zsh)
# Enable colors and change prompt:
autoload -U colors && colors # Load colors
# eval "$(starship init zsh)"

for config (~/.config/zsh/*.zsh) source $config
