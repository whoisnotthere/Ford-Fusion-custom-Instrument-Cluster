import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../../3d_Objects/Fusion_17"

Item {
    id: item1
    width: 1920
    height: 720

    function update_Fog_Lights_State() {
        if (BODY.get_Fog_Lights_State) {
            left_Fog_Light_Mask.opacity = 1.0;
        }
        else {
            left_Fog_Light_Mask.opacity = 0.0;
        }
    }

    function update_Low_Beam_State() {
        if (BODY.get_Low_Beam_State) {
            left_LowBeam_Mask.opacity = 1.0;
        }
        else {
            left_LowBeam_Mask.opacity = 0.0;
        }

        update_TailLights_Overlay();
        update_Headlights_Overlay();
    }

    function update_High_Beam_State() {
        if (BODY.get_High_Beam_State) {
            left_HighBeam_Mask.opacity = 1.0;
        }
        else {
            left_HighBeam_Mask.opacity = 0.0;
        }

        update_Headlights_Overlay();
    }

    function update_Left_DRL_State() {
        let blinker_State = TURN_SIGNALS.get_Left_Blinker_State;
        let DRL_State = BODY.get_DRL_State;
        let parking_Lights_State = BODY.get_Parking_Lights_State;

        if (blinker_State === "on_Blink" || blinker_State === "on") {
            left_DRL_Mask.opacity = 0.0;
        }
        else {
            if (DRL_State || parking_Lights_State) {
                left_DRL_Mask.opacity = 1.0;
            }
            else {
                left_DRL_Mask.opacity = 0.0;
            }
        }
    }

    function update_Right_DRL_State() {
        let blinker_State = TURN_SIGNALS.get_Right_Blinker_State;
        let DRL_State = BODY.get_DRL_State;
        let parking_Lights_State = BODY.get_Parking_Lights_State;

        if (blinker_State === "on_Blink" || blinker_State === "on") {
            right_DRL_Mask.opacity = 0.0;
        }
        else {
            if (DRL_State || parking_Lights_State) {
                right_DRL_Mask.opacity = 1.0;
            }
            else {
                right_DRL_Mask.opacity = 0.0;
            }
        }
    }

    function update_Left_Blinker_State() {
        let state = TURN_SIGNALS.get_Left_Blinker_State;

        if (state === "on" || state === "off") {
            left_Blinker_Mask.opacity = 0.0;

        } else if (state === "on_Blink") {
            left_Blinker_Mask.opacity = 1.0;

        }
    }

    function update_Right_Blinker_State() {
        let state = TURN_SIGNALS.get_Right_Blinker_State;

        if (state === "on" || state === "off") {
            right_Blinker_Mask.opacity = 0.0;

        } else if (state === "on_Blink") {
            right_Blinker_Mask.opacity = 1.0;

        }
    }

    function update_Parking_Lights_State() {
        let parking_Lights_State = BODY.get_Parking_Lights_State;

        if (parking_Lights_State) {
            rear_Left_ParkLight_Mask.opacity = 1.0;
        }
        else {
            rear_Left_ParkLight_Mask.opacity = 0.0;
        }
    }



    function update_TailLights_Overlay() {
        let opacity = 0.0;

        if (BODY.get_Low_Beam_State) {
            opacity = 0.5;
        }

        if (BODY.get_Brake_Lights_State) {
            opacity = 0.8;
        }

        tailLights_Overlay.opacity = opacity;
    }

    function update_Headlights_Overlay() {
        let opacity = 0.0;

        if (BODY.get_Low_Beam_State) {
            opacity = 0.4;
        }

        if (BODY.get_High_Beam_State) {
            opacity = 0.8;
        }

        headlights_Overlay.opacity = opacity;
    }



    Image {
        id: tailLights_Overlay
        opacity: 0.0
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/tailLights_Overlay.png"
        anchors.fill: parent

        Behavior on opacity {
            SmoothedAnimation {
                duration: 1000
            }
        }
    }

    Image {
        id: headlights_Overlay
        opacity: 0.0
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/headlights_Overlay.png"
        anchors.fill: parent

        Behavior on opacity {
            SmoothedAnimation {
                duration: 1000
            }
        }
    }



    View3D {
        id: view3D

        anchors.fill: parent
        environment: sceneEnvironment

        ExtendedSceneEnvironment {
            id: sceneEnvironment
            temporalAAEnabled: true
            probeOrientation.z: -285
            probeOrientation.y: 90
            probeOrientation.x: 155
            tonemapMode: SceneEnvironment.TonemapModeLinear
            fxaaEnabled: true
            lightProbe: Texture {
                source: "qrc:/3d_Objects/lightProbe.hdr"
            }
        }

        Node {
            id: scene

            PerspectiveCamera {
                id: sceneCamera
                x: -280
                y: 185
                z: -475
                eulerRotation.x: 340
                eulerRotation.y: -145
            }

            Fusion_17 {
                id: fusion_17
            }
        }
    }



    Image {
        id: left_Fog_Light_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/left_FogLight_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: left_LowBeam_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/left_LowBeam_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: left_HighBeam_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/left_HighBeam_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: left_DRL_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/left_DRL_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: right_DRL_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/right_DRL_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: left_Blinker_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/left_Blinker_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: right_Blinker_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/right_Blinker_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: rear_Left_ParkLight_Mask
        width: 600
        height: 720
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/main_View_Masks/rear_Left_ParkLight_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }



    Component.onCompleted: {
        update_TailLights_Overlay();
        update_Left_DRL_State();
        update_Left_Blinker_State();
        update_Right_DRL_State();
        update_Right_Blinker_State();
        update_Parking_Lights_State();
        update_Fog_Lights_State();
        update_Low_Beam_State();
        update_High_Beam_State();
    }



    Connections {
        target: BODY

        function onBrake_Lights_State_Changed() {
            update_TailLights_Overlay();
        }

        function onDrl_State_Changed() {
            update_Left_DRL_State();
            update_Right_DRL_State();
        }

        function onParking_Lights_State_Changed() {
            update_Left_DRL_State();
            update_Right_DRL_State();
            update_Parking_Lights_State();
        }

        function onFog_Lights_State_Changed() {
            update_Fog_Lights_State();
        }

        function onLow_Beam_State_Changed() {
            update_Low_Beam_State();
        }

        function onHigh_Beam_State_Changed() {
            update_High_Beam_State();
        }
    }

    Connections {
        target: TURN_SIGNALS

        function onLeft_Blinker_Changed() {
            update_Left_Blinker_State();
            update_Left_DRL_State();
        }

        function onRight_Blinker_Changed(state) {
            update_Right_Blinker_State();
            update_Right_DRL_State();
        }
    }
}

/*##^##
Designer {
    D{i:0;matPrevEnvDoc:"SkyBox";matPrevEnvValueDoc:"preview_studio";matPrevModelDoc:"#Sphere"}
D{i:1;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}
}
##^##*/
