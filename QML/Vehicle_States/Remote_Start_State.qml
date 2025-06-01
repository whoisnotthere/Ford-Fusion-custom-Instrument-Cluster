import QtQuick
//IMPORT StyleSheet, FontsManager
import "../"

Item {
    id: remote_Start_Item
    width: 1920
    height: 720

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    Item {
        id: remote_Start_Container
        height: 200
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 300
        anchors.leftMargin: 300

        Text {
            id: remote_Start_Title
            color: "white"
            text: "REMOTE START"
            anchors.top: parent.top
            font.pixelSize: 60
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: FontsManager.systemFont_Bold.name
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: remote_Start_Prompt
            color: "white"
            text: "To Drive: Press Start/Stop Button"
            anchors.bottom: parent.bottom
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.bottomMargin: 0
            font.family: FontsManager.systemFont_Bold.name
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:2}
}
##^##*/
