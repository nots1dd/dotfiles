function nv
    # Save current directory
    set oldpwd (pwd)

    if test (count $argv) -eq 0
        nvim
        return
    end

    set target $argv[1]

    if test -f $target
        cd (dirname $target)
        nvim (basename $target)
    else
        cd $target
        nvim
    end

    cd $oldpwd
end
