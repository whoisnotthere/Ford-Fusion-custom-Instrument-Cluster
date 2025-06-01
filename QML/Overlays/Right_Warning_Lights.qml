import QtQuick
import "../Components"

Item {
    id: item1
    width: 650
    height: 80

    function update_CoolantOverheated_Light() {
        coolant_Overheated_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Coolant_Overheated_Light_State ? 1.0 : 0.0;
    }

    function update_Oil_Pressure_Low_Light() {
        oil_Pressure_Low_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Oil_Pressure_Low_Light_State ? 1.0 : 0.0;
    }

    function update_Electric_Parking_Brake_Light() {
        electric_Parking_Brake_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Electric_Parking_Brake_Light_State ? 1.0 : 0.0;
    }

    function update_Parking_Brake_Light() {
        parking_Brake_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Parking_Brake_Light_State ? 1.0 : 0.0;
    }

    function update_ABS_Light() {
        abs_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_ABS_Light_State ? 1.0 : 0.0;
    }

    function update_Check_Engine_Light() {
        check_Engine_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Check_Engine_Light_State ? 1.0 : 0.0;
    }

    function update_Stability_Control_Light() {
        stability_Control_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Stability_Control_Light_State ? 1.0 : 0.0;
    }

    function update_Stability_Control_Off_Light() {
        stability_Control_Off_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Stability_Control_Off_Light_State ? 1.0 : 0.0;
    }

    function update_TPMS_Light() {
        tpms_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_TPMS_Light_State ? 1.0 : 0.0;
    }



    Row {
        id: row
        layoutDirection: Qt.RightToLeft
        spacing: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        //Since the layoutDirection is from right to left, the elements position in the row are reversed

        Warning_Light {
            id: tpms_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/tpms_System.svg"
            light_Color: "gold"
        }

        Warning_Light {
            id: stability_Control_Off_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/stability_Control_Off.svg"
            light_Color: "gold"
        }

        Warning_Light {
            id: stability_Control_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/stability_Control.svg"
            light_Color: "gold"
        }

        Warning_Light {
            id: check_Engine_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/check_Engine.svg"
            light_Color: "gold"
        }

        Warning_Light {
            id: abs_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/abs_System.svg"
            light_Color: "gold"
        }

        Warning_Light {
            id: parking_Brake_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/parking_Brakes.svg"
            light_Color: "red"
        }

        Warning_Light {
            id: electric_Parking_Brake_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/electric_Parking_Brake.svg"
            light_Color: "gold"
        }

        Warning_Light {
            id: oil_Pressure_Low_Light
            width: 60
            height: 60
            light_Icon: "qrc:/icons/warning_Lights/oil_Level.svg"
            light_Color: "red"
        }

        Warning_Light {
            id: coolant_Overheated_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/coolant_Temperature.svg"
            light_Color: "red"
        }
    }



    Component.onCompleted: {
        update_CoolantOverheated_Light();
        update_Oil_Pressure_Low_Light();
        update_Electric_Parking_Brake_Light();
        update_Parking_Brake_Light();
        update_ABS_Light();
        update_Check_Engine_Light();
        update_Stability_Control_Light();
        update_Stability_Control_Off_Light();
        update_TPMS_Light();
    }

    Connections {
        target: INSTRUMENT_CLUSTER_LIGHTS
        function onCoolant_Overheated_Light_Changed() {
            update_CoolantOverheated_Light();
        }

        function onOil_Pressure_Low_Light_Changed() {
            update_Oil_Pressure_Low_Light();
        }

        function onElectric_Parking_Brake_Light_Changed() {
            update_Electric_Parking_Brake_Light();
        }

        function onParking_Brake_Light_Changed() {
            update_Parking_Brake_Light();
        }

        function onAbs_Light_Changed() {
            update_ABS_Light();
        }

        function onCheck_Engine_Light_Changed() {
            update_Check_Engine_Light();
        }

        function onStability_Control_Light_Changed() {
            update_Stability_Control_Light();
        }

        function onStability_Control_Off_Light_Changed() {
            update_Stability_Control_Off_Light();
        }

        function onTpms_Light_Changed() {
            update_TPMS_Light();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.66}
}
##^##*/
