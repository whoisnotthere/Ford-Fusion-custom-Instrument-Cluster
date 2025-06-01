import QtQuick
import Qt5Compat.GraphicalEffects
import "../../"

Item {
    id: item_Delegate
    property bool is_Current_Item: PathView.isCurrentItem

    height: 40
    width: 300
    opacity: is_Current_Item ? 1 : 0.5

    Text {
        id: text
        width: 250
        height: 40
        text: quick_Name
        font.pixelSize: 28
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.family: FontsManager.systemFont_Medium.name
        color: "white"
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    Image {
        id: image
        width: 40
        height: 40
        source: quick_Icon
        asynchronous: true
        mipmap: true
        fillMode: Image.PreserveAspectFit
        anchors.right: text.left
        anchors.rightMargin: 15
    }

    ColorOverlay {
        source: image
        color: "white"
        anchors.fill: image
    }
}
