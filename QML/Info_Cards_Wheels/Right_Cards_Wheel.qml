import QtQuick
import Qt5Compat.GraphicalEffects

import "Right_Wheel_Components/"

Item {
    id: right_Cards_Wheel_Item
    width: 660
    height: 720

    signal card_Changed(string old_Value, string new_Value)
    signal cards_Wheel_Open(bool state)



    function open_App() {
        pull_App.start();
        show_App.start();
    }

    function close_App() {
        if (pull_App.running) {
            pull_App.stop();
        }

        if (show_App.running) {
            show_App.stop();
        }

        hide_App.start();
    }

    function open_CardWheel() {
        open_PathView.start();
    }

    function close_CardWheel() {
        pathView_Timer.stop();

        if (open_PathView.running) {
            open_PathView.stop();
        }

        if (wheel_PathView.opacity != 0.0) {
            close_PathView.start();
        }
    }

    function get_Card_From_Settings() {
        let card_Value = IC_PREFERENCES.get_Card_Right;
        return card_Value;
    }

    function save_Card_To_Settings(new_Card_Value) {
        IC_PREFERENCES.set_Card_Right(new_Card_Value);
    }

    function load_App_By_Name(app_Name, needs_Saving) {
        let old_Card = get_Card_From_Settings();

        close_App();
        switch (app_Name) {
        case "empty":
            apps_Loader.source = "";
            break;
        case "media":
            apps_Loader.source = "qrc:/QML/Info_Cards/Now_Playing/Now_Playing_Entrance.qml";
            break;
        case "navigation":
            apps_Loader.source = "qrc:/QML/Info_Cards/Navigation/Navigation_Entrance.qml";
            break;
        case "trips":
            apps_Loader.source = "qrc:/QML/Info_Cards/Trips/Trips_Entrance.qml";
            break;
        case "fuel_Info":
            apps_Loader.source = "qrc:/QML/Info_Cards/Fuel_Info/Fuel_Info_Entrance.qml";
            break;
        case "clock":
            apps_Loader.source = "qrc:/QML/Info_Cards/Clock_Card.qml";
            break;
        case "vehicle_Status":
            apps_Loader.source = "qrc:/QML/Info_Cards/Car_Status_Card.qml";
            break;
        case "performance":
            apps_Loader.source = "qrc:/QML/Info_Cards/Performance/Performance_Entrance.qml";
            break;
        }
        open_App();

        if (needs_Saving) {
            save_Card_To_Settings(app_Name)
        }

        let new_Card = get_Card_From_Settings();
        card_Changed(old_Card, new_Card);
    }

    function load_Card_From_Settings() {
        let card_Value = get_Card_From_Settings();
        load_App_By_Name(card_Value, false);
    }



    Item {
        id: apps_Container
        width: 660
        height: 720

        Loader {
            id: apps_Loader
        }
    }

    PathView {
        id: wheel_PathView
        opacity: 0.0
        height: wheel_PathView.count * 110
        preferredHighlightEnd: 0.5
        preferredHighlightBegin: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange
        delegate: Right_Wheel_Item_Delegate {}
        model: Right_Wheel_Model {}

        path: Path {
            startX: wheel_PathView.width / 2
            startY: -wheel_PathView.height

            PathLine {
                x: wheel_PathView.width / 2
                y: wheel_PathView.height
            }
        }

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: right_Cards_Wheel_Item.height / 2
        anchors.leftMargin: 100
        anchors.rightMargin: 100
    }



    NumberAnimation {
        id: close_PathView; target: wheel_PathView; properties: "opacity"; from: 1.00; to: 0.0; duration: 100
    }

    NumberAnimation {
        id: open_PathView; target: wheel_PathView; properties: "opacity"; from: 0.0; to: 1.0; duration: 250
    }

    NumberAnimation {
        id: pull_App; target: apps_Container; properties: "x"; from: parent.x + parent.width; to: 0.0; duration: 1000; easing.type: Easing.OutExpo
    }

    NumberAnimation {
        id: hide_App; target: apps_Container; properties: "opacity"; from: 1.00; to: 0.0; duration: 200
    }
    NumberAnimation {
        id: show_App; target: apps_Container; properties: "opacity"; from: 0.0; to: 1.00; duration: 1000
    }



    Timer {
        id: pathView_Timer
        interval: 5000
        onTriggered: {
            close_CardWheel();
            open_App();
        }
    }



    Component.onCompleted: {
        load_Card_From_Settings();
    }



    Connections {
        target: quick_Access_Wheel

        function onQuick_Wheel_Open(state) {
            if (state) {
                close_App();
            }
            else {
                open_App();
            }
        }
    }

    Connections {
        target: left_Cards_Wheel
        function onCard_Changed(old_Value, new_Value) {
            if (new_Value !== "empty") {
                if (new_Value === get_Card_From_Settings()) {
                    close_CardWheel();
                    load_App_By_Name(old_Value, true);
                }
            }
        }
    }

    Connections {
        target: STEERING_WHEEL_BUTTONS
        function onButton_Pressed(button_Name) {
            if (button_Name === "right_Long_Ok") {
                if (wheel_PathView.opacity) {
                    close_CardWheel();
                    open_App();
                    cards_Wheel_Open(false);
                }
                else {
                    cards_Wheel_Open(true);
                    close_App();
                    open_CardWheel();
                    pathView_Timer.restart();
                }

            }
            else if (button_Name === "right_Ok") {
                if (wheel_PathView.opacity) {
                    close_CardWheel();

                    let current_Index = wheel_PathView.currentIndex;
                    let current_Wheel_Key = wheel_PathView.model.get(current_Index).card_Key;

                    load_App_By_Name(current_Wheel_Key, true)
                    cards_Wheel_Open(false);
                }

            }
            else if (button_Name === "right_Up") {
                if (wheel_PathView.opacity) {
                    if (wheel_PathView.currentIndex > 0) {
                        wheel_PathView.decrementCurrentIndex();
                    }
                    pathView_Timer.restart();
                }

            }
            else if (button_Name === "right_Down") {
                if (wheel_PathView.opacity) {
                    if (wheel_PathView.currentIndex < wheel_PathView.count - 3) { //-3 - minus 2 empty elements at the end of the model
                        wheel_PathView.incrementCurrentIndex();
                    }
                    pathView_Timer.restart();

                }

            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}
}
##^##*/
