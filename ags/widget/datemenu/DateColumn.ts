import { clock, uptime } from "lib/variables"

function up(up: number) {
    const h = Math.floor(up / 60)
    const m = Math.floor(up % 60)
    return `uptime :: ${h}:${m < 10 ? "0" + m : m} hrs`
}

export default () => Widget.Box({
    vertical: true,
    class_name: "date-column vertical",
    children: [
        Widget.Box({
            class_name: "clock-box",
            vertical: true,
            children: [
                // Widget.Label({
                //     class_name: "clock",
                //     label: "Hello s1dd",
                // }),
                Widget.Label({
                    class_name: "clock",
                    label: clock.bind().as(t => t.format("%H:%M:%S")!),
                }),
                Widget.Label({
                    class_name: "clock_mini",
                    label: clock.bind().as(t => t.format("%d/%m/%Y")!),
                }),
                Widget.Label({
                    class_name: "uptime",
                    label: uptime.bind().as(up),
                }),
            ],
        }),
        Widget.Box({
            class_name: "calendar",
            children: [
                Widget.Calendar({
                    hexpand: true,
                    hpack: "center",
                }),
            ],
        }),
    ],
})
