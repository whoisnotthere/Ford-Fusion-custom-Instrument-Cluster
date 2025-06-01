import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    width: 270
    height: 120

    Text {
        id: text1
        x: 62
        y: 48
        color: "#ff1111"
        text: qsTr("CONTACTS NOT AVAILABLE")
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 22
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.family: FontsManager.systemFont_Medium.name
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:2}
}
##^##*/
