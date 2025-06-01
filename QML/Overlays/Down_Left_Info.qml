import QtQuick
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet
import "../"

Item {
    width: 400
    height: 100

    function update_FuelDisplay_Unit() {
        let fuelDisplay_Unit = FUEL.get_FuelDisplay_Unit;
        let distance_Unit = FUEL.get_Distance_Unit;

        if (fuelDisplay_Unit === "percent") {
            fuel_Display_Unit.text = "%";
        }
        else if (fuelDisplay_Unit === "distance") {
            if (distance_Unit === "kilometers") {
                fuel_Display_Unit.text = "km";
            }
            else if (distance_Unit === "miles") {
                fuel_Display_Unit.text = "mi";
            }
        }
    }

    function update_Fuel_Value() {
        fuel_Display_Value.text = FUEL.get_Display_Fuel_Value;
    }

    function update_Fuel_State() {
        let fuel_State = FUEL.get_Fuel_State;

        if (fuel_State === "fuel_Level_Ok") {
            fuel_Display_Icon_Overlay.color = StyleSheet.gas_Regular;
            fuel_Display_Icon_Overlay.opacity = 1.0;
            fuel_Display_Icon_Timer.stop();
        }
        else if (fuel_State === "fuel_Level_Low") {
            fuel_Display_Icon_Overlay.color = StyleSheet.gas_Low;
            fuel_Display_Icon_Timer.interval = 750;
            fuel_Display_Icon_Timer.start();
        }
        else if (fuel_State === "fuel_Level_VeryLow") {
            fuel_Display_Icon_Overlay.color = StyleSheet.gas_VeryLow;
            fuel_Display_Icon_Timer.interval = 500;
            fuel_Display_Icon_Timer.start();
        }
        else if (fuel_State === "fuel_Level_Critical") {
            fuel_Display_Icon_Overlay.color = StyleSheet.gas_Critical;
            fuel_Display_Icon_Timer.interval = 250;
            fuel_Display_Icon_Timer.start();
        }
    }

    function update_Exterior_Temperature_Value() {
        let exterior_Temperature = HVAC.get_Display_Exterior_Temperature;

        outside_Temp_Value.text = exterior_Temperature + "°";
    }

    function update_Exterior_Temperature_Unit() {
        let temperature_Unit = HVAC.get_Temperature_Unit;

        if (temperature_Unit === "celsius") {
            outside_Temp_Unit.text = "C";
        }
        else if (temperature_Unit === "fahrenheit") {
            outside_Temp_Unit.text = "F";
        }
    }



    Row {
        id: row
        anchors.fill: parent
        spacing: 100

        Row {
            id: fuel_Display_Container
            height: 100
            spacing: 5

            Item {
                id: fuel_Display_Icon_Item
                width: 35
                height: 35
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: fuel_Display_Icon
                    asynchronous: true
                    visible: false
                    mipmap: true
                    source: "qrc:/icons/overlays/gas_Station.svg"
                    fillMode: Image.Stretch
                    anchors.fill: parent
                }

                ColorOverlay {
                    id: fuel_Display_Icon_Overlay
                    source: fuel_Display_Icon
                    color: StyleSheet.gas_Regular
                    anchors.fill: fuel_Display_Icon
                }
            }

            Text {
                id: fuel_Display_Value
                color: StyleSheet.regular_Text
                text: "---"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40
                font.family: FontsManager.systemFont_Medium.name
            }

            Text {
                id: fuel_Display_Unit
                color: StyleSheet.minor_Text
                text: "%"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 34
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: FontsManager.systemFont_Medium.name
            }
        }

        Row {
            id: outside_Temp_Container
            height: 100
            spacing: 5

            Text {
                id: outside_Temp_Value
                color: StyleSheet.regular_Text
                text: "--°"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40
                font.family: FontsManager.systemFont_Medium.name
            }

            Text {
                id: outside_Temp_Unit
                color: StyleSheet.minor_Text
                text: "C"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 34
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.family: FontsManager.systemFont_Medium.name
            }
        }
    }



    Timer {
        id: fuel_Display_Icon_Timer
        interval: 750;
        running: false;
        repeat: true;
        onTriggered: {
            if (fuel_Display_Icon_Overlay.opacity == 1.0) {
                fuel_Display_Icon_Overlay.opacity = 0.5;
            }
            else {
                fuel_Display_Icon_Overlay.opacity = 1.0;
            }
        }
    }



    Component.onCompleted: {
        update_FuelDisplay_Unit();
        update_Fuel_Value();
        update_Fuel_State();
        update_Exterior_Temperature_Value();
        update_Exterior_Temperature_Unit();
    }



    Connections {
        target: FUEL

        function onFuel_Display_Unit_Changed() {
            update_FuelDisplay_Unit();
        }

        function onDistance_Unit_Changed() {
            update_FuelDisplay_Unit();
        }

        function onDisplay_Fuel_Value_Changed() {
            update_Fuel_Value();
        }

        function onFuel_State_Changed() {
            update_Fuel_State();
        }
    }

    Connections {
        target: HVAC

        function onTemperature_Unit_Changed() {
            update_Exterior_Temperature_Unit();
        }

        function onExterior_Temperature_Changed() {
            update_Exterior_Temperature_Value();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
