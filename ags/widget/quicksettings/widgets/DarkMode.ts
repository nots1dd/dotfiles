import { Menu, SimpleToggleButton } from "../ToggleButton"
import icons from "lib/icons"
import { sh } from "lib/utils"
import options from "options"

const { scheme } = options.theme

export const WallpaperToggle = () => Menu({
    name: "wallpaperToggle",
    icon: icons.ui.settings,
    title: "Wallpaper Selector",
    content: [
        Widget.Button({
            on_clicked: () => sh("~/dotfiles/scripts/wals-change.sh"),
            child: Widget.Box({
                children: [
                    Widget.Icon(icons.ui.settings),
                    Widget.Label("Wallpaper Change"),
                ],
            }),
        }),
    ]
})

