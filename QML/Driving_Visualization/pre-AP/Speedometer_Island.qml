import QtQuick

//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 330
    height: 330

    function update_Cruise_State() {
        let state = POWERTRAIN.get_Cruise_State;

        if (state === "off") {
            cruise_Island.visible = false;
            vehicle_Speed_Item.anchors.topMargin = 30;
        }
        else {
            vehicle_Speed_Item.anchors.topMargin = 55;
            cruise_Island.visible = true;
        }
    }

    function update_Speed_Value() {
        vehicle_Speed_Value.value = POWERTRAIN.get_Vehicle_Speed_Value;
    }

    function update_Speed_Unit() {
        let speed_Unit = POWERTRAIN.get_Speed_Unit;

        if (speed_Unit === "kph") {
            vehicle_Speed_Unit.text = "km/h"
        }
        else if (speed_Unit === "mph") {
            vehicle_Speed_Unit.text = "mph"
        }
    }

    Item {
        id: island_Body
        width: 330
        height: 330
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: island_Background
            asynchronous: true
            source: AssetsManager.speedometer_Frame
            anchors.fill: parent
        }

        Cruise_Island {
            id: cruise_Island
            visible: true
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: vehicle_Speed_Item
            width: 160
            height: 100
            anchors.top: parent.top
            anchors.topMargin: 55
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                property int value: 0
                id: vehicle_Speed_Value
                width: 160
                height: 70
                color: StyleSheet.speedometer_DigitalValue
                text: value
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 98
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.topMargin: 0
                font.family: FontsManager.monospacedFont_Regular.name

                Behavior on value {
                    NumberAnimation {
                        duration: 250
                    }
                }
            }

            Text {
                id: vehicle_Speed_Unit
                color: StyleSheet.speedometer_Unit
                text: "km/h"
                anchors.top: vehicle_Speed_Value.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.topMargin: 5
                antialiasing: true
                font.family: FontsManager.systemFont_Medium.name
            }
        }
    }



    Component.onCompleted: {
        update_Cruise_State();
        update_Speed_Value();
        update_Speed_Unit();
    }



    Connections {
        target: POWERTRAIN
        function onCruise_State_Changed() {
            update_Cruise_State();
        }

        function onVehicle_Speed_Changed() {
            update_Speed_Value();
        }

        function onSpeed_Unit_Changed() {
            update_Speed_Unit();
        }
    }
}


