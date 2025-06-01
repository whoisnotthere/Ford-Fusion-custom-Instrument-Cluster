import QtQuick
import QtCharts

Item {
    id: consumption_Chart_Item
    width: 350
    height: 350



    property double efficiency_Max_Value: 30.0
    property double distance_Max_Value: 100.0



    function update_Fuel_Unit() {
        let fuel_Unit = FUEL.get_Fuel_Unit;

        if (fuel_Unit === "L/100km") {
            efficiency_Max_Value = 30.0;
        }
        else if (fuel_Unit === "MPG") {
            efficiency_Max_Value = 40.0;
        }
        else if (fuel_Unit === "km/L") {
            efficiency_Max_Value = 20.0;
        }

        update_Chart_Cursor();
    }

    function update_Chart() {
        let efficiency_Data = FUEL.get_Average_Efficiency_Chart;
        let data_Size = efficiency_Data.length;

        consumption_Chart_Data.clear();
        consumption_Chart_Data_2.clear();

        distance_Max_Value = data_Size;

        for (let i = 0; i < data_Size; i++) {
            let efficiency = efficiency_Data[i].toFixed(1);

            consumption_Chart_Data.append(i, efficiency);
            consumption_Chart_Data_2.append(i, efficiency);
        }
    }

    function update_Chart_Cursor() {
        let last_Point = consumption_Chart_Data.at(consumption_Chart_Data.count - 1);

        chart_Cursor.y = (((efficiency_Max_Value - last_Point.y) * (180 / efficiency_Max_Value)) - (chart_Cursor.height / 2)); //180 - chart active area height
        chart_Cursor.x = ((last_Point.x * (310 / distance_Max_Value)) - (chart_Cursor.width / 2)); //310 - chart active area width
    }

    function update_Chart_Average() {
        let average_Efficiency = FUEL.get_Display_Average_Efficiency;

        average_Consumption_Cursor.y = ((180 / efficiency_Max_Value) * (efficiency_Max_Value - average_Efficiency)) - 1;//1 - average_Consumption_Cursor height divided in half
    }



    ChartView {
        id: consumption_Chart
        width: 380
        height: 250
        antialiasing: true
        backgroundColor: "transparent"
        legend.visible: false
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 70

        AreaSeries {
            color: "#401e90ff"
            borderColor: "transparent"
            axisX: ValueAxis {
                id: distance_Axis
                min: 0
                max: distance_Max_Value
                tickCount: distance_Max_Value
                gridVisible: false
                labelsVisible: false
                lineVisible: false
            }
            axisY: ValueAxis {
                id: fuel_Consumption_Axis
                min: 0
                max: efficiency_Max_Value
                tickCount: efficiency_Max_Value
                gridVisible: false
                labelsVisible: false
                lineVisible: false
            }
            upperSeries: LineSeries {
                id: consumption_Chart_Data

                onPointAdded: {
                    update_Chart_Cursor();
                }
            }
        }

        LineSeries {
            id: consumption_Chart_Data_2
            color: "#1e90ff"
            width: 3
            axisX: ValueAxis {
                id: distance_Axis_2
                min: 0
                max: distance_Max_Value
                tickCount: distance_Max_Value
                gridVisible: false
                labelsVisible: false
                lineVisible: false
            }
            axisY: ValueAxis {
                id: fuel_Consumption_Axis_2
                min: 0
                max: efficiency_Max_Value
                tickCount: efficiency_Max_Value
                gridVisible: false
                labelsVisible: false
                lineVisible: false
            }
        }
    }

    Item {
        id: consumption_Chart_Legend
        width: 310
        height: 180
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 43
        anchors.bottomMargin: 105

        Row {
            id: average_Consumption_Cursor
            y: 0
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Repeater {
                model: 18

                Rectangle {
                    opacity: 0.8
                    width: 14
                    height: 2
                    radius: 1
                    color: "white"
                }
            }
        }

        Rectangle {
            id: chart_Cursor
            x: 0
            y: 0
            width: 12
            height: 12
            radius: 6
            color: "white"

            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: "gray"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }



    Timer {
        id: chart_Updater_Timer
        interval: 3000
        repeat: true
        onTriggered: update_Chart()
    }



    Component.onCompleted: {
        update_Fuel_Unit();
        update_Chart_Average();
        update_Chart();
        chart_Updater_Timer.start();
    }



    Connections {
        target: FUEL

        function onFuel_Unit_Changed() {
            update_Fuel_Unit();
        }

        function onAverage_Efficiency_Changed() {
            update_Chart_Average();
        }
    }
}
