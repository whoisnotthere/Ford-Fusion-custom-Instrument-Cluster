import QtQuick

import "../Overlays"
import "../Overlays/Blinkers/v2"
//IMPORT Driving visualization
import "../Driving_Visualization/pre-AP"

Item {
    id: car_On_State_Item
    width: 1920
    height: 720

    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            background.source = "qrc:/images/background/pre-AP/driving_Day.png";
        }
        else if (dayNight_State === "night") {
            background.source = "qrc:/images/background/pre-AP/driving_Night.png";
        }
    }



    Image {
        id: background
        opacity: 1.0
        source: "qrc:/images/background/pre-AP/driving_Day.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Down_Left_Info {
        id: down_Left_Info
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 50
        anchors.bottomMargin: 0
    }

    Left_Blinker {
        id: left_Blinker
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: speedometer.left
        anchors.rightMargin: -30
    }

    Right_Blinker {
        id: right_Blinker
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: speedometer.right
        anchors.leftMargin: -30
    }

    Speedometer {
        id: speedometer
        width: 650
        height: 650
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }



    Component.onCompleted: {
        update_DayNight_Mode();
    }



    Connections {
        target: APPEARANCE

        function onDayNight_Mode_Changed() {
            update_DayNight_Mode();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
