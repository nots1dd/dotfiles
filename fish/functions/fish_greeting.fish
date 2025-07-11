function fish_greeting -d "What's up, fish?"
    set_color $fish_color_autosuggestion

    echo "⟹ Host     : "(uname -nmsr)
    echo "⟹ Uptime   : "(uptime -p | string replace "up " "")
    echo "⟹ Load Avg : "(uptime | awk -F'load average: ' '{print $2}')
    echo "⟹ Shell    : fish "(fish --version | awk '{print $3}')
    echo "⟹ Packages : "(pacman -Qq | wc -l)" installed"

    if type -q df
        set_color $color_label
        echo -n "⟹ Disk     : "; set_color $color_value
        df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}'
    end

    if type -q upower
        set battery (upower -i (upower -e | grep BAT) | grep -E "percentage" | awk '{print $2}')
        if test -n "$battery"
            echo "⟹ Battery  : $battery"
        end
    end

    set_color normal
end
