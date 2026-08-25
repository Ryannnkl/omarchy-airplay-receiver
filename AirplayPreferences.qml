import QtQuick
import Quickshell

Item {
  id: root

  visible: false

  property string pluginId: ""
  property var config: ({})
  property bool receiverRunning: false
  property bool restartNeeded: false
  property bool fullscreen: root.booleanSetting("fullscreen", false)
  property int fps: Number(root.setting("fps", 30)) === 60 ? 60 : 30
  readonly property string name: String(root.setting("name", "Linux AirPlay"))
  readonly property string port: String(root.setting("port", "53317"))

  function setting(name, fallback) {
    var value = config ? config[name] : undefined
    return value === undefined || value === null ? fallback : value
  }

  function booleanSetting(name, fallback) {
    var value = root.setting(name, fallback)
    return value === true || value === "true" || value === 1
  }

  function saveSetting(name, value) {
    Quickshell.execDetached([
      "omarchy",
      "bar",
      "set",
      root.pluginId,
      name,
      String(value),
      "--json"
    ])
  }

  function setFullscreen(value) {
    var next = value === true
    if (fullscreen === next) return
    fullscreen = next
    saveSetting("fullscreen", next)
    if (receiverRunning) restartNeeded = true
  }

  function setFps(value) {
    var next = Number(value) === 60 ? 60 : 30
    if (fps === next) return
    fps = next
    saveSetting("fps", next)
    if (receiverRunning) restartNeeded = true
  }

  onReceiverRunningChanged: if (!receiverRunning) restartNeeded = false
}
