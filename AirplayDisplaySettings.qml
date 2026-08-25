import QtQuick
import qs.Commons
import qs.Ui

Column {
  id: root

  property color foreground
  property string fontFamily
  property bool fullscreen
  property int fps
  property bool restartNeeded

  signal fullScreenToggled(bool enabled)
  signal fpsSelected(int value)
  signal restartClicked()
  width: parent ? parent.width : 0
  spacing: Style.space(10)

  PanelSectionHeader {
    text: "DISPLAY"
    foreground: root.foreground
    fontFamily: root.fontFamily
  }

  Item {
    width: parent.width
    implicitHeight: Math.max(fullscreenLabel.implicitHeight, fullscreenSwitch.implicitHeight)

    Text {
      id: fullscreenLabel
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      text: "Full screen"
      color: root.foreground
      font.family: root.fontFamily
      font.pixelSize: Style.font.body
    }

    ToggleSwitch {
      id: fullscreenSwitch
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      checked: root.fullscreen
      foreground: root.foreground
      accent: Color.accent
      onToggled: root.fullScreenToggled(!root.fullscreen)
    }
  }

  Row {
    id: fpsSelector
    width: parent.width
    spacing: Style.spacing.md

    readonly property real cellWidth: (width - spacing) / 2

    Repeater {
      model: [30, 60]

      Button {
        required property int modelData
        width: fpsSelector.cellWidth
        text: modelData + " FPS"
        selected: root.fps === modelData
        bordered: true
        foreground: root.foreground
        fontFamily: root.fontFamily
        fontSize: Style.font.bodySmall
        verticalPadding: Style.spacing.controlPaddingY
        onClicked: root.fpsSelected(modelData)
      }
    }
  }

  Column {
    visible: root.restartNeeded
    width: parent.width
    spacing: Style.space(8)

    Text {
      width: parent.width
      text: "Display changes are waiting for a restart."
      color: Qt.darker(root.foreground, 1.4)
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      wrapMode: Text.WordWrap
    }

    Button {
      width: parent.width
      text: "Restart receiver"
      bordered: true
      foreground: root.foreground
      fontFamily: root.fontFamily
      fontSize: Style.font.bodySmall
      onClicked: root.restartClicked()
    }
  }
}
