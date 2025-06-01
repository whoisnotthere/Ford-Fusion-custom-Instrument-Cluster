import QtQuick
import QtQuick.Controls
//IMPORT StyleSheet, FontsManager
import "../"

Item {
    id: clock
    width: 660
    height: 720

    property int hours
    property int minutes
    property int seconds

    function update_Global_Time_Value() {
        let global_Time = VEHICLE_DATA.get_Global_Time;

        let date_Object = new Date(global_Time * 1000);
        hours = date_Object.getHours();
        minutes = date_Object.getMinutes();
        seconds = date_Object.getSeconds();

        clock_Date.text = date_Object.getDate() + "-" + (date_Object.getMonth() + 1) + "-" + date_Object.getFullYear();
    }

    Text {
        id: hours_9
        color: StyleSheet.special_Text
        text: "9"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: clock_Background.left
        font.pixelSize: 22
        anchors.rightMargin: 10
        font.family: FontsManager.systemFont_Medium.name
    }

    Text {
        id: hours_6
        color: StyleSheet.special_Text
        text: "6"
        anchors.top: clock_Background.bottom
        font.pixelSize: 22
        anchors.topMargin: 10
        font.family: FontsManager.systemFont_Medium.name
        anchors.horizontalCenter: parent.horizontalCenter
    }


    Text {
        id: hours_3
        color: StyleSheet.special_Text
        text: "3"
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: clock_Background.right
        font.pixelSize: 22
        anchors.leftMargin: 10
        font.family: FontsManager.systemFont_Medium.name
    }

    Text {
        id: hours_12
        text: "12"
        color: StyleSheet.special_Text
        font.family: FontsManager.systemFont_Medium.name
        font.pixelSize: 22
        anchors.bottom: clock_Background.top
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: clock_Background
        asynchronous: true
        source: "qrc:/images/analog_Clock/clock_Background.png"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: clock_Date
            text: "--/--/----"
            color: StyleSheet.special_Text
            font.family: FontsManager.systemFont_Medium.name
            anchors.bottom: parent.bottom
            font.pixelSize: 22
            anchors.bottomMargin: 75
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Item {
        id: minute_Pointer_Item
        width: 5
        height: 360
        rotation: clock.minutes * 6
        opacity: 0.8
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: minute_Pointer
            color: StyleSheet.clock_Needle_Minutes
            antialiasing: true
            radius: 2.5
            anchors.fill: parent
            anchors.topMargin: 40
            anchors.bottomMargin: 180
        }
    }

    Item {
        id: hour_Pointer_Item
        width: 8
        height: 360
        rotation: clock.hours * 30
        opacity: 0.8
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: hour_Pointer
            color: StyleSheet.clock_Needle_Hours
            antialiasing: true
            radius: 4
            anchors.fill: parent
            anchors.topMargin: 70
            anchors.bottomMargin: 180
        }
    }

    Item {
        id: second_Pointer_Item
        width: 3
        height: 360
        rotation: clock.seconds * 6
        opacity: 1.0
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            id: second_Pointer
            color: StyleSheet.clock_Needle_Seconds
            antialiasing: true
            radius: 2.5
            anchors.fill: parent
            anchors.bottomMargin: 180
            anchors.topMargin: 30
        }
    }

    Rectangle {
        id: clock_Core
        width: 15
        height: 15
        radius: 50
        color: StyleSheet.clock_Core
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Component.onCompleted: {
        update_Global_Time_Value();
    }

    Connections {
        target: VEHICLE_DATA

        function onGlobal_Time_Changed() {
            update_Global_Time_Value();
        }
    }
}
