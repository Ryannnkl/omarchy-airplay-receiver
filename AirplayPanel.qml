import QtQuick
import qs.Commons
import qs.Ui

Panel {
  id: root

  readonly property string pluginId: "io.github.ryannnkl.airplay-receiver"
  readonly property bool receiverEnabled: receiver.running
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property string icon: String.fromCodePoint(0xF0018)

  moduleName: root.pluginId
  manageIpc: false
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  AirplayPreferences {
    id: preferences
    pluginId: root.pluginId
    config: root.settings
    receiverRunning: receiver.running
  }

  AirplayState {
    id: state
  }

  AirplayReceiver {
    id: receiver
    preferences: preferences
    onLogLine: function(line) { state.handleLog(line) }
    onExited: function(exitCode, expected) {
      state.clearClient()
      if (!expected && exitCode !== 0) state.setExitError(exitCode)
    }
  }

  function toggleReceiver() {
    if (receiver.running) receiver.stop()
    else {
      state.reset()
      receiver.start()
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.icon
    active: root.receiverEnabled
    activeColor: Color.accent
    tooltipText: "Open AirPlay receiver"
    onPressed: function(buttonCode) {
      if (buttonCode === Qt.RightButton) root.toggleReceiver()
      else root.toggle()
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: content.focusTarget
    contentWidth: panel.fittedContentWidth(Style.space(380))
    contentHeight: panel.fittedContentHeight(content.implicitHeight, Style.space(520))

    AirplayPanelContent {
      id: content
      anchors.fill: parent
      panel: root
      receiver: receiver
      preferences: preferences
      clientState: state
    }
  }

  onOpenedChanged: if (opened) Qt.callLater(function() { content.focusTarget.forceActiveFocus() })
}
