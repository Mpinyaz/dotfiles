# Creates a folder named with the current or prefixed date, using the format "prefix-YYYY-MM-DD" if a prefix is provided.
function mkdd() {
        mkdir -p ${1:+$1$prefix_separator}"$(date +%F)"
}
# Display calendar with day highlighted
function cal() {
        if [ -t 1 ]; then alias cal="ncal -b"; else alias cal="/usr/bin/cal"; fi
}

function cds() {
        session=$(tmux display-message -p '#{session_path}')
        cd "$session"
}

function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
                builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
}
