import QtQuick
import qs.Commons
import qs.Ui

Item {
  id: root

  property var panel
  property var receiver
  property var clientState

  width: parent ? parent.width : 0
  implicitHeight: hero.implicitHeight

  PanelHero {
    id: hero
    width: parent.width
    title: "AirPlay Receiver"
    meta: root.receiver && root.receiver.running
      ? (root.clientState && root.clientState.connected ? "Connected"
        : root.clientState && root.clientState.known ? "Connecting" : "Ready to Connect")
      : "Turned Off"
    foreground: root.panel.foreground
    fontFamily: root.panel.fontFamily
    iconOpacity: root.receiver && root.receiver.running ? 1.0 : 0.5
    iconComponent: Component {
      Text {
        text: String.fromCodePoint(0xF0018)
        color: root.panel.foreground
        font.family: root.panel.fontFamily
        font.pixelSize: Style.font.display
      }
    }
    trailingControl: Component {
      ToggleSwitch {
        checked: !!(root.receiver && root.receiver.running)
        foreground: root.panel.foreground
        accent: Color.accent
        onToggled: root.panel.toggleReceiver()
      }
    }
  }
}
