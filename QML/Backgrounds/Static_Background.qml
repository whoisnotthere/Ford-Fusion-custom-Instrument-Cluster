import QtQuick

Item {
    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            background.source = "qrc:/images/background/day.png";
        }
        else if (dayNight_State === "night") {
            background.source = "qrc:/images/background/night.png";
        }
    }



    Image {
        id: background
        visible: true
        asynchronous: true
        anchors.fill: parent
        source: "qrc:/images/background/day.png"
        fillMode: Image.PreserveAspectFit
    }



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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
