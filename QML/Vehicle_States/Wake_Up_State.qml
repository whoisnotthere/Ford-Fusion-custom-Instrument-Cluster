import QtQuick

import "../Info_Cards_Wheels"
import "../Quick_Actions"
import "../Notifications"
import "../Notifications/Left_Notifications_Overlay"
import "../Overlays"
import "../Overlays/Debug_Mode"

Item {
    id: wake_Up_State_Item
    width: 1920
    height: 720

    function update_Ignition_State() {
        let ignition_State = VEHICLE_STATES.get_Ignition_State;

        if (ignition_State) {
            if (car_On_State.opacity != 1.0) {
                ignition_Off.stop();
                ignition_On.start();
            }
        }
        else {
            if (car_Off_State.opacity != 1.0) {
                ignition_On.stop();
                ignition_Off.start();
            }
        }
    }

    function update_DebugMode_State() {
        let debugMode_State = VEHICLE_STATES.get_DebugMode_State;

        debug_Mode_Title.visible = debugMode_State;
    }

    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            background_Placeholder.source = "qrc:/images/background/default/day.png";
        }
        else if (dayNight_State === "night") {
            background_Placeholder.source = "qrc:/images/background/default/night.png";
        }
    }



    Image {
        id: background_Placeholder
        opacity: 1.0
        source: "qrc:/images/background/default/day.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Car_On_State {
        id: car_On_State
        opacity: 0.0
        anchors.fill: parent
    }

    Car_Off_State {
        id: car_Off_State
        opacity: 1.0
        anchors.fill: parent
    }

    Left_Cards_Wheel {
        id: left_Cards_Wheel
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Right_Cards_Wheel {
        id: right_Cards_Wheel
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    Down_Right_Info {
        id: down_Right_Info
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 50
    }

    Quick_Access_Wheel {
        id: quick_Access_Wheel
        height: 720
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    Left_Overlay_Loader {
        id: left_Overlay_Loader
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Alerts_Overlay {
        id: alerts_Overlay
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Left_Warning_Lights {
        id: left_Warning_Lights
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.leftMargin: 50
    }

    Right_Warning_Lights {
        id: right_Warning_Lights
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.rightMargin: 50
    }

    Debug_Mode_Title {
        id: debug_Mode_Title
        visible: false
        anchors.fill: parent
    }



    ParallelAnimation {
        id: ignition_On
        NumberAnimation {target: car_Off_State; property: "opacity"; from: 1.0; to: 0.0; duration: 350}
        NumberAnimation {target: car_On_State; property: "opacity"; from: 0.0; to: 1.0; duration: 350}
    }

    ParallelAnimation {
        id: ignition_Off
        NumberAnimation {target: car_On_State; property: "opacity"; from: 1.0; to: 0.0; duration: 350}
        NumberAnimation {target: car_Off_State; property: "opacity"; from: 0.0; to: 1.0; duration: 350}
    }



    Component.onCompleted: {
        update_Ignition_State();
        update_DebugMode_State();
        update_DayNight_Mode();
    }



    Connections {
        target: VEHICLE_STATES

        function onIgnition_State_Changed() {
            update_Ignition_State();
        }

        function onDebugMode_State_Changed() {
            update_DebugMode_State();
        }
    }

    Connections {
        target: APPEARANCE

        function onDayNight_Mode_Changed() {
            update_DayNight_Mode();
        }
    }
}
