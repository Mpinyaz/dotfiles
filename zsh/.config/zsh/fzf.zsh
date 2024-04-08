#!/bin/zsh

# Run command/application and choose paths/files with fzf.
# Always return control of the terminal to user (e.g. when opening GUIs).
# The full command that was used will appear in your history just like any
# other (N.B. to achieve this I write the shell's active history to
# ~/.bash_history)
#
# Usage:
# fz cd [OPTION]... (hit enter, choose path)
# fz cat [OPTION]... (hit enter, choose files)
# fz vim [OPTION]... (hit enter, choose files)
# fz vlc [OPTION]... (hit enter, choose files)

fz() {
    local program options arguments

    # if no arguments passed, just launch fzf
    if [ $# -eq 0 ]; then
        fzf | sort
        return 0
    fi

    # store the program
    program="$1"

    # remove first argument off the list
    shift

    # store any option flags
    options="$@"

    # store the arguments from fzf
    arguments=$(fzf --multi)

    # if no arguments passed (e.g. if Esc pressed), return to terminal
    if [ -z "${arguments}" ]; then
        return 1
    fi

    # sanitize the command and arguments
        for arg in "${arguments[@]}"; do
        arguments=$(echo "$arg" | sed "s/'/''/g;
                                       s/.*/'&'/g;
                                       s/\n//g"
                   )
    done

        # execute the command
    eval "$program $options $arguments"
}
