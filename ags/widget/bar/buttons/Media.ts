import { type MprisPlayer } from "types/service/mpris"
import PanelButton from "../PanelButton"
import options from "options"
import icons from "lib/icons"
import { icon } from "lib/utils"

const mpris = await Service.import("mpris")
const { length, direction, preferred, monochrome, format } = options.bar.media

function lengthStr(length: number) {
    const min = Math.floor(length / 60)
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}

const getPlayer = (name = preferred.value) =>
    mpris.getPlayer(name) || mpris.players[0] || null

const Content = (player: MprisPlayer) => {
    const positionLabel = Widget.Label({
        class_name: "position",
        hpack: "start",
        setup: self => {
            const update = (_: unknown, time?: number) => {
                self.label = `(${lengthStr(time || player.position)} / `
                self.visible = player.length > 0
            }
            self.hook(player, update, "position")
            self.poll(1000, update)
        },
    })

    const lengthLabel = Widget.Label({
        class_name: "length",
        hpack: "end",
        visible: player.bind("length").as(l => l > 0),
        label: player.bind("length").as(length => `${lengthStr(length)})`),
    })

    

    const revealer = Widget.Revealer({
        click_through: true,
        visible: length.bind().as(l => l > 0),
        transition: direction.bind().as(d => `slide_${d}` as const),
        setup: self => {
            let current = ""
            self.hook(player, () => {
                if (current === player.track_title)
                    return

                current = player.track_title
                self.reveal_child = true
                Utils.timeout(3000, () => {
                    !self.is_destroyed && (self.reveal_child = false)
                })
            })
        },
        child: Widget.Box({
            orientation: "vertical",
            children: [
                Widget.Label({
                    truncate: "end",
                    max_width_chars: length.bind().as(n => n > 0 ? n : -1),
                    label: Utils.merge([
                        player.bind("track_title"),
                        player.bind("track_artists"),
                        format.bind(),
                    ], () => `${format}`
                        .replace("{title}", player.track_title)
                        .replace("{artists}", player.track_artists.join(", "))
                        .replace("{artist}", player.track_artists[0] || "")
                        .replace("{album}", player.track_album)
                        .replace("{name}", player.name)
                        .replace("{identity}", player.identity)
                    ),
                }),
                Widget.Box({
                    orientation: "horizontal",
                    children: [
                        positionLabel, // Display position
                        lengthLabel, // Display duration
                    ],
                }),
            ],
        }),
    })

    const playericon = Widget.Icon({
        icon: Utils.merge([player.bind("entry"), monochrome.bind()], (entry => {
            const name = `${entry}${monochrome.value ? "-symbolic" : ""}`
            return icon(name, icons.fallback.audio)
        })),
    })

    return Widget.Box({
        attribute: { revealer },
        children: direction.bind().as(d => d === "right"
            ? [playericon, revealer] : [revealer, playericon]),
    })
}


export default () => {
    let player = getPlayer()

    const btn = PanelButton({
        class_name: "media",
        child: Widget.Icon(icons.fallback.audio),
    })

    const update = () => {
        player = getPlayer()
        btn.visible = !!player

        if (!player)
            return

        const content = Content(player)
        const { revealer } = content.attribute
        btn.child = content
        btn.on_primary_click = () => { player.playPause() }
        btn.on_secondary_click = () => { player.playPause() }
        btn.on_scroll_up = () => { player.next() }
        btn.on_scroll_down = () => { player.previous() }
        btn.on_hover = () => { revealer.reveal_child = true }
        btn.on_hover_lost = () => { revealer.reveal_child = false }
    }

    return btn
        .hook(preferred, update)
        .hook(mpris, update, "notify::players")
}
