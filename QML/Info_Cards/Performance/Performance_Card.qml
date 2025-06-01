import QtQuick
import Qt5Compat.GraphicalEffects
//IMPORT gauge components
import "../../Components"
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    function update_RPM_Value() {
        if (update_Gauge_RPM.running) {
            update_Gauge_RPM.restart();
        }
        else {
            update_Gauge_RPM.start();
        }

        rpm_Value.value = Math.floor(POWERTRAIN.get_Engine_RPM / 10);
    }

    function update_Gear_Value() {
        current_Gear.text = POWERTRAIN.get_Current_Gear;
    }

    function update_Shifter_Position() {
        let shifter_Position = POWERTRAIN.get_Shifter_Position;

        if (shifter_Position === "drive" || shifter_Position === "sport") {
            current_Gear.visible = true;
        }
        else {
            current_Gear.visible = false;
        }
    }

    function update_Coolant_Temperature_Value() {
        engine_Coolant_Temperature_Value.text = POWERTRAIN.get_Engine_Coolant_Temperature;
    }

    function update_Oil_Temperature_Value() {
        engine_Oil_Temperature_Value.text = POWERTRAIN.get_Engine_Oil_Temperature;
    }

    function update_Temperature_Unit() {
        let temperature_Unit = POWERTRAIN.get_Temperature_Unit;

        if (temperature_Unit === "celsius") {
            engine_Coolant_Temperature_Unit.text = "°C";
            engine_Oil_Temperature_Unit.text = "°C";
        }
        else if (temperature_Unit === "fahrenheit") {
            engine_Coolant_Temperature_Unit.text = "°F";
            engine_Oil_Temperature_Unit.text = "°F";
        }
    }



    Item {
        id: gauge_Item
        width: 375
        height: 375
        anchors.top: parent.top
        anchors.topMargin: 75
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            id: gauge_Background
            width: 250
            height: 250
            asynchronous: true
            opacity: 0.8
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/images/performance_Gauge/gauge_Body.png"
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
        }

        Gauge {
            id: rpm_Gauge
            opacity: 1.0
            anchors.fill: parent
            maximumValue: 7500

            labelStepSize: 1000
            tickmarkStepSize: 500
            labelInset: outerRadius / 5
            minimumValueAngle: -120
            maximumValueAngle: 120

            tickmark: null

            needle: Rectangle {
                y: -60
                implicitWidth: 5
                implicitHeight: 60
                antialiasing: true
                gradient: Gradient {
                    GradientStop {
                        position: 0
                        color: StyleSheet.speedometer_Needle
                    }

                    GradientStop {
                        position: 1
                        color: "transparent"
                    }
                }
            }

            tickmarkLabel:  Text {
                font.pixelSize: 24
                text: styleData.value / 1000
                color: styleData.value >= 6500 ? "red" : StyleSheet.speedometer_Value
                antialiasing: true
                font.family: FontsManager.systemFont_Medium.name
            }
        }

        Text {
            id: rpm_Multiplier_Note
            text: "RPM X1000"
            font.pixelSize: 18
            color: StyleSheet.special_Text
            font.family: FontsManager.systemFont_Medium.name
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: gauge_Column_Container
            width: 200
            height: 200
            anchors.top: parent.top
            anchors.topMargin: 75
            anchors.horizontalCenter: parent.horizontalCenter

            Column {
                id: gauge_Values_Column
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    property int value: 0

                    id: rpm_Value
                    text: value * 10
                    font.pixelSize: 55
                    font.family: FontsManager.monospacedFont_Medium.name
                    color: rpm_Gauge.displayValue >= 6500 ? "red" : "white"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Behavior on value {
                        SmoothedAnimation {
                            duration: 250
                        }
                    }
                }

                Text {
                    id: current_Gear
                    visible: false
                    text: "-"
                    font.pixelSize: 36
                    font.family: FontsManager.monospacedFont_Medium.name
                    color: StyleSheet.speedometer_Needle
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }



    Column {
        width: 200
        height: 200
        spacing: 20
        anchors.top: gauge_Item.bottom
        anchors.topMargin: -65
        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            id: engine_Coolant_Item
            width: 200
            height: 100

            Text {
                id: engine_Coolant_Name
                width: 180
                text: "Engine Coolant Temperature"
                font.pixelSize: 24
                color: StyleSheet.special_Text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                font.family: FontsManager.monospacedFont_Medium.name
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: engine_Coolant_Value_Row
                spacing: 5
                anchors.top: engine_Coolant_Name.bottom
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: engine_Coolant_Temperature_Value
                    text: "--"
                    color: "white"
                    font.pixelSize: 30
                    font.family: FontsManager.monospacedFont_Medium.name
                }

                Text {
                    id: engine_Coolant_Temperature_Unit
                    text: "°C"
                    color: "white"
                    font.pixelSize: 30
                    font.family: FontsManager.monospacedFont_Medium.name
                }
            }
        }

        Item {
            id: engine_Oil_Item
            width: 200
            height: 100

            Text {
                id: engine_Oil_Name
                width: 180
                color: StyleSheet.special_Text
                text: "Engine Oil Temperature"
                font.pixelSize: 24
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                font.family: FontsManager.monospacedFont_Medium.name
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Row {
                id: engine_Oil_Value_Row
                spacing: 5
                anchors.top: engine_Oil_Name.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 5

                Text {
                    id: engine_Oil_Temperature_Value
                    color: "#ffffff"
                    text: "--"
                    font.pixelSize: 30
                    font.family: FontsManager.monospacedFont_Medium.name
                }

                Text {
                    id: engine_Oil_Temperature_Unit
                    color: "#ffffff"
                    text: "°C"
                    font.pixelSize: 30
                    font.family: FontsManager.monospacedFont_Medium.name
                }
            }
        }
    }



    NumberAnimation { id: update_Gauge_RPM; target: rpm_Gauge; property: "setValue"; from: rpm_Gauge.displayValue; to: POWERTRAIN.get_Engine_RPM; duration: 150 }



    Component.onCompleted: {
        update_RPM_Value();
        update_Gear_Value();
        update_Shifter_Position();
        update_Coolant_Temperature_Value();
        update_Oil_Temperature_Value();
        update_Temperature_Unit();
    }



    Connections {
        target: POWERTRAIN

        function onEngine_RPM_Changed() {
            update_RPM_Value();
        }

        function onGear_Changed() {
            update_Gear_Value();
        }

        function onShifter_Position_Changed() {
            update_Shifter_Position();
        }

        function onEngine_Coolant_Temperature_Changed() {
            update_Coolant_Temperature_Value();
        }

        function onEngine_Oil_Temperature_Changed() {
            update_Oil_Temperature_Value();
        }

        function onTemperature_Unit_Changed() {
            update_Temperature_Unit();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
