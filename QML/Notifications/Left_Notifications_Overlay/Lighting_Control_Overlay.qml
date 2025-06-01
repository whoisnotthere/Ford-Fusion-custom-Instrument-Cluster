import QtQuick
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    function update_Light_Switch_State() {
        let switch_State = VEHICLE_FEATURES.get_Light_Switch_State;

        if (switch_State === "off") {
            light_Off_Icon_Color.color = "#ffffff";
            parking_Lights_Icon_Color.color = "#656565";
            low_Beam_Icon_Color.color = "#656565";
            auto_Light_Icon_Color.color = "#656565";

        }
        else if (switch_State === "parking_Lights") {
            light_Off_Icon_Color.color = "#656565";
            parking_Lights_Icon_Color.color = "#ffffff";
            low_Beam_Icon_Color.color = "#656565";
            auto_Light_Icon_Color.color = "#656565";

        }
        else if (switch_State === "low_Beam") {
            light_Off_Icon_Color.color = "#656565";
            parking_Lights_Icon_Color.color = "#656565";
            low_Beam_Icon_Color.color = "#ffffff";
            auto_Light_Icon_Color.color = "#656565";

        }
        else if (switch_State === "auto") {
            light_Off_Icon_Color.color = "#656565";
            parking_Lights_Icon_Color.color = "#656565";
            low_Beam_Icon_Color.color = "#656565";
            auto_Light_Icon_Color.color = "#ffffff";

        }
        else {
            light_Off_Icon_Color.color = "#656565";
            parking_Lights_Icon_Color.color = "#656565";
            low_Beam_Icon_Color.color = "#656565";
            auto_Light_Icon_Color.color = "#656565";

        }
    }



    Item {
        id: overlay_Item
        width: 400
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

        Row {
            id: row
            spacing: 40
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                id: light_Off_Icon_Item
                width: 45
                height: 45
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: light_Off_Icon
                    visible: false
                    mipmap: true
                    asynchronous: true
                    source: "qrc:/icons/notification_Overlay/light_Off.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                ColorOverlay {
                    id: light_Off_Icon_Color
                    source: light_Off_Icon
                    color: "#656565"
                    anchors.fill: light_Off_Icon
                }
            }

            Item {
                id: parking_Lights_Icon_Item
                width: 55
                height: 55
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: parking_Lights_Icon
                    visible: false
                    mipmap: true
                    asynchronous: true
                    source: "qrc:/icons/notification_Overlay/parking_Lights.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                ColorOverlay {
                    id: parking_Lights_Icon_Color
                    source: parking_Lights_Icon
                    color: "#656565"
                    anchors.fill: parking_Lights_Icon
                }
            }

            Item {
                id: low_Beam_Icon_Item
                width: 55
                height: 55
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: low_Beam_Icon
                    visible: false
                    mipmap: true
                    asynchronous: true
                    source: "qrc:/icons/notification_Overlay/low_Beam.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                ColorOverlay {
                    id: low_Beam_Icon_Color
                    source: low_Beam_Icon
                    color: "#656565"
                    anchors.fill: low_Beam_Icon
                }
            }

            Item {
                id: auto_Light_Icon_Item
                width: 60
                height: 60
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: auto_Light_Icon
                    visible: false
                    mipmap: true
                    asynchronous: true
                    source: "qrc:/icons/notification_Overlay/auto_Light.svg"
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                }

                ColorOverlay {
                    id: auto_Light_Icon_Color
                    source: auto_Light_Icon
                    color: "#656565"
                    anchors.fill: auto_Light_Icon
                }
            }
        }

        Text {
            id: overlay_Name
            color: StyleSheet.special_Text
            text: "Lighting"
            anchors.bottom: parent.bottom
            font.pixelSize: 24
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }
    }



    Component.onCompleted: {
        update_Light_Switch_State();
    }



    Connections {
        target: VEHICLE_FEATURES

        function onLight_Switch_State_Changed() {
            update_Light_Switch_State();
        }
    }
}
