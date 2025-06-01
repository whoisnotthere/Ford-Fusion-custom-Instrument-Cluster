import QtQuick

Item {
    width: 660
    height: 720

    function update_Ignition_State() {
        let ignition_State = VEHICLE_STATES.get_Ignition_State;

        if (ignition_State) {
            if (performance_Metrics.opacity != 1.0) {
                animation_Performance_Not_Available.stop();
                animation_Performance_Available.start();
            }
        }
        else {
            if (performance_Not_Available.opacity != 1.0) {
                animation_Performance_Available.stop();
                animation_Performance_Not_Available.start();
            }
        }
    }



    Performance_Not_Available {
        id: performance_Not_Available
        opacity: 1.0
    }

    Performance_Card {
        id: performance_Metrics
        opacity: 0.0
    }



    SequentialAnimation {
        id: animation_Performance_Available
        NumberAnimation {target: performance_Not_Available; property: "opacity"; from: 1.0; to: 0.0; duration: 250}
        NumberAnimation {target: performance_Metrics; property: "opacity"; from: 0.0; to: 1.0; duration: 250}
    }

    SequentialAnimation {
        id: animation_Performance_Not_Available
        NumberAnimation {target: performance_Metrics; property: "opacity"; from: 1.0; to: 0.0; duration: 250}
        NumberAnimation {target: performance_Not_Available; property: "opacity"; from: 0.0; to: 1.0; duration: 250}
    }



    Component.onCompleted: {
        update_Ignition_State();
    }



    Connections {
        target: VEHICLE_STATES

        function onIgnition_State_Changed() {
            update_Ignition_State();
        }
    }
}
