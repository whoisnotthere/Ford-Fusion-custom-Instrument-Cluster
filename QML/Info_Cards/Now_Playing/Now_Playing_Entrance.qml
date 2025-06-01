import QtQuick

Item {
    width: 660
    height: 720

    function update_Media_Availability() {
        let media_Available = NOW_PLAYING.return_Media_Availability;

        if (media_Available) {
            animation_Media_Not_Available.stop();
            animation_Media_Available.start();
        }
        else {
            animation_Media_Available.stop();
            animation_Media_Not_Available.start();
        }
    }



    Now_Playing {
        id: now_Playing
        opacity: 0.0
    }



    NumberAnimation {id: animation_Media_Available; target: now_Playing; property: "opacity"; from: 0.0; to: 1.0; duration: 350}

    NumberAnimation {id: animation_Media_Not_Available; target: now_Playing; property: "opacity"; from: 1.0; to: 0.0; duration: 350}



    Component.onCompleted: {
        update_Media_Availability();
    }



    Connections {
        target: NOW_PLAYING

        function onMedia_Unit_Availability_Changed() {
            update_Media_Availability();
        }
    }
}
