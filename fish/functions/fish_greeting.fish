function fish_greeting -d "What's up, fish?"
    set_color $fish_color_autosuggestion

    echo ""
    echo "󱄅  Host      : "(uname -nmsr)
    echo "󰅐  Uptime    : "(uptime -p | string replace "up " "")
    echo "  Load Avg  : "(uptime | awk -F'load average: ' '{print $2}')
    echo "  Shell     : fish "(fish --version | awk '{print $3}')
    echo "󰏖  Packages  : "(pacman -Qq | wc -l)" installed"

    echo "  Processes : "(ps ax | wc -l | string trim)

    if type -q xrandr
        set display (xrandr | grep '*' | awk '{print $1}')
        if test -n "$display"
            echo "󰍹  Display   : $display"
        end
    end

    if type -q df
        echo "󰋊  Disk      : "(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    end

    if type -q upower
        set battery (upower -i (upower -e | grep BAT) | grep -E "percentage" | awk '{print $2}')
        if test -n "$battery"
            echo "󰁹  Battery   : $battery"
        end
    end

    set_color normal
    echo ""
end
