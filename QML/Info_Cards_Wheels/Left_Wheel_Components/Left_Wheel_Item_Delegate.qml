import QtQuick
import Qt5Compat.GraphicalEffects
import "../../"

Item {
    id: item_Delegate

    property bool is_Current_Item: PathView.isCurrentItem

    height: 200
    width: 200
    opacity: is_Current_Item ? 1 : 0.5

    Image {
        id: card_Icon
        asynchronous: true
        height: 100
        anchors.verticalCenter: parent.verticalCenter
        width: 100
        source: card_Image
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }

    Text {
        id: card_Name_Text
        text: card_Name
        anchors.top: card_Icon.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 28
        anchors.topMargin: 10
        font.family: FontsManager.systemFont_Medium.name
        color: StyleSheet.pathView_Text_Regular
        visible: is_Current_Item ? true : false
    }

    ColorOverlay {
        source: card_Icon
        color: StyleSheet.pathView_Icon_Regular
        anchors.fill: card_Icon
    }
}
