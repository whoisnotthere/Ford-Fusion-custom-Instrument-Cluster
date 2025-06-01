import QtQuick
//IMPORT StyleSheet
import "../"

Item {
    width: 400
    height: 100

    function update_Global_Time_Value() {
        let global_Time = VEHICLE_DATA.get_Global_Time;

        let date_Object = new Date(global_Time * 1000);

        let week_Days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

        let date_Text = week_Days[date_Object.getDay()] + " " + date_Object.getDate()
        let time_Text = format_Number(date_Object.getHours()) + ":" + format_Number(date_Object.getMinutes());

        clock_Date.text = date_Text;
        clock_Time.text = time_Text;
    }

    function format_Number(number) {
        return number < 10 ? "0" + number : number.toString()
    }

    function update_Ignition_State() {
        let ignition_State = VEHICLE_STATES.get_Ignition_State;

        if (ignition_State) {
            vehicle_State_Value.visible = false;
            shifter_Positions_Row.visible = true;
            clock_Date.visible = false;
        }
        else {
            shifter_Positions_Row.visible = false;
            vehicle_State_Value.visible = true;
            clock_Date.visible = true;
        }
    }

    function update_Shifter_Position() {
        let shifter_Position = POWERTRAIN.get_Shifter_Position;

        if (shifter_Position !== "unknown") {
            p_Gear.color = shifter_Position === "parking" ? StyleSheet.selected_Gear : StyleSheet.unselected_Gear;
            r_Gear.color = shifter_Position === "reverse" ? StyleSheet.selected_Gear : StyleSheet.unselected_Gear;
            n_Gear.color = shifter_Position === "neutral" ? StyleSheet.selected_Gear : StyleSheet.unselected_Gear;
            d_Gear.color = shifter_Position === "drive" ? StyleSheet.selected_Gear : StyleSheet.unselected_Gear;
            s_Gear.color = shifter_Position === "sport" ? StyleSheet.selected_Gear : StyleSheet.unselected_Gear;
        }
        else {
            p_Gear.color = StyleSheet.unknown_Gear;
            r_Gear.color = StyleSheet.unknown_Gear;
            n_Gear.color = StyleSheet.unknown_Gear;
            d_Gear.color = StyleSheet.unknown_Gear;
            s_Gear.color = StyleSheet.unknown_Gear;
        }
    }

    function update_DayNight_Mode() {
        update_Shifter_Position();
    }



    Row {
        id: row
        anchors.fill: parent
        layoutDirection: Qt.RightToLeft
        spacing: 100

        Row {
            id: vehicle_States_Row
            height: 100

            Row {
                id: shifter_Positions_Row
                visible: false
                height: 100
                layoutDirection: Qt.RightToLeft
                spacing: 10

                Text {
                    id: s_Gear
                    width: s_Gear.paintedWidth
                    color: StyleSheet.unknown_Gear
                    text: "S"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    font.family: FontsManager.systemFont_Medium.name
                }

                Text {
                    id: d_Gear
                    width: d_Gear.paintedWidth
                    color: StyleSheet.unknown_Gear
                    text: "D"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    font.family: FontsManager.systemFont_Medium.name
                }

                Text {
                    id: n_Gear
                    width: n_Gear.paintedWidth
                    color: StyleSheet.unknown_Gear
                    text: "N"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    font.family: FontsManager.systemFont_Medium.name
                }

                Text {
                    id: r_Gear
                    width: r_Gear.paintedWidth
                    color: StyleSheet.unknown_Gear
                    text: "R"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    font.family: FontsManager.systemFont_Medium.name
                }

                Text {
                    id: p_Gear
                    width: p_Gear.paintedWidth
                    color: StyleSheet.unknown_Gear
                    text: "P"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 40
                    horizontalAlignment: Text.AlignHCenter
                    font.family: FontsManager.systemFont_Medium.name
                }
            }

            Text {
                id: vehicle_State_Value
                visible: true
                color: StyleSheet.regular_Text
                text: "Car Off"
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 40
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.family: FontsManager.systemFont_Medium.name
            }
        }

        Item {
            id: clock_Item
            width: 200
            height: 100

            Text {
                id: clock_Date
                visible: true
                height: 50
                color: StyleSheet.minor_Text
                text: "---"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: clock_Time.left
                font.pixelSize: 30
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.rightMargin: 20
                font.family: FontsManager.systemFont_Medium.name
            }

            Text {
                id: clock_Time
                height: 50
                color: StyleSheet.regular_Text
                text: "--:--"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                font.pixelSize: 40
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                anchors.rightMargin: 0
                font.family: FontsManager.systemFont_Medium.name
            }
        }
    }



    Component.onCompleted: {
        update_Global_Time_Value();
        update_Ignition_State();
        update_Shifter_Position();
    }



    Connections {
        target: VEHICLE_DATA

        function onGlobal_Time_Changed() {
            update_Global_Time_Value();
        }
    }

    Connections {
        target: POWERTRAIN

        function onShifter_Position_Changed() {
            update_Shifter_Position();
        }
    }

    Connections {
        target: VEHICLE_STATES

        function onIgnition_State_Changed() {
            update_Ignition_State();
        }
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
    D{i:0;formeditorZoom:2}
}
##^##*/
