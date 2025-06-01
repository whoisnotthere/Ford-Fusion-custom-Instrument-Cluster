import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: item1
    width: 660
    height: 720

    function open_Overlay() {
        if (!overlay_Loader.opacity) {
            show_Overlay.start();
        }

        overlay_Visibility_Timer.restart();
    }



    Loader {
        id: overlay_Loader
        opacity: 0.0
        source: ""
        anchors.fill: parent
    }



    NumberAnimation {
        id: show_Overlay; target: overlay_Loader; properties: "opacity"; from: 0.0; to: 1.0; duration: 250
    }

    NumberAnimation {
        id: hide_Overlay; target: overlay_Loader; properties: "opacity"; from: 1.00; to: 0.0; duration: 250
    }



    Timer {
        id: overlay_Visibility_Timer
        interval: 3000
        onTriggered: hide_Overlay.start()
    }



    Connections {
        target: STEERING_WHEEL_BUTTONS
        function onButton_Pressed(button_Name) {
            if (button_Name == "volume_Plus" || button_Name == "volume_Minus") {
                overlay_Loader.source = "qrc:/QML/Notifications/Left_Notifications_Overlay/Entertainment_Volume_Overlay.qml";
                open_Overlay();
            }
        }
    }

    Connections {
        target: VEHICLE_FEATURES

        function onLight_Switch_State_Changed() {
            overlay_Loader.source = "qrc:/QML/Notifications/Left_Notifications_Overlay/Lighting_Control_Overlay.qml"
            open_Overlay();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
