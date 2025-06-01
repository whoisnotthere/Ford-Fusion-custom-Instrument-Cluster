pragma Singleton
import QtQuick

Item {
    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            speedometer_Body = "qrc:/images/speedometer/day/speedometer_Body.png";
            speedometer_Island = "qrc:/images/speedometer/day/speedometer_Island.png";
            speedometer_Frame = "qrc:/images/speedometer/day/island_Frame.png";
        }
        else if (dayNight_State === "night") {
            speedometer_Body = "qrc:/images/speedometer/night/speedometer_Body.png";
            speedometer_Island = "qrc:/images/speedometer/night/speedometer_Island.png";
            speedometer_Frame = "qrc:/images/speedometer/night/island_Frame.png";
        }
    }



    property url speedometer_Body: "qrc:/images/speedometer/day/speedometer_Body.png"
    property url speedometer_Island: "qrc:/images/speedometer/day/speedometer_Island.png"
    property url speedometer_Frame: "qrc:/images/speedometer/day/island_Frame.png"



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
