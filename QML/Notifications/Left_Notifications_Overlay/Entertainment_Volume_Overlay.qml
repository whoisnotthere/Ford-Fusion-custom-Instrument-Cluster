import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    function update_Media_Volume() {
        let volume = NOW_PLAYING.return_Volume;

        volume_Slider.value = volume;
        volume_Value.text = volume;
    }



    Item {
        id: overlay_Item
        width: 380
        height: 140
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: overlay_Background
            visible: false
            color: StyleSheet.overlay_Background_Regular
            radius: 20
            anchors.fill: parent
        }

        DropShadow {
            id: overlay_Background_Shadow
            visible: true
            source: overlay_Background
            horizontalOffset: 0
            verticalOffset: 0
            radius: 12
            color: StyleSheet.overlay_Shadow
            smooth: true
            anchors.fill: parent
        }

        Text {
            id: overlay_Name
            color: StyleSheet.special_Text
            text: "Entertainment"
            anchors.bottom: parent.bottom
            font.pixelSize: 24
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }

        Slider {
            id: volume_Slider
            width: 6
            from: 0.0
            to: 30.0
            value: 0.0
            orientation: Qt.Vertical

            background: Rectangle {
                x: volume_Slider.leftPadding + volume_Slider.availableWidth / 2 - width / 2
                y: volume_Slider.topPadding
                implicitWidth: volume_Slider.width
                implicitHeight: volume_Slider.height
                width: implicitWidth
                height: volume_Slider.availableHeight
                color: StyleSheet.progress_Completed

                Rectangle {
                    width: parent.width
                    height: volume_Slider.visualPosition * parent.height
                    color: StyleSheet.progress_Background
                }
            }

            handle: Rectangle {
                x: volume_Slider.leftPadding + volume_Slider.availableWidth / 2 - width / 2
                y: volume_Slider.topPadding + volume_Slider.visualPosition * (volume_Slider.availableHeight - height)
                implicitWidth: 14
                implicitHeight: 4
                color: StyleSheet.progress_Completed
            }
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 40
            anchors.topMargin: -6
            anchors.bottomMargin: -6
        }

        Image {
            id: overlay_Icon
            asynchronous: true
            mipmap: true
            width: 60
            height: 60
            source: "qrc:/icons/notification_Overlay/volume.svg"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 27
        }

        ColorOverlay {
            source: overlay_Icon
            color: StyleSheet.overlay_Icon
            anchors.fill: overlay_Icon
        }

        Text {
            id: volume_Value
            color: "white"
            text: "0"
            anchors.top: parent.top
            font.pixelSize: 60
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.monospacedFont_Medium.name
        }
    }



    Component.onCompleted: {
        update_Media_Volume();
    }



    Connections {
        target: NOW_PLAYING

        function onVolume_Changed() {
            update_Media_Volume();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
