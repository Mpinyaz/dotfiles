export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"
if grep -qi 'arch' /etc/os-release 2>/dev/null || command -v pacman &>/dev/null; then

alias p="sudo pacman"

alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"


        function command_not_found_handler {
                local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
                printf 'zsh: command not found: %s\n' "$1"
                local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
                if (( ${#entries[@]} )) ; then
                        printf "${bright}$1${reset} may be found in the following packages:\n"
                        local pkg
                        for entry in "${entries[@]}" ; do
                                local fields=( ${(0)entry} )
                                if [[ "$pkg" != "${fields[2]}" ]] ; then
                                        printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
                                fi
                                printf '    /%s\n' "${fields[4]}"
                                pkg="${fields[2]}"
                        done
                fi
                return 127
        }

        setopt autocd

    # Detect the AUR wrapper
    if pacman -Qi yay &>/dev/null ; then
            aurhelper="yay"
    elif pacman -Qi paru &>/dev/null ; then
            aurhelper="paru"
    fi

    function in {
            local pkg="$1"
            if pacman -Si "$pkg" &>/dev/null ; then
                    sudo pacman -S "$pkg"
            else
                    "$aurhelper" -S "$pkg"
            fi
    }

    function arch-package-count() {
            echo -n "All Packages: "
            pacman -Q | wc -l
            echo -n "  Packages: "
            pacman -Qe | wc -l
            echo -n "    Official Packages: "
            pacman -Qen | wc -l
            echo -n "    AUR Packages: "
            pacman -Qem | wc -l
            echo -n "  Dependent Packages: "
            pacman -Qd | wc -l
            echo -n "    Official Dependent Packages: "
            pacman -Qdn | wc -l
            echo -n "    AUR Dependent Packages: "
            pacman -Qdm | wc -l
    }

fi
if [[ "$(uname -s)" == "Darwin" ]]; then
  # Check if it's Apple Silicon or Intel Mac
  if [[ "$(uname -m)" == "arm64" ]]; then
    # Apple Silicon Mac (M1/M2/etc.)
    export PATH="/opt/homebrew/bin:$PATH"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    # Intel Mac
    export PATH="/usr/local/bin:$PATH"
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  # Homebrew completions (works for both architectures)
  if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
