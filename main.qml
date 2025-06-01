import QtQuick
import QtQuick.Window

import "QML/Vehicle_States"

Window {
    width: 1920
    height: 720

    function update_WakeUp_State() {
        let wakeUp_State = VEHICLE_STATES.get_WakeUp_State;
        let remoteStart_State = VEHICLE_STATES.get_RemoteStart_State;

        if (wakeUp_State) {
            states_Loader.source = "QML/Vehicle_States/Wake_Up_State.qml";
        }
        else {
            if (remoteStart_State) {
                states_Loader.source = "QML/Vehicle_States/Remote_Start_State.qml";
            }
            else {
                states_Loader.source = "";
            }
        }

        show_State.start();
    }

    Rectangle {
        id: background
        color: "black"
        anchors.fill: parent
    }

    Item {
        id: states_Container
        anchors.fill: parent

        Loader {
            id: states_Loader
            anchors.fill: parent
        }
    }

    NumberAnimation {id: hide_State; target: states_Container; property: "opacity"; from: 1.0; to: 0.0; duration: 250; onFinished: update_WakeUp_State();}
    NumberAnimation {id: show_State; target: states_Container; property: "opacity"; from: 0.0; to: 1.0; duration: 250}

    Component.onCompleted: {
        update_WakeUp_State();
    }

    Connections {
        target: VEHICLE_STATES

        function onWakeUp_State_Changed() {
            hide_State.start();
        }

        function onRemoteStart_State_Changed() {
            hide_State.start();
        }
    }
}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.5}D{i:1}
}
##^##*/
