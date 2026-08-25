import QtQuick
import qs.Commons
import qs.Ui

Item {
  id: root
  property var panel
  property var receiver
  property var preferences
  property var clientState
  readonly property var focusTarget: keyCatcher
  implicitHeight: column.implicitHeight
  PanelKeyCatcher {
    id: keyCatcher
    anchors.fill: parent
    onCloseRequested: root.panel.close()
    onTabRequested: function(direction) { root.panel.switchPanel(direction) }
    onTextKey: function(text) {
      if (text === "a" || text === "A") root.panel.toggleReceiver()
    }
  }
  Flickable {
    anchors.fill: parent
    contentWidth: width
    contentHeight: column.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    flickableDirection: Flickable.VerticalFlick
    interactive: contentHeight > height
    Column {
      id: column
      width: parent.width
      spacing: Style.space(14)

      AirplayReceiverHero {
        width: parent.width
        panel: root.panel
        receiver: root.receiver
        clientState: root.clientState
      }

      Text {
        visible: root.clientState.lastError !== ""
        width: parent.width
        text: root.clientState.lastError
        color: root.panel.bar ? root.panel.bar.urgent : Color.urgent
        font.family: root.panel.fontFamily
        font.pixelSize: Style.font.bodySmall
        wrapMode: Text.WordWrap
      }

      PanelSeparator { foreground: root.panel.foreground }

      AirplayDisplaySettings {
        width: parent.width
        foreground: root.panel.foreground
        fontFamily: root.panel.fontFamily
        fullscreen: root.preferences.fullscreen
        fps: root.preferences.fps
        restartNeeded: root.preferences.restartNeeded
        onFullScreenToggled: function(enabled) { root.preferences.setFullscreen(enabled) }
        onFpsSelected: function(value) { root.preferences.setFps(value) }
        onRestartClicked: root.receiver.restart()
      }

      PanelSeparator { foreground: root.panel.foreground }

      AirplayClientInfo {
        width: parent.width
        foreground: root.panel.foreground
        fontFamily: root.panel.fontFamily
        connected: root.clientState.connected
        clientName: root.clientState.clientName
        clientModel: root.clientState.clientModel
        clientDeviceId: root.clientState.clientDeviceId
        onDisconnectClicked: root.receiver.disconnectClient()
      }

      Text {
        visible: root.receiver.running && !root.clientState.known
        width: parent.width
        text: "No Mac is connected. Start Screen Mirroring on the Mac to connect."
        color: Qt.darker(root.panel.foreground, 1.5)
        font.family: root.panel.fontFamily
        font.pixelSize: Style.font.bodySmall
        wrapMode: Text.WordWrap
      }

      Text {
        visible: !root.receiver.running
        width: parent.width
        text: "Turn on the receiver to make Linux AirPlay available to nearby Macs."
        color: Qt.darker(root.panel.foreground, 1.5)
        font.family: root.panel.fontFamily
        font.pixelSize: Style.font.bodySmall
        wrapMode: Text.WordWrap
      }
    }
  }
}
