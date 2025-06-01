import QtQuick

Item {
    width: 40
    height: 40

    Image {
        id: left_Blinker
        asynchronous: true
        visible: false
        anchors.fill: parent
        source: "qrc:/images/turn_Signals/v1/blinker.png"
        mirror: true
        mipmap: true
        fillMode: Image.PreserveAspectFit
    }

    Connections {
        target: TURN_SIGNALS

        function onLeft_Blinker_Changed(state) {
            if (state === "off") {
                left_Blinker.visible = false;

            } else if (state === "on") {
                left_Blinker.visible = true;
                left_Blinker.source = "qrc:/images/turn_Signals/v1/blinker.png";

            } else if (state === "on_Blink") {
                left_Blinker.visible = true;
                left_Blinker.source = "qrc:/images/turn_Signals/v1/blinker_Blink.png";

            }
        }
    }
}
