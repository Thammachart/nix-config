const hyprland = await Service.import("hyprland")
const notifications = await Service.import("notifications")
const mpris = await Service.import("mpris")
const audio = await Service.import("audio")
const battery = await Service.import("battery")
const systemtray = await Service.import("systemtray")

const date = Variable("", {
  poll: [30000, 'date "+%H:%M %b %e"'],
})

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

function Workspaces() {
  const activeId = hyprland.active.workspace.bind("id")
  const workspaces = hyprland.bind("workspaces")
    .as(ws => ws.map(({ id }) => Widget.Button({
      on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
      child: Widget.Label(`${id}`),
      class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
    })))

  return Widget.Box({
    class_name: "workspaces",
    children: workspaces,
  })
}


function ClientTitle() {
  return Widget.Label({
    class_name: "client-title",
    label: hyprland.active.client.bind("title"),
  })
}


function Clock() {
  return Widget.Label({
    class_name: "clock",
    label: date.bind(),
  })
}


// we don't need mako or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
  const popups = notifications.bind("popups")
  return Widget.Box({
    class_name: "notification",
    visible: popups.as(p => p.length > 0),
    children: [
      Widget.Icon({
        icon: "preferences-system-notifications-symbolic",
      }),
      Widget.Label({
        label: popups.as(p => p[0]?.summary || ""),
      }),
    ],
  })
}


function Media() {
  const label = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0]
      return `${track_artists.join(", ")} - ${track_title}`
    } else {
      return "Nothing is playing"
    }
  })

  return Widget.Button({
    class_name: "media",
    on_primary_click: () => mpris.getPlayer("")?.playPause(),
    on_scroll_up: () => mpris.getPlayer("")?.next(),
    on_scroll_down: () => mpris.getPlayer("")?.previous(),
    child: Widget.Label({ label }),
  })
}


function VolumeIndicator(type = 'speaker') {
  const audioStream = audio[type];

  return Widget.Button({
    onClicked: () => audioStream.is_muted = !audioStream.is_muted,
    onScrollUp: () => audioStream.volume = Math.min(1.0, audioStream.volume + 0.05),
    onScrollDown: () => audioStream.volume = Math.max(0.0, audioStream.volume - 0.05),
    child: Widget.Icon().hook(audio, self => {
      const vol = audioStream.is_muted ? 0.0 : audioStream.volume * 100;
      const icon = [
        [101, 'overamplified'],
        [67, 'high'],
        [34, 'medium'],
        [1, 'low'],
        [0, 'muted'],
      ].find(([threshold]) => threshold <= vol)?.[1];

      self.icon = type === 'speaker' ? `audio-volume-${icon}-symbolic` : `audio-input-microphone-${icon}-symbolic`;
      self.tooltip_text = `Volume ${Math.floor(vol)}%`;
    }, `${type}-changed`),
  })
}


function BatteryLabel() {
  const value = battery.bind("percent").as(p => p > 0 ? p / 100 : 0)
  const icon = battery.bind("percent").as(p =>
    `battery-level-${Math.floor(p / 10) * 10}-symbolic`)

  return Widget.Box({
    class_name: "battery",
    visible: battery.bind("available"),
    children: [
      Widget.Icon({ icon }),
      Widget.LevelBar({
        widthRequest: 140,
        vpack: "center",
        value,
      }),
    ],
  })
}


function SysTray() {
  const items = systemtray.bind("items")
    .as(items => items.map(item => Widget.Button({
      child: Widget.Icon({ icon: item.bind("icon") }),
      on_primary_click: (_, event) => item.activate(event),
      on_secondary_click: (_, event) => item.openMenu(event),
      tooltip_markup: item.bind("tooltip_markup"),
    })))

  return Widget.Box({
    children: items,
  })
}


// layout of the bar
function Left() {
  return Widget.Box({
    spacing: 8,
    children: [
      Workspaces(),
    ],
  })
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [
      ClientTitle(),
    ],
  })
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [
      VolumeIndicator('speaker'),
      VolumeIndicator('microphone'),
      Clock(),
      SysTray(),
    ],
  })
}

function Bar(monitor = 0) {
  const window = Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  })

  return window;
}

App.config({
  style: "./style.css",
  windows: [
    Bar(),

    // you can call it, for each monitor
    // Bar(0),
    // Bar(1)
  ],
})

export { }
