import QtQuick
import Quickshell.Io
Item {
  id: root
  visible: false
  property var preferences: null
  property bool stopping: false
  property bool restartPending: false
  property bool startPending: false
  property int restartDelay: 350
  property alias running: process.running
  signal logLine(string line)
  signal exited(int exitCode, bool expected)
  function start() {
    stopping = false
    restartPending = false
    startPending = true
    windowRule.running = true
  }
  function stop() {
    startPending = false
    windowRule.running = false
    if (!process.running) return
    stopping = true
    restartPending = false
    restartTimer.stop()
    process.running = false
  }
  function restart() {
    if (!process.running) return
    stopping = true
    restartPending = true
    restartDelay = 350
    process.running = false
    restartTimer.restart()
  }
  function disconnectClient() {
    if (!process.running) return
    stopping = true
    restartPending = true
    restartDelay = 1000
    process.running = false
    restartTimer.restart()
  }
  Timer {
    id: restartTimer
    interval: root.restartDelay
    repeat: false
    onTriggered: if (root.restartPending) root.start()
  }
  Process {
    id: windowRule

    command: [
      "hyprctl",
      "eval",
      "hl.window_rule({ match = { class = \"^uxplay$\" }, fullscreen = "
        + (root.preferences && root.preferences.fullscreen ? "true" : "false")
        + ", float = "
        + (root.preferences && root.preferences.fullscreen ? "true" : "false")
        + " })"
    ]

    onExited: if (root.startPending) {
      root.startPending = false
      process.running = true
    }
  }
  Process {
    id: process

    command: [
      "uxplay",
      "-n", root.preferences ? root.preferences.name : "Linux AirPlay",
      "-nh",
      "-nohold",
      "-reset", "0",
      "-m",
      "-p", root.preferences ? root.preferences.port : "53317",
      "-vs", root.preferences && root.preferences.fullscreen
        ? "waylandsink fullscreen=true" : "waylandsink",
      "-as", "pipewiresink",
      "-vsync", "no",
      "-fps", String(root.preferences ? root.preferences.fps : 30)
    ].concat(root.preferences && root.preferences.fullscreen ? ["-fs"] : [])
      .concat(["-d", "1"])
    stdout: SplitParser {
      onRead: function(line) { root.logLine(line) }
    }
    stderr: SplitParser {
      onRead: function(line) { root.logLine(line) }
    }
    onExited: {
      var expected = root.stopping
      root.stopping = false
      root.exited(arguments[0], expected)
    }
  }
}
