import QtQuick

//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 90
    height: 60

    function update_Cruise_State() {
        let state = POWERTRAIN.get_Cruise_State;

        //CRUISE ICON
        if (state === "on_Active" || state === "on_Inactive") {
            cruise_Icon.source = "qrc:/images/speedometer/cruise/cruise_Active.png";
        }
        else {
            cruise_Icon.source = "qrc:/images/speedometer/cruise/cruise_Inactive.png";
        }

        //CRUISE SPEED
        if (state === "on_NotSet") {
            cruise_Speed.visible = false;
        }
        else {
            cruise_Speed.visible = true;

            if (state === "on_Active") {
                cruise_Speed.color = StyleSheet.cruise_Active;
                cruise_Speed.font.strikeout = false;
            }
            else {
                cruise_Speed.color = StyleSheet.cruise_Inactive;

                if (state === "on_Disabled") {
                    cruise_Speed.font.strikeout = true;
                }
                else {
                    cruise_Speed.font.strikeout = false;
                }
            }
        }
    }

    function update_Cruise_Speed() {
        let speed = POWERTRAIN.get_Cruise_Speed;
        let speed_Unit = POWERTRAIN.get_Speed_Unit;

        if (speed_Unit === "kph") {
            cruise_Speed.text = speed + " km/h";
        }
        else if (speed_Unit === "mph") {
            cruise_Speed.text = speed + " mph";
        }
    }

    Image {
        id: cruise_Icon
        width: 90
        height: 30
        asynchronous: true
        source: "qrc:/images/speedometer/cruise/cruise_Active.png"
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: cruise_Speed
        text: "0 km/h"
        color: StyleSheet.cruise_Active
        font.family: FontsManager.monospacedFont_Medium.name
        anchors.top: cruise_Icon.bottom
        font.pixelSize: 22
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: {
        update_Cruise_State();
        update_Cruise_Speed();
    }

    Connections {
        target: POWERTRAIN

        function onCruise_State_Changed() {
            update_Cruise_State();
        }

        function onCruise_Speed_Changed() {
            update_Cruise_Speed();
        }

        function onSpeed_Unit_Changed() {
            update_Cruise_Speed();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:3}
}
##^##*/
