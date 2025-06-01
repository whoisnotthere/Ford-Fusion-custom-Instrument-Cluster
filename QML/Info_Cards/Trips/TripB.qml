import QtQuick
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    width: 440
    height: 110
    anchors.horizontalCenter: parent.horizontalCenter

    function seconds_To_String(timestamp) {
        //https://stackoverflow.com/a/34841026/11121211
        let sec_num = parseInt(timestamp, 10)
        let hours   = Math.floor(sec_num / 3600)
        let minutes = Math.floor(sec_num / 60) % 60
        let seconds = sec_num % 60

        return [hours,minutes,seconds].map(v => v < 10 ? "0" + v : v).filter((v,i) => v !== "00" || i > 0).join(":")
    }

    function update_Time_Name(timestamp) {
        if (timestamp >= 3600) {
            return "hours";
        }
        else if (timestamp >= 60) {
            return "minutes";
        }
        else if (timestamp < 60) {
            return "seconds";
        }
    }

    function update_Trip_Data() {
        let distance = TRIPS.return_TripB_Distance.toFixed(1);
        trip_Distance_Value.text = String(distance).replace(/(\d)(?=(\d{3})+([^\d]|$))/g, '$1,');

        let time = TRIPS.return_TripB_Time;
        trip_Time_Value.text = seconds_To_String(time);
        trip_Time_Unit.text = update_Time_Name(time);

        trip_Consumption_Value.text = TRIPS.return_TripB_Efficiency.toFixed(1);
    }

    function update_Distance_Unit() {
        let unit = TRIPS.get_Distance_Unit;

        if (unit === "kilometers") {
            trip_Distance_Unit.text = "km";
        }
        else if (unit === "miles") {
            trip_Distance_Unit.text = "mi";
        }
    }

    function update_Fuel_Unit() {
        let fuel_Unit = TRIPS.get_Fuel_Unit;

        if (fuel_Unit === "L/100km") {
            trip_Consumption_Unit.text = "L/100 km";
        }
        else if (fuel_Unit === "MPG") {
            trip_Consumption_Unit.text = "MPG";
        }
        else if (fuel_Unit === "km/L") {
            trip_Consumption_Unit.text = "km/L";
        }
    }



    Item {
        id: separator
        height: 25
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0

        Text {
            id: trip_Name
            color: StyleSheet.special_Text
            text: "Trip B"
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }

        Rectangle {
            id: separator_Left_Rectangle
            opacity: 0.3
            height: 2
            color: StyleSheet.separator
            radius: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.right: trip_Name.left
            anchors.rightMargin: 10
            anchors.leftMargin: 0
        }

        Rectangle {
            id: separator_Right_Rectangle
            opacity: 0.3
            height: 2
            color: StyleSheet.separator
            radius: 1
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: trip_Name.right
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.leftMargin: 10
        }
    }

    Item {
        id: trip_Distance_Item
        width: 130
        height: 70
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.leftMargin: 0

        Text {
            id: trip_Distance_Value
            color: StyleSheet.regular_Text
            text: "0.0"
            font.pixelSize: 28
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.monospacedFont_Medium.name
        }

        Text {
            id: trip_Distance_Unit
            color: StyleSheet.special_Text
            text: "km"
            anchors.top: trip_Distance_Value.bottom
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
            anchors.topMargin: 0
        }
    }

    Item {
        id: trip_Time_Item
        width: 130
        height: 70
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0

        Text {
            id: trip_Time_Value
            color: StyleSheet.regular_Text
            text: "00:00"
            font.pixelSize: 28
            font.family: FontsManager.monospacedFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: trip_Time_Unit
            color: StyleSheet.special_Text
            text: "seconds"
            anchors.top: trip_Time_Value.bottom
            font.pixelSize: 22
            font.family: FontsManager.systemFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 0
        }
    }

    Item {
        id: trip_Consumption_Item
        width: 130
        height: 70
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 0

        Text {
            id: trip_Consumption_Value
            color: StyleSheet.regular_Text
            text: "0.0"
            font.pixelSize: 28
            font.family: FontsManager.monospacedFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: trip_Consumption_Unit
            color: StyleSheet.special_Text
            text: "L/100km"
            anchors.top: trip_Consumption_Value.bottom
            font.pixelSize: 22
            font.family: FontsManager.systemFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 0
        }
    }



    Component.onCompleted: {
        update_Trip_Data();
        update_Distance_Unit();
        update_Fuel_Unit();
    }



    Connections {
        target: TRIPS
        function onTripB_Data_Changed() {
            update_Trip_Data();
        }

        function onDistance_Unit_Changed() {
            update_Distance_Unit();
        }

        function onFuel_Unit_Changed() {
            update_Fuel_Unit();
        }
    }
}
