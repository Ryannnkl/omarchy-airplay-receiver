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
        visible: root.clientState ? root.clientState.lastError !== "" : false
        width: parent.width
        text: root.clientState ? root.clientState.lastError : ""
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
        fullscreen: root.preferences ? root.preferences.fullscreen : false
        fps: root.preferences ? root.preferences.fps : 30
        restartNeeded: root.preferences ? root.preferences.restartNeeded : false
        onFullScreenToggled: function(enabled) { if (root.preferences) root.preferences.setFullscreen(enabled) }
        onFpsSelected: function(value) { if (root.preferences) root.preferences.setFps(value) }
        onRestartClicked: if (root.receiver) root.receiver.restart()
      }

      PanelSeparator { foreground: root.panel.foreground }

      AirplayClientInfo {
        width: parent.width
        foreground: root.panel.foreground
        fontFamily: root.panel.fontFamily
        connected: root.clientState ? root.clientState.connected : false
        clientName: root.clientState ? root.clientState.clientName : ""
        clientModel: root.clientState ? root.clientState.clientModel : ""
        clientDeviceId: root.clientState ? root.clientState.clientDeviceId : ""
        onDisconnectClicked: if (root.receiver) root.receiver.disconnectClient()
      }

      Text {
        visible: !!(root.receiver && root.receiver.running && root.clientState && !root.clientState.known)
        width: parent.width
        text: "No Mac is connected. Start Screen Mirroring on the Mac to connect."
        color: Qt.darker(root.panel.foreground, 1.5)
        font.family: root.panel.fontFamily
        font.pixelSize: Style.font.bodySmall
        wrapMode: Text.WordWrap
      }

      Text {
        visible: !root.receiver || !root.receiver.running
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
