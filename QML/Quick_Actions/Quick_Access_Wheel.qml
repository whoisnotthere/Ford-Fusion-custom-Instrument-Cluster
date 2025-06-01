import QtQuick
import Qt5Compat.GraphicalEffects
import "Wheel_Components/"
import "Quick_Cards/"
//IMPORT StyleSheet, FontsManager
import "../"

Item {
    id: quick_Access_Item
    width: 660
    height: 720

    property bool cards_Wheel_Open: false
    signal quick_Wheel_Open(bool is_Open)



    function open_App() {
        if (!apps_Container.opacity) {
            show_App.start();
        }
        quick_App_Timer.restart();
    }


    function close_App() {
        if (apps_Container.opacity) {
            hide_App.start();
        }
    }

    function open_Quick_Access() {
        quick_Wheel_Open(true);
        open_PathView.start();
    }

    function close_Quick_Access() {
        quick_Wheel_Open(false);

        if (open_PathView.running) {
            open_PathView.stop();
        }

        close_PathView.start();
    }

    function get_Quick_Access_From_Settings() {
        let quick_Access = IC_PREFERENCES.get_Quick_Access;
        return quick_Access;
    }

    function save_Quick_Access_To_Settings(new_Value) {
        IC_PREFERENCES.set_Quick_Access(new_Value);
    }

    function load_App(quick_Name, needs_Saving) {
        switch(quick_Name) {
        case "HVAC_Temperature":
            apps_Loader.source = "qrc:/QML/Quick_Actions/Quick_Cards/Quick_Temperature.qml";
            break;
        case "HVAC_FanSpeed":
            apps_Loader.source = "qrc:/QML/Quick_Actions/Quick_Cards/Quick_Fan.qml";
            break;
        case "display_Brightness":
            apps_Loader.source = "qrc:/QML/Quick_Actions/Quick_Cards/Quick_Display_Brightness.qml";
            break;
        case "recent_Calls":
            apps_Loader.source = "qrc:/QML/Quick_Actions/Quick_Cards/Quick_Recent_Calls.qml";
            break;
        case "contacts":
            apps_Loader.source = "qrc:/QML/Quick_Actions/Quick_Cards/Quick_Contacts.qml";
            break;
        }

        if (needs_Saving) {
            save_Quick_Access_To_Settings(quick_Name);
        }
    }

    function load_Quick_Access_From_Settings() {
        let quick_Access = get_Quick_Access_From_Settings();
        load_App(quick_Access, false);
    }



    Item {
        id: apps_Container
        opacity: 0.0
        width: 660
        height: 720

        Loader {
            id: apps_Loader
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    PathView {
        id: wheel_PathView
        opacity: 0.0
        height: 300
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
        highlightRangeMode: PathView.StrictlyEnforceRange
        pathItemCount: 5

        delegate: Quick_Wheel_Delegate {}
        model: Quick_Wheel_Model {}

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
        anchors.leftMargin: 100
        anchors.rightMargin: 100
        anchors.topMargin: parent.height / 2
    }



    NumberAnimation {
        id: close_PathView; target: wheel_PathView; properties: "opacity"; from: 1.00; to: 0.0; duration: 100
    }
    NumberAnimation {
        id: open_PathView; target: wheel_PathView; properties: "opacity"; from: 0.0; to: 1.0; duration: 250
    }
    NumberAnimation {
        id: hide_App; target: apps_Container; properties: "opacity"; from: 1.00; to: 0.0; duration: 200
    }
    NumberAnimation {
        id: show_App; target: apps_Container; properties: "opacity"; from: 0.0; to: 1.00; duration: 200
    }



    Timer {
        id: quick_App_Timer
        interval: 3000
        onTriggered: {
            close_App();
        }
    }

    Timer {
        id: pathView_Timer
        interval: 5000
        onTriggered: {
            close_Quick_Access();
        }
    }



    Component.onCompleted: {
        load_Quick_Access_From_Settings();
    }



    Connections {
        target: right_Cards_Wheel

        function onCards_Wheel_Open(state) {
            quick_Access_Item.cards_Wheel_Open = state;

            if (cards_Wheel_Open) {
                if (wheel_PathView.opacity) {
                    pathView_Timer.stop();
                    close_Quick_Access();
                }

                if (apps_Container.opacity) {
                    close_App();
                }
            }
        }
    }

    Connections {
        target: STEERING_WHEEL_BUTTONS

        function onButton_Pressed(button_Name) {
            if (!cards_Wheel_Open) {
                if (button_Name === "right_Ok") {
                    if (wheel_PathView.opacity) {
                        pathView_Timer.stop();

                        let current_Index = wheel_PathView.currentIndex;
                        let current_Wheel_Key = wheel_PathView.model.get(current_Index).quick_Key;

                        load_App(current_Wheel_Key, true);
                        close_Quick_Access();
                        open_App();
                    }
                    else {
                        close_App();
                        open_Quick_Access();
                        pathView_Timer.restart();
                    }

                }
                else if (button_Name === "right_Up") {
                    if (wheel_PathView.opacity) {
                        if (wheel_PathView.currentIndex > 0) {
                            wheel_PathView.decrementCurrentIndex();
                        }
                        pathView_Timer.restart();
                    }
                    else {
                        open_App();
                    }

                }
                else if (button_Name === "right_Down") {
                    if (wheel_PathView.opacity) {
                        if (wheel_PathView.currentIndex < 4) {
                            wheel_PathView.incrementCurrentIndex();
                        }
                        pathView_Timer.restart();
                    }
                    else {
                        open_App();
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
