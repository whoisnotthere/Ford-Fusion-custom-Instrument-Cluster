import QtQuick
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    function update_Message_Visible() {
        if (!since_Last_Restart.visible && !since_Last_Refuel.visible && !trip_A.visible && !trip_B.visible) {
            if (no_Trips.opacity != 1.0) {
                animation_Trips_Exists.stop();
                animation_Trips_Not_Exists.start();
            }
        }
        else {
            if (trips_Column.opacity != 1.0) {
                animation_Trips_Not_Exists.stop();
                animation_Trips_Exists.start();
            }
        }
    }

    function update_SinceLastRestart_Visible() {
        let visible = TRIPS.return_SinceLastRestart_Visible;
        since_Last_Restart.visible = visible;
        update_Message_Visible();
    }

    function update_SinceLastRefuel_Visible() {
        let visible = TRIPS.return_SinceLastRefuel_Visible;
        since_Last_Refuel.visible = visible;
        update_Message_Visible();
    }

    function update_TripA_Visible() {
        let visible = TRIPS.return_TripA_Visible;
        trip_A.visible = visible;
        update_Message_Visible();
    }

    function update_TripB_Visible() {
        let visible = TRIPS.return_TripB_Visible;
        trip_B.visible = visible;
        update_Message_Visible();
    }

    function update_CustomTrip_Visible() {
        let visible = TRIPS.return_CustomTrip_Visible;
        update_Message_Visible();
    }



    Column {
        id: trips_Column
        opacity: 1.0
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        SinceLastRestart {
            id: since_Last_Restart
            visible: true
        }

        SinceLastRefuel {
            id: since_Last_Refuel
            visible: true
        }

        TripA {
            id: trip_A
            visible: true
        }

        TripB {
            id: trip_B
            visible: true
        }
    }

    No_Trips {
        id: no_Trips
        opacity: 0.0
    }



    SequentialAnimation {
        id: animation_Trips_Exists
        NumberAnimation {target: no_Trips; property: "opacity"; from: 1.0; to: 0.0; duration: 350}
        NumberAnimation {target: trips_Column; property: "opacity"; from: 0.0; to: 1.0; duration: 0}
    }

    SequentialAnimation {
        id: animation_Trips_Not_Exists
        NumberAnimation {target: trips_Column; property: "opacity"; from: 1.0; to: 0.0; duration: 0}
        NumberAnimation {target: no_Trips; property: "opacity"; from: 0.0; to: 1.0; duration: 350}
    }



    Component.onCompleted: {
        update_SinceLastRestart_Visible();
        update_SinceLastRefuel_Visible();
        update_TripA_Visible();
        update_TripB_Visible();
    }



    Connections {
        target: TRIPS
        function onSinceLastRestart_Visible_Changed() {
            update_SinceLastRestart_Visible();
        }

        function onSinceLastRefuel_Visible_Changed() {
            update_SinceLastRefuel_Visible();
        }

        function onTripA_Visible_Changed() {
            update_TripA_Visible();
        }

        function onTripB_Visible_Changed() {
            update_TripB_Visible();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}D{i:5}D{i:6}D{i:3}D{i:7}D{i:10}D{i:13}D{i:17}D{i:16}D{i:31}
D{i:30}D{i:45}D{i:44}D{i:1}
}
##^##*/
