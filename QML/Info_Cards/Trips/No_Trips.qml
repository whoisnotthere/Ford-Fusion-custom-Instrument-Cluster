import QtQuick
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    Column {
        id: column
        visible: false
        width: 400
        spacing: 30
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: no_Trips_Text
            text: "No Trips to display"
            color: StyleSheet.regular_Text
            font.family: FontsManager.systemFont_Medium.name
            font.pixelSize: 28
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 0
            anchors.rightMargin: 0
        }

        Text {
            id: no_Trips_Description
            text: "You can customize the Trip display \n\nGo to Vehicle Settings > Display Setup > Trips"
            color: StyleSheet.special_Text
            font.family: FontsManager.systemFont_Medium.name
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.leftMargin: 0
        }
    }



    DropShadow {
        anchors.fill: column
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 14
        color: "#40000000"
        source: column
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
