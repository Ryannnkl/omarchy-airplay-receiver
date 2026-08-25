import QtQuick
import qs.Commons
import qs.Ui

Panel {
  id: root

  readonly property string pluginId: "io.github.ryannnkl.airplay-receiver"
  readonly property var service: bar?.shell?.serviceFor(root.pluginId)
  readonly property bool receiverEnabled: !!(root.service && root.service.running)
  readonly property string fontFamily: bar ? bar.fontFamily : Style.font.family
  readonly property color foreground: bar ? bar.foreground : Color.foreground
  readonly property string icon: String.fromCodePoint(0xF0018)

  moduleName: root.pluginId
  manageIpc: false
  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function toggleReceiver() {
    if (!root.service) return
    if (root.service.running) root.service.stop()
    else root.service.start()
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
      receiver: root.service
      preferences: root.service ? root.service.preferences : null
      clientState: root.service ? root.service.clientState : null
    }
  }

  onOpenedChanged: if (opened) Qt.callLater(function() { content.focusTarget.forceActiveFocus() })
}
