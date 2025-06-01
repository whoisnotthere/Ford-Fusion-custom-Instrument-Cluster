import QtQuick

import "../Vehicle_Model"
import "../Overlays/Blinkers/v1"
//IMPORT StyleSheet, FontsManager
import "../"

Item {
    id: car_Off_State_Item
    width: 1920
    height: 720

    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            background.source = "qrc:/images/background/pre-AP/main_Day.png";
        }
        else if (dayNight_State === "night") {
            background.source = "qrc:/images/background/pre-AP/main_Night.png";
        }
    }

    function update_Vehicle_Name() {
        vehicle_Name.text = APPEARANCE.get_Vehicle_Name;
    }



    Image {
        id: background
        opacity: 1.0
        source: "qrc:/images/background/pre-AP/main_Day.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Main_View_Model {
        id: main_View_Model
        anchors.fill: parent
    }

    Text {
        id: vehicle_Name
        width: 600
        height: 40
        color: "white"
        text: "No car name"
        elide: Text.ElideRight
        anchors.top: parent.top
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: FontsManager.systemFont_Medium.name
    }

    Item {
        id: blinkers_Container
        width: 600
        height: 35
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Left_Blinker {
            id: left_Blinker
            anchors.left: parent.left
            anchors.leftMargin: 0
        }

        Right_Blinker {
            id: right_Blinker
            anchors.right: parent.right
            anchors.rightMargin: 0
        }
    }



    Component.onCompleted: {
        update_DayNight_Mode();
        update_Vehicle_Name();
    }



    Connections {
        target: APPEARANCE

        function onDayNight_Mode_Changed() {
            update_DayNight_Mode();
        }

        function onVehicle_Name_Changed() {
            update_Vehicle_Name();
        }
    }
}
