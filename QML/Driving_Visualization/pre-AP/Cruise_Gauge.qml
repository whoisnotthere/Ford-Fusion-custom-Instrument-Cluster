import QtQuick
import Qt5Compat.GraphicalEffects

//IMPORT gauge components
import "../../Components"
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    width: 650
    height: 650

    function update_Cruise_State() {
        let state = POWERTRAIN.get_Cruise_State;

        if (state === "off" || state === "on_NotSet") {
            cruise_Gauge.visible = false;
        }
        else {
            cruise_Gauge.visible = true;
        }
    }

    function update_Cruise_Speed() {
        let cruise_Speed = POWERTRAIN.get_Cruise_Speed;

        cruise_Gauge.setValue = cruise_Speed;
    }

    Gauge {
        id: cruise_Gauge
        anchors.fill: parent
        opacity: 1.0
        maximumValue: 260

        minimumValueAngle: -150
        maximumValueAngle: 149

        needle: Image {
            y: -264
            asynchronous: true
            source: "qrc:/images/speedometer/cruise/cruise_Needle.png"
            fillMode: Image.PreserveAspectFit
        }
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
