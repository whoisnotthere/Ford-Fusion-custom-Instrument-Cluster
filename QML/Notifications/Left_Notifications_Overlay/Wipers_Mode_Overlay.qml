import QtQuick
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    Item {
        id: overlay_Item
        width: 120
        height: 440
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

        Column {
            id: column
            spacing: 40
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                id: wipers_High_Speed_Label_Item
                width: 60
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: wipers_High_Speed_Label
                    color: "#656565"
                    text: "HI"
                    font.pixelSize: 34
                    font.family: FontsManager.systemFont_Medium.name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item {
                id: wipers_Normal_Speed_Label_Item
                width: 60
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: wipers_Normal_Speed_Label
                    color: "#656565"
                    text: "LO"
                    font.pixelSize: 34
                    font.family: FontsManager.systemFont_Medium.name
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Item {
                id: auto_Wipers_Icon_Item
                width: 60
                height: 60
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: auto_Wipers_Icon
                    visible: false
                    mipmap: true
                    asynchronous: true
                    source: "qrc:/icons/notification_Overlay/wipers_Auto.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                ColorOverlay {
                    source: auto_Wipers_Icon
                    color: "#ffffff"
                    anchors.fill: auto_Wipers_Icon
                }
            }

            Item {
                id: wipers_Off_Icon_Item
                width: 45
                height: 45
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: wipers_Off_Icon
                    visible: false
                    mipmap: true
                    asynchronous: true
                    source: "qrc:/icons/notification_Overlay/wipers_Off.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                ColorOverlay {
                    source: wipers_Off_Icon
                    color: "#656565"
                    anchors.fill: wipers_Off_Icon
                }
            }
        }

        Text {
            id: overlay_Name
            color: StyleSheet.special_Text
            text: "Wipers"
            anchors.bottom: parent.bottom
            font.pixelSize: 24
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }
    }
}
