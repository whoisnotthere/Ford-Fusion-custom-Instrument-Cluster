import QtQuick

Item {
    width: 60
    height: 50

    Image {
        id: right_Blinker
        asynchronous: true
        visible: false
        anchors.fill: parent
        source: "qrc:/images/turn_Signals/v2/blinker.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }

    Connections {
        target: TURN_SIGNALS

        function onRight_Blinker_Changed(state) {
            if (state === "off") {
                right_Blinker.visible = false;

            } else if (state === "on") {
                right_Blinker.visible = true;
                right_Blinker.source = "qrc:/images/turn_Signals/v2/blinker.png";

            } else if (state === "on_Blink") {
                right_Blinker.visible = true;
                right_Blinker.source = "qrc:/images/turn_Signals/v2/blinker_Blink.png";

            }
        }
    }
}
