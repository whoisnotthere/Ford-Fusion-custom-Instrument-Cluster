import QtQuick
import "../Components"

Item {
    id: item1
    width: 650
    height: 80

    function update_DoorOpen_Light() {
        doorOpen_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_DoorOpen_Light_State ? 1.0 : 0.0;
    }

    function update_SeatBelt_Light() {
        seatBelt_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_SeatBelt_Light_State ? 1.0 : 0.0;
    }

    function update_Airbag_Light() {
        airbag_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Airbag_Light_State ? 1.0 : 0.0;
    }

    function update_Charging_System_Light() {
        battery_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_Battery_Light_State ? 1.0 : 0.0;
    }

    function update_FogLights_Light() {
        fogLight_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_FogLights_Light_State ? 1.0 : 0.0;
    }

    function update_ParkingLights_Light() {
        parkingLights_Light.opacity = INSTRUMENT_CLUSTER_LIGHTS.get_ParkingLights_Light_State ? 1.0 : 0.0;
    }

    function update_LowBeam_Light() {
        let lowBeam_State = INSTRUMENT_CLUSTER_LIGHTS.get_LowBeam_Light_State;

        if (lowBeam_State === "off") {
            lowBeam_Light.opacity = 0.0;
        }
        else if (lowBeam_State === "auto_Off") {
            lowBeam_Light.light_Icon = "qrc:/icons/warning_Lights/low_Beam_Auto.svg"
            lowBeam_Light.light_Color = "gray";
            lowBeam_Light.opacity = 1.0;
        }
        else if (lowBeam_State === "auto_On") {
            lowBeam_Light.light_Icon = "qrc:/icons/warning_Lights/low_Beam_Auto.svg"
            lowBeam_Light.light_Color = "limegreen";
            lowBeam_Light.opacity = 1.0;
        }
        else if (lowBeam_State === "regular_On") {
            lowBeam_Light.light_Icon = "qrc:/icons/warning_Lights/low_Beam.svg"
            lowBeam_Light.light_Color = "limegreen";
            lowBeam_Light.opacity = 1.0;
        }
    }

    function update_HighBeam_Light() {
        let highBeam_State = INSTRUMENT_CLUSTER_LIGHTS.get_HighBeam_Light_State;

        if (highBeam_State === "off") {
            highBeam_Light.opacity = 0.0;
        }
        else if (highBeam_State === "auto_Off") {
            highBeam_Light.light_Icon = "qrc:/icons/warning_Lights/high_Beam_Auto.svg";
            highBeam_Light.light_Color = "gray";
            highBeam_Light.opacity = 1.0;
        }
        else if (highBeam_State === "auto_On") {
            highBeam_Light.light_Icon = "qrc:/icons/warning_Lights/high_Beam_Auto.svg";
            highBeam_Light.light_Color = "dodgerblue";
            highBeam_Light.opacity = 1.0;
        }
        else if (highBeam_State === "regular_On") {
            highBeam_Light.light_Icon = "qrc:/icons/warning_Lights/high_Beam.svg";
            highBeam_Light.light_Color = "dodgerblue";
            highBeam_Light.opacity = 1.0;
        }
    }



    Row {
        id: row
        spacing: 15
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        Warning_Light {
            id: doorOpen_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/door_Open.svg"
            light_Color: "red"
        }

        Warning_Light {
            id: seatBelt_Light
            width: 45
            height: 45
            light_Icon: "qrc:/icons/warning_Lights/seatBelt.svg"
            light_Color: "red"
        }

        Warning_Light {
            id: airbag_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/airbag_System.svg"
            light_Color: "red"
        }

        Warning_Light {
            id: battery_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/12v_Battery.svg"
            light_Color: "red"
        }

        Warning_Light {
            id: fogLight_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/fog_Light.svg"
            light_Color: "limegreen"
        }

        Warning_Light {
            id: parkingLights_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/parking_Lights.svg"
            light_Color: "limegreen"
        }

        Warning_Light {
            id: lowBeam_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/low_Beam.svg"
            light_Color: "limegreen"
        }

        Warning_Light {
            id: highBeam_Light
            width: 50
            height: 50
            light_Icon: "qrc:/icons/warning_Lights/high_Beam.svg"
            light_Color: "dodgerblue"
        }
    }



    Component.onCompleted: {
        update_DoorOpen_Light();
        update_SeatBelt_Light();
        update_Airbag_Light();
        update_Charging_System_Light();
        update_FogLights_Light();
        update_ParkingLights_Light();
        update_LowBeam_Light();
        update_HighBeam_Light();
    }

    Connections {
        target: INSTRUMENT_CLUSTER_LIGHTS
        function onDoorOpen_Light_Changed() {
            update_DoorOpen_Light();
        }

        function onSeatBelt_Light_Changed() {
            update_SeatBelt_Light();
        }

        function onAirbag_Light_Changed() {
            update_Airbag_Light();
        }

        function onBattery_Light_Changed() {
            update_Charging_System_Light();
        }

        function onFogLights_Light_Changed() {
            update_FogLights_Light();
        }

        function onParkingLights_Light_Changed() {
            update_ParkingLights_Light();
        }

        function onLowBeam_Light_Changed() {
            update_LowBeam_Light();
        }

        function onHighBeam_Light_Changed() {
            update_HighBeam_Light();
        }
    }
}
