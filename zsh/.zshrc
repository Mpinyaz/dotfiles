##################################################################
#
#       ███╗   ███╗██████╗ ██╗███╗   ██╗██╗   ██╗ █████╗ ███████╗
#       ████╗ ████║██╔══██╗██║████╗  ██║╚██╗ ██╔╝██╔══██╗╚══███╔╝
#       ██╔████╔██║██████╔╝██║██╔██╗ ██║ ╚████╔╝ ███████║  ███╔╝
#       ██║╚██╔╝██║██╔═══╝ ██║██║╚██╗██║  ╚██╔╝  ██╔══██║ ███╔╝
#       ██║ ╚═╝ ██║██║     ██║██║ ╚████║   ██║   ██║  ██║███████╗
#       ╚═╝     ╚═╝╚═╝     ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
#################################################################
# Ensure path only contains unique elements
typeset -U path
path+=( /opt/nvim-linux64/bin )
path=( $HOME/.local/bin $path )
export HISTFILE=~/.zsh_history
export ZPROFILE="$HOME/.zprofile"
export EDITOR='nvim'
export HISTSIZE=100000000
export HISTFILESIZE=100000000
export HISTDUP=erase
export HISTCONTROL=ignoreboth:erasedups
export LC_ALL=en_US.UTF-8
export MANPAGER='nvim +Man!'
export LANG=en_US.UTF-8
export VISUAL=nvim
setopt appendhistory
setopt sharehistory
setopt HIST_FIND_NO_DUPS
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

[[ -f ~/.hushlogin ]] || touch ~/.hushlogin
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ "$OSTYPE" == darwin* ]]; then
        if ! (( $+commands[xclip] )); then
                echo "xclip is not installed. Installing now..."
                brew install xclip
        fi
        if [[ -x /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
                eval "$(/usr/local/bin/brew shellenv)"
        fi
fi

if [[ ! -d $HOME/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
        echo "powerlevel10k is being installed..."
        mkdir -p -m777 "$HOME/.oh-my-zsh/custom/themes"
        git clone https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
fi

[[ -d ~/.local/bin ]] || mkdir -p ~/.local/bin
[[ -d ~/.bin ]] || mkdir -p ~/.bin
path=( $HOME/.bin $HOME/.local/bin $path )

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
        echo "tpm is being installed..."
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ ! -d ~/.autoenv ]]; then
        echo "autoenv is being installed..."
        git clone https://github.com/hyperupcall/autoenv ~/.autoenv
fi
[[ -f ~/.autoenv/activate.sh ]] && source ~/.autoenv/activate.sh
# Function to check if a plugin is installed, and if not, clone it
install_plugin() {
        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$1"
        local plugin_repo="$2"

        if [ ! -d "$plugin_dir" ]; then
                echo "$1 is not installed. Cloning now..."
                git clone "$plugin_repo" "$plugin_dir"
        fi
}

# Check if Oh My Zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then

        # Install plugins if not already installed
        install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
        install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        install_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        install_plugin "zsh-autocomplete" "https://github.com/marlonrichert/zsh-autocomplete.git"
        install_plugin "fzf-tab" "https://github.com/Aloxaf/fzf-tab.git"
else
        echo "Oh My Zsh is not installed. Installing now..."

        # Install Oh My Zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

        # Install plugins
        install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
        install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
        install_plugin "fast-syntax-highlighting" "https://github.com/zdharma-continuum/fast-syntax-highlighting.git"
        install_plugin "zsh-autocomplete" "https://github.com/marlonrichert/zsh-autocomplete.git"
        install_plugin "fzf-tab" "https://github.com/Aloxaf/fzf-tab.git"
fi

export ZSH="$HOME/.oh-my-zsh"
# Removed redundant zsh-syntax-highlighting (fast-syntax-highlighting is a faster replacement)
plugins=(git zsh-autosuggestions command-not-found fzf-tab fast-syntax-highlighting zsh-autocomplete sudo copypath dircycle autoenv)

ZSH_THEME="powerlevel10k/powerlevel10k"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto # update automatically without asking
DISABLE_MAGIC_FUNCTIONS="false"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
HIST_STAMPS="yyyy-mm-dd"
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
source $ZSH/oh-my-zsh.sh
# You may need to manually set your language environment
export LANG=en_US.UTF-8

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ -f "$HOME/.zprofile" ]] && source "$HOME/.zprofile"
[[ -d ${ZDOTDIR:-~}/.zsh_functions ]] || mkdir -p ${ZDOTDIR:-~}/.zsh_functions
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Detect which `ls` flavor is in use using built-in variable to avoid execution overhead
if [[ "$OSTYPE" == linux* ]]; then # GNU `ls`
        colorflag="--color"
        export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls` / BSD `ls`
        colorflag="-G"
        export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# ----------------------------------------------------------------------------
function cpwd() {
        pwd | tr -d '\n' | xclip
        echo -n "Copied to clipboard: "
        pwd
}
# ----------------------------------------------------------------------------
# Zoxide initialization cached to improve shell startup speed
if (( $+commands[zoxide] )); then
        local zoxide_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zoxide-init.zsh"
        if [[ ! -f "$zoxide_cache" || "$commands[zoxide]" -nt "$zoxide_cache" ]]; then
                [[ -d "${zoxide_cache:h}" ]] || mkdir -p "${zoxide_cache:h}"
                zoxide init zsh --cmd cd > "$zoxide_cache" 2>/dev/null
        fi
        source "$zoxide_cache"
fi

# FZF initialization cached to improve shell startup speed
if (( $+commands[fzf] )); then
        local fzf_cache="${XDG_CACHE_HOME:-$HOME/.cache}/fzf-init.zsh"
        if [[ ! -f "$fzf_cache" || "$commands[fzf]" -nt "$fzf_cache" ]]; then
                [[ -d "${fzf_cache:h}" ]] || mkdir -p "${fzf_cache:h}"
                fzf --zsh > "$fzf_cache" 2>/dev/null
        fi
        source "$fzf_cache"
fi

# Enable colors and change prompt:
autoload -U colors && colors # Load colors
# eval "$(starship init zsh)"

# SSH Agent configuration (only run ssh-add if key is not already loaded)
if [[ -f ~/.ssh/id_rsa && -n "$SSH_AUTH_SOCK" ]]; then
        ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_rsa >/dev/null 2>&1
fi

# Source custom configs with Zsh's nullglob to avoid errors if no configs exist
for config in ~/.config/zsh/*.zsh(N); do
        source "$config"
done


# Added by Antigravity CLI installer
export PATH="/home/mpinyaz/.local/bin:$PATH"
