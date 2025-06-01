import QtQuick
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 1920
    height: 720

    Text {
        id: text1
        color: StyleSheet.debug_Title
        text: "DEBUG MODE"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 150
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        anchors.leftMargin: 420
        anchors.rightMargin: 420
        font.family: FontsManager.systemFont_Bold.name
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
