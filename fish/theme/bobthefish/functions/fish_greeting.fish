function fish_greeting -d "What's up, fish?"
    set_color $fish_color_autosuggestion

    echo "⟹ Host     : "(uname -nmsr)
    echo "⟹ Uptime   : "(uptime -p | string replace "up " "")
    echo "⟹ Load Avg : "(uptime | awk -F'load average: ' '{print $2}')
    echo "⟹ Shell    : fish "(fish --version | awk '{print $3}')
    echo "⟹ Packages : "(pacman -Qq | wc -l)" installed"

    if type -q upower
        set battery (upower -i (upower -e | grep BAT) | grep -E "percentage" | awk '{print $2}')
        if test -n "$battery"
            echo "⟹ Battery  : $battery"
        end
    end

    if type -q lspci
        set gpu (lspci | grep -E "VGA|3D" | cut -d ':' -f3- | head -n 1)
        if test -n "$gpu"
            echo "⟹ GPU      : $gpu"
        end
    end

    set_color normal
end
