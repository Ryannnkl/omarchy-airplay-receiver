import QtQuick
import qs.Commons
import qs.Ui

Column {
  id: root
  property color foreground
  property string fontFamily
  property bool connected
  property string clientName
  property string clientModel
  property string clientDeviceId
  signal disconnectClicked()
  width: parent ? parent.width : 0
  spacing: Style.space(10)
  visible: root.clientName !== ""
  Row {
    width: parent.width
    spacing: Style.space(10)
    PanelSectionHeader {
      width: parent.width - disconnectButton.width - parent.spacing
      text: root.connected ? "CONNECTED" : "CONNECTING"
      foreground: root.foreground
      fontFamily: root.fontFamily
    }
    Button {
      id: disconnectButton
      visible: root.clientName !== ""
      width: Style.space(100)
      text: "Disconnect"
      bordered: true
      foreground: root.foreground
      fontFamily: root.fontFamily
      fontSize: Style.font.bodySmall
      verticalPadding: Style.spacing.controlPaddingY
      onClicked: root.disconnectClicked()
    }
  }
  BorderSurface {
    width: parent.width
    implicitHeight: clientRow.implicitHeight + Style.space(20)
    color: Style.selectedFillFor(root.foreground, Color.accent)
    radius: Style.cornerRadius
    borderSpec: Border.none()
    Row {
      id: clientRow
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      anchors.leftMargin: Style.space(12)
      anchors.rightMargin: Style.space(12)
      spacing: Style.space(12)

      Text {
        text: String.fromCodePoint(0xF0018)
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.heading
        anchors.verticalCenter: parent.verticalCenter
      }

      Column {
        width: parent.width - parent.spacing - Style.font.heading
        spacing: Style.space(2)

        Text {
          width: parent.width
          text: root.clientName
          color: root.foreground
          font.family: root.fontFamily
          font.pixelSize: Style.font.body
          elide: Text.ElideRight
        }

        Text {
          width: parent.width
          text: root.clientModel
          color: Qt.darker(root.foreground, 1.3)
          font.family: root.fontFamily
          font.pixelSize: Style.font.caption
          elide: Text.ElideRight
        }

        Text {
          width: parent.width
          text: root.clientDeviceId
          color: Qt.darker(root.foreground, 1.5)
          font.family: root.fontFamily
          font.pixelSize: Style.font.caption
          elide: Text.ElideRight
        }
      }
    }
    MouseArea {
      anchors.fill: parent
      enabled: root.clientName !== ""
      onClicked: root.disconnectClicked()
    }
  }
}
