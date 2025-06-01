import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    property color light_Color: "black"
    property url light_Icon: ""

    Image {
        id: light_Image
        asynchronous: true
        visible: false
        mipmap: true
        source: light_Icon
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    ColorOverlay {
        id: doorOpen_Light_Overlay
        source: light_Image
        color: light_Color
        anchors.fill: light_Image
    }
}
