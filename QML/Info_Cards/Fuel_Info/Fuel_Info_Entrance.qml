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



    function force_Update_Consumption_Gauge() {
        if (update_Consumption_Gauge.running) {
            update_Consumption_Gauge.restart();
        }
        else {
            update_Consumption_Gauge.start();
        }
    }

    function update_Instant_Fuel_Consumption() {
        let instant_Consumption = FUEL.get_Display_Instant_Consumption;
        let instant_Efficiency = FUEL.get_Display_Instant_Efficiency;

        instant_Consumption_Value.text = instant_Consumption.toFixed(1);
        instant_Efficiency_Value.text = instant_Efficiency.toFixed(1);

        force_Update_Consumption_Gauge();
    }

    function update_Average_Fuel_Consumption() {
        let average_Efficiency = FUEL.get_Display_Average_Efficiency;

        average_Efficiency_Value.text = average_Efficiency.toFixed(1);
    }

    function update_Average_Last_Reset_Value() {
        let average_Last_Reset = FUEL.get_Display_Average_Last_Reset;

        average_Last_Reset_Value.text = average_Last_Reset;
    }

    function update_Fuel_Unit() {
        let fuel_Unit = FUEL.get_Fuel_Unit;

        consumption_Gauge.setValue = 0;

        if (fuel_Unit === "L/100km") {
            efficiency_Gauge_Unit.text = "L/100 km";
            instant_Consumption_Unit.text = "L/h";
            instant_Efficiency_Unit.text = "L/100 km";
            average_Efficiency_Unit.text = "L/100 km";
            consumption_Gauge.maximumValue = 300; //30 L/100 km

        }
        else if (fuel_Unit === "MPG") {
            efficiency_Gauge_Unit.text = "MPG";
            instant_Consumption_Unit.text = "gal/h";
            instant_Efficiency_Unit.text = "MPG";
            average_Efficiency_Unit.text = "MPG";
            consumption_Gauge.maximumValue = 400; //40 MPG

        }
        else if (fuel_Unit === "km/L") {
            efficiency_Gauge_Unit.text = "km/L";
            instant_Consumption_Unit.text = "L/h";
            instant_Efficiency_Unit.text = "km/L";
            average_Efficiency_Unit.text = "km/L";
            consumption_Gauge.maximumValue = 200; //20 km/L

        }

        consumption_Gauge.setValue += 1; //force update gauge to redraw
        consumption_Gauge.setValue -= 1;
        force_Update_Consumption_Gauge();
    }

    function update_Distance_Unit() {
        let distance_Unit = FUEL.get_Distance_Unit;

        if (distance_Unit === "kilometers") {
            average_Last_Reset_Unit.text = "km";
        }
        else if (distance_Unit === "miles") {
            average_Last_Reset_Unit.text = "mi";
        }
    }

    function update_Ignition_State() {
        let ignition_State = VEHICLE_STATES.get_Ignition_State;

        if (ignition_State) {
            efficiency_Gauge_Unit.opacity = 0.8;
            consumption_Gauge.opacity = 1.0;
            instant_Consumption_Column.opacity = 1.0;
        }
        else {
            efficiency_Gauge_Unit.opacity = 0.0;
            consumption_Gauge.opacity = 0.0;
            instant_Consumption_Column.opacity = 0.0;
        }
    }



    Item {
        id: consumption_Gauge_Item
        width: 350
        height: 350
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Consumption_Chart {
            id: consumption_Chart
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: chart_Mask
            width: 350
            height: 350
            asynchronous: true
            visible: false
            source: "qrc:/images/fuel_Info/chart_Mask.png"
            fillMode: Image.PreserveAspectCrop
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        OpacityMask {
            anchors.fill: consumption_Chart
            source: consumption_Chart
            maskSource: chart_Mask
        }



        Image {
            id: gauge_Background
            width: 350
            height: 350
            asynchronous: true
            source: "qrc:/images/fuel_Info/consumption_Gauge.png"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: efficiency_Gauge_Unit
            opacity: 0.8
            text: "L/100 km"
            font.pixelSize: 18
            font.family: FontsManager.systemFont_Medium.name
            color: StyleSheet.speedometer_Value
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }
        }

        Gauge {
            id: consumption_Gauge
            width: 350
            height: 350
            maximumValue: 300
            labelStepSize: 50
            tickmarkStepSize: 10
            labelInset: -25
            minimumValueAngle: -48
            maximumValueAngle: 170
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            tickmark: Rectangle {
                visible: styleData.value !== consumption_Gauge.minimumValue ? false : true
                implicitWidth: 2
                implicitHeight: 20
                antialiasing: true
                color: "white"
            }

            needle: Rectangle {
                y: -150
                implicitWidth: 6
                implicitHeight: 24
                antialiasing: true
                color: "white"
            }

            tickmarkLabel:  Text {
                font.pixelSize: 24
                text: styleData.value / 10
                color: StyleSheet.speedometer_Value
                antialiasing: true
                font.family: FontsManager.systemFont_Medium.name
            }

            background: Canvas {
                property real value: consumption_Gauge.displayValue
                property real outer_Radius: consumption_Gauge.outerRadius

                opacity: 0.8
                anchors.fill: parent
                onValueChanged: requestPaint()

                function degreesToRadians(degrees) {
                    return degrees * (Math.PI / 180);
                }

                onPaint: {
                    let ctx = getContext("2d");
                    ctx.reset();
                    ctx.beginPath();
                    ctx.strokeStyle = "#1e90ff";
                    ctx.lineWidth = 10;
                    ctx.arc(outer_Radius,
                            outer_Radius,
                            outer_Radius / 1.044,
                            degreesToRadians(consumption_Gauge.valueToAngle(consumption_Gauge.minimumValue) - 90),
                            degreesToRadians(consumption_Gauge.valueToAngle(consumption_Gauge.displayValue) - 90));
                    ctx.stroke();
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }
        }



        Column {
            id: instant_Consumption_Column
            anchors.bottom: parent.bottom
            anchors.rightMargin: 33
            anchors.bottomMargin: -37

            Row {
                id: instant_Consumption_Row
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing: 10

                Text {
                    id: instant_Consumption_Value
                    text: "0.0"
                    font.pixelSize: 24
                    font.family: FontsManager.monospacedFont_Medium.name
                    font.weight: Font.Black
                    color: StyleSheet.regular_Text
                }

                Text {
                    id: instant_Consumption_Unit
                    text: "L/h"
                    font.pixelSize: 24
                    font.family: FontsManager.systemFont_Medium.name
                    color: StyleSheet.special_Text
                }
            }

            Row {
                id: instant_Efficiency_Row
                anchors.right: parent.right
                anchors.rightMargin: 0
                spacing: 10

                Text {
                    id: instant_Efficiency_Value
                    text: "0.0"
                    font.pixelSize: 24
                    font.family: FontsManager.monospacedFont_Medium.name
                    font.weight: Font.Black
                    color: StyleSheet.regular_Text
                }

                Text {
                    id: instant_Efficiency_Unit
                    text: "L/100 km"
                    font.pixelSize: 24
                    font.family: FontsManager.systemFont_Medium.name
                    color: StyleSheet.special_Text
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 500
                }
            }
            anchors.right: parent.horizontalCenter
        }


        Row {
            id: average_Efficiency_Row
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 75
            spacing: 5

            Text {
                id: average_Efficiency_Label
                text: "Avg."
                font.pixelSize: 24
                font.family: FontsManager.systemFont_Medium.name
                color: StyleSheet.special_Text
            }

            Text {
                id: average_Efficiency_Value
                text: "0.0"
                font.pixelSize: 24
                font.family: FontsManager.monospacedFont_Bold.name
                font.weight: Font.Black
                color: StyleSheet.regular_Text
            }

            Text {
                id: average_Efficiency_Unit
                text: "L/100 km"
                font.pixelSize: 24
                font.family: FontsManager.systemFont_Medium.name
                color: StyleSheet.special_Text
            }
        }



        Row {
            id: average_Last_Reset_Row
            anchors.top: average_Efficiency_Row.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 5
            spacing: 5

            Text {
                id: average_Last_Reset_Label
                color: StyleSheet.special_Text
                text: "Past"
                font.pixelSize: 18
                font.family: FontsManager.systemFont_Medium.name
            }

            Text {
                id: average_Last_Reset_Value
                color: StyleSheet.regular_Text
                text: "0"
                font.pixelSize: 18
                font.family: FontsManager.monospacedFont_Bold.name
                font.weight: Font.Black
            }

            Text {
                id: average_Last_Reset_Unit
                color: StyleSheet.special_Text
                text: "km"
                font.pixelSize: 18
                font.family: FontsManager.systemFont_Medium.name
            }
        }
    }



    NumberAnimation {
        id: update_Consumption_Gauge
        target: consumption_Gauge
        property: "setValue"
        from: consumption_Gauge.displayValue
        to: FUEL.get_Display_Instant_Efficiency * 10
        duration: 1500
    }



    Component.onCompleted: {
        update_Instant_Fuel_Consumption();
        update_Average_Fuel_Consumption();
        update_Average_Last_Reset_Value();
        update_Fuel_Unit();
        update_Distance_Unit();
        update_Ignition_State();
    }



    Connections {
        target: FUEL

        function onInstant_Consumption_Changed() {
            update_Instant_Fuel_Consumption();
        }

        function onAverage_Efficiency_Changed() {
            update_Average_Fuel_Consumption();
        }

        function onAverage_Last_Reset_Changed() {
            update_Average_Last_Reset_Value();
        }

        function onFuel_Unit_Changed() {
            update_Fuel_Unit();
        }

        function onDistance_Unit_Changed() {
            update_Distance_Unit();
        }
    }

    Connections {
        target: VEHICLE_STATES

        function onIgnition_State_Changed() {
            update_Ignition_State();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
