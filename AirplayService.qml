import QtQuick

Item {
  id: root

  readonly property string pluginId: "io.github.ryannnkl.airplay-receiver"
  property var shell: null
  property var manifest: null
  readonly property var settings: root.settingsFor(shell ? shell.shellConfig : null)
  readonly property var preferences: preferencesItem
  readonly property var clientState: state
  readonly property bool running: receiver.running

  function settingsFor(config) {
    var layout = config && config.bar && config.bar.layout
    if (!layout) return ({})
    var sections = ["left", "center", "right"]
    for (var s = 0; s < sections.length; s++) {
      var entries = layout[sections[s]] || []
      for (var i = 0; i < entries.length; i++) {
        if (String(entries[i].id || "") === root.pluginId) return entries[i]
      }
    }
    return ({})
  }

  AirplayPreferences {
    id: preferencesItem
    pluginId: root.pluginId
    config: root.settings
    receiverRunning: root.running
  }

  AirplayState {
    id: state
  }

  AirplayReceiver {
    id: receiver
    preferences: preferencesItem
    onLogLine: function(line) { state.handleLog(line) }
    onExited: function(exitCode, expected) {
      state.clearClient()
      if (!expected && exitCode !== 0) state.setExitError(exitCode)
    }
  }

  function start() {
    state.reset()
    receiver.start()
  }

  function stop() { receiver.stop() }
  function restart() { receiver.restart() }
  function disconnectClient() { receiver.disconnectClient() }

  Component.onDestruction: receiver.stop()
}
