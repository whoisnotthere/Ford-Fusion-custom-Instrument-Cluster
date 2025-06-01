pragma Singleton
import QtQuick

Item {
    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            unselected_Gear = "#000000";
        }
        else if (dayNight_State === "night") {
            unselected_Gear = "#404040";
        }
    }



    //Debug mode title
    readonly property color debug_Title: "#4cff0000"
    //Text
    readonly property color regular_Text: "#ffffff"
    readonly property color special_Text: "#bfbfbf"
    readonly property color minor_Text: "#9a9a9a"
    //Progress bar
    readonly property color progress_Background: "#808080"
    readonly property color progress_Completed: "#ffffff"
    //Shifter
    readonly property color unknown_Gear: "#ff0000"
    readonly property color selected_Gear: "#ffffff"
    property color unselected_Gear: "#000000"
    //States
    readonly property color state_Yes: "#00ff00"
    readonly property color state_No: "#ff0000"
    //Separators
    readonly property color separator: "#bfbfbf"

    //Notifications
    //Info
    readonly property color icon_Info: "#00ff00"
    readonly property color icon_Info_Dark: Qt.darker(icon_Info, 1.5)
    //Notification
    readonly property color notification_Icon: "#ffff00"
    readonly property color notification_Icon_Dark: Qt.darker(notification_Icon, 1.5)
    //Warning
    readonly property color warning_Icon: "#ff0000"
    readonly property color warning_Icon_Dark: Qt.darker(warning_Icon, 1.5)
    //Critical
    readonly property color critical_Icon: "#ff0000"
    readonly property color critical_Icon_Dark: Qt.darker(critical_Icon, 1.5)
    //Background
    readonly property color notification_Background_Regular: "#000000"
    readonly property color notification_Background_Critical: "#ff0000"
    //Overlay
    //Icon
    readonly property color overlay_Icon: "#bfbfbf"
    //Background
    readonly property color overlay_Background_Regular: "#cc000000"
    //Shadow
    readonly property color overlay_Shadow: "#80000000"

    //Gas
    readonly property color gas_Regular: "#ffffff"
    readonly property color gas_Low: "#ffd700"
    readonly property color gas_VeryLow: "#ff8c00"
    readonly property color gas_Critical: "#ff0000"
    readonly property color gas_OutOfRange: "#ff0000"
    //PathView
    readonly property color pathView_Icon_Regular: "#ffffff"
    readonly property color pathView_Text_Regular: "#ffffff"
    //Media
    readonly property color mediaCover_Shadow: "#80000000"

    //Speedometer
    property color speedometer_Needle: "#1e90ff"
    readonly property color speedometer_Value: "#cfcfcf"
    readonly property color speedometer_Unit: "#808080"
    readonly property color speedometer_TickMark: "#cfcfcf"
    readonly property color speedometer_MinorTickMark: "#424242"
    readonly property color tachometer_RedZone: "#cc0000"
    readonly property color speedometer_DigitalValue: "#ffffff"

    //Cruise
    readonly property color cruise_Active: "#ffffff"
    readonly property color cruise_Inactive: "#808080"

    //Analog clock
    property color clock_Needle_Seconds: "#1e90ff"
    readonly property color clock_Needle_Minutes: "#d3d3d3"
    readonly property color clock_Needle_Hours: "#d3d3d3"
    readonly property color clock_Core: "#d3d3d3"



    Component.onCompleted: {
        update_DayNight_Mode();
    }

    Connections {
        target: APPEARANCE

        function onDayNight_Mode_Changed() {
            update_DayNight_Mode();
        }
    }
}
