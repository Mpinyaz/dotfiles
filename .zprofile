alias p="sudo pacman"
if grep -qi 'arch' /etc/os-release 2>/dev/null || command -v pacman &>/dev/null; then

        alias p="sudo pacman"

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
