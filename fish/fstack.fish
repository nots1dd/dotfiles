if not set -q fstack_dirs
    set -g fstack_dirs $PWD  # Start with the current directory
end

function fstack_update --on-variable PWD
    # Ignore `.git` and any subdirectories under it
    if string match -q "*/.git*" "$PWD"
        return
    end

    if not contains $PWD $fstack_dirs
        set -g fstack_dirs $PWD $fstack_dirs  # Prepend new unique directory
    end
end

function fst
    set -l dirs (printf "%s\n" $fstack_dirs | fzf --height=40% --reverse --prompt="Dir Stack >> " \
        --preview 'ls -la --color=never {}' \
        --bind "pgdn:preview-down,pgup:preview-up" \
        --bind "down:preview-down,up:preview-up" \
        --bind "ctrl-j:preview-down,ctrl-k:preview-up")

    if test -n "$dirs"
        cd "$dirs"
    end
end
