import QtQuick

Item {
  id: root

  visible: false

  property int connectionCount: 0
  property string clientName: ""
  property string clientModel: ""
  property string clientDeviceId: ""
  property string lastError: ""
  readonly property bool connected: connectionCount > 0
  readonly property bool known: clientName !== ""

  function clearClient() {
    connectionCount = 0
    clientName = ""
    clientModel = ""
    clientDeviceId = ""
  }

  function reset() {
    clearClient()
    lastError = ""
  }

  function setExitError(exitCode) {
    if (exitCode === 127) {
      lastError = "UxPlay is not installed. Run: omarchy pkg aur add uxplay."
      return
    }
    lastError = "UxPlay stopped unexpectedly (exit code " + exitCode + ")."
  }

  function handleLog(line) {
    var text = String(line || "").trim()
    if (text === "") return

    var request = text.match(/^connection request from (.+?) \(([^)]*)\) with deviceID = (.+)$/)
    if (request) {
      clientName = request[1]
      clientModel = request[2]
      clientDeviceId = request[3]
      return
    }

    var connections = text.match(/^Open connections:\s*(\d+)$/i)
    if (connections) {
      connectionCount = Number(connections[1])
      if (connectionCount === 0) clearClient()
      return
    }

    if (text.toLowerCase().indexOf("lost connection with client") !== -1) {
      clearClient()
      return
    }

    var error = text.match(/^\*{3}\s*ERROR:\s*(.*)$/i)
    if (error) lastError = error[1]
  }
}
