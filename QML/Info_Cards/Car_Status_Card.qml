import QtQuick
//IMPORT car components
import "../Vehicle_Model"
//IMPORT StyleSheet, FontsManager
import "../"

Item {
    id: item1
    width: 660
    height: 720

    function update_Pressure_Unit() {
        let pressure_Unit = TPMS.get_Pressure_Unit;

        if (pressure_Unit === "bar") {
            front_Left_Unit.text = "bar";
            front_Right_Unit.text = "bar";
            rear_Left_Unit.text = "bar";
            rear_Right_Unit.text = "bar";

        }
        else if (pressure_Unit === "kPa") {
            front_Left_Unit.text = "kPa";
            front_Right_Unit.text = "kPa";
            rear_Left_Unit.text = "kPa";
            rear_Right_Unit.text = "kPa";

        }
        else if (pressure_Unit === "psi") {
            front_Left_Unit.text = "psi";
            front_Right_Unit.text = "psi";
            rear_Left_Unit.text = "psi";
            rear_Right_Unit.text = "psi";

        }
    }

    function update_Pressure_Value(tire_Location = "all") {
        let pressure_Unit = TPMS.get_Pressure_Unit;
        let decimals_Divider = 0;

        if (pressure_Unit === "bar") {
            decimals_Divider = 2;
        }
        else {
            decimals_Divider = 0;
        }

        //FRONT LEFT TIRE
        if (tire_Location === "front_Left" || tire_Location === "all") {
            let FL_Pressure = TPMS.get_FL_Display_Pressure;

            front_Left_Pressure.text = FL_Pressure.toFixed(decimals_Divider);
        }

        //FRONT RIGHT TIRE
        if (tire_Location === "front_Right" || tire_Location === "all") {
            let FR_Pressure = TPMS.get_FR_Display_Pressure;

            front_Right_Pressure.text = FR_Pressure.toFixed(decimals_Divider);
        }

        //REAR LEFT TIRE
        if (tire_Location === "rear_Left" || tire_Location === "all") {
            let RL_Pressure = TPMS.get_RL_Display_Pressure;

            rear_Left_Pressure.text = RL_Pressure.toFixed(decimals_Divider);
        }

        //REAR RIGHT TIRE
        if (tire_Location === "rear_Right" || tire_Location === "all") {
            let RR_Pressure = TPMS.get_RR_Display_Pressure;

            rear_Right_Pressure.text = RR_Pressure.toFixed(decimals_Divider);
        }
    }

    function update_Pressure_State(tire_Location = "all") {
        //FRONT LEFT TIRE
        if (tire_Location === "front_Left" || tire_Location === "all") {
            let FL_State = TPMS.get_FL_Display_State;

            if (FL_State === "ok") {
                front_Left_Pressure.color = StyleSheet.regular_Text;
            }
            if (FL_State === "low") {
                front_Left_Pressure.color = "gold";
            }
            if (FL_State === "critical") {
                front_Left_Pressure.color = "red";
            }
            if (FL_State === "not_Actual") {
                front_Left_Pressure.color = StyleSheet.regular_Text;
                front_Left_Pressure.text = "-";
            }
        }

        //FRONT RIGHT TIRE
        if (tire_Location === "front_Right" || tire_Location === "all") {
            let FR_State = TPMS.get_FR_Display_State;

            if (FR_State === "ok") {
                front_Right_Pressure.color = StyleSheet.regular_Text;
            }
            if (FR_State === "low") {
                front_Right_Pressure.color = "gold";
            }
            if (FR_State === "critical") {
                front_Right_Pressure.color = "red";
            }
            if (FR_State === "not_Actual") {
                front_Right_Pressure.color = StyleSheet.regular_Text;
                front_Right_Pressure.text = "-";
            }
        }

        //REAR LEFT TIRE
        if (tire_Location === "rear_Left" || tire_Location === "all") {
            let RL_State = TPMS.get_RL_Display_State;

            if (RL_State === "ok") {
                rear_Left_Pressure.color = StyleSheet.regular_Text;
            }
            if (RL_State === "low") {
                rear_Left_Pressure.color = "gold";
            }
            if (RL_State === "critical") {
                rear_Left_Pressure.color = "red";
            }
            if (RL_State === "not_Actual") {
                rear_Left_Pressure.color = StyleSheet.regular_Text;
                rear_Left_Pressure.text = "-";
            }
        }

        //REAR RIGHT TIRE
        if (tire_Location === "rear_Right" || tire_Location === "all") {
            let RR_State = TPMS.get_RR_Display_State;

            if (RR_State === "ok") {
                rear_Right_Pressure.color = StyleSheet.regular_Text;
            }
            if (RR_State === "low") {
                rear_Right_Pressure.color = "gold";
            }
            if (RR_State === "critical") {
                rear_Right_Pressure.color = "red";
            }
            if (RR_State === "not_Actual") {
                rear_Right_Pressure.color = StyleSheet.regular_Text;
                rear_Right_Pressure.text = "-";
            }
        }
    }



    Top_View_Model {
        id: top_View_Model
    }



    Column {
        id: front_Left
        width: 120
        height: 80
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 140
        anchors.topMargin: 200

        Text {
            id: front_Left_Pressure
            color: StyleSheet.regular_Text
            text: "-"
            font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.monospacedFont_Medium.name
        }

        Text {
            id: front_Left_Unit
            color: StyleSheet.special_Text
            text: "kpa"
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }
    }



    Column {
        id: front_Right
        width: 120
        height: 80
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 200
        anchors.rightMargin: 140

        Text {
            id: front_Right_Pressure
            color: StyleSheet.regular_Text
            text: "-"
            font.pixelSize: 28
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.monospacedFont_Medium.name
        }

        Text {
            id: front_Right_Unit
            color: StyleSheet.special_Text
            text: "kpa"
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }
    }



    Column {
        id: rear_Left
        width: 120
        height: 80
        anchors.left: parent.left
        anchors.top: parent.top

        Text {
            id: rear_Left_Pressure
            color: StyleSheet.regular_Text
            text: "-"
            font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.monospacedFont_Medium.name
        }

        Text {
            id: rear_Left_Unit
            color: StyleSheet.special_Text
            text: "kpa"
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }
        anchors.leftMargin: 140
        anchors.topMargin: 450
    }



    Column {
        id: rear_Right
        width: 120
        height: 80
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 140

        Text {
            id: rear_Right_Pressure
            color: StyleSheet.regular_Text
            text: "-"
            font.pixelSize: 30
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.monospacedFont_Medium.name
        }

        Text {
            id: rear_Right_Unit
            color: StyleSheet.special_Text
            text: "kpa"
            font.pixelSize: 22
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: FontsManager.systemFont_Medium.name
        }
        anchors.topMargin: 450
    }



    Component.onCompleted: {
        update_Pressure_Unit();
        update_Pressure_Value();
        update_Pressure_State();
    }

    Connections {
        target: TPMS

        //PRESSURE UNIT
        function onPressure_Unit_Changed() {
            update_Pressure_Unit();
        }

        //PRESSURE VALUES
        function onFl_Pressure_Changed() {
            update_Pressure_Value("front_Left");
        }

        function onFr_Pressure_Changed() {
            update_Pressure_Value("front_Right");
        }

        function onRl_Pressure_Changed() {
            update_Pressure_Value("rear_Left");
        }

        function onRr_Pressure_Changed() {
            update_Pressure_Value("rear_Right");
        }

        //PRESSURE STATES
        function onFl_Pressure_State_Changed() {
            update_Pressure_State("front_Left");
        }

        function onFr_Pressure_State_Changed() {
            update_Pressure_State("front_Right");
        }

        function onRl_Pressure_State_Changed() {
            update_Pressure_State("rear_Left");
        }

        function onRr_Pressure_State_Changed() {
            update_Pressure_State("rear_Right");
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}D{i:1}D{i:6}D{i:9}D{i:12}
}
##^##*/
