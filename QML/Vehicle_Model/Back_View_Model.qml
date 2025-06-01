import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../../3d_Objects/Fusion_17"
//IMPORT StyleSheet
import "../../QML/"

Item {
    id: item1
    width: 600
    height: 600

    property bool is_Trunk_Lights_Restricted: false

    function update_Parking_Lights_State() {
        if (BODY.get_Parking_Lights_State) {
            tail_Lights_Mask.opacity = 1.0;
        }
        else {
            tail_Lights_Mask.opacity = 0.0;
        }
    }

    function update_Trunk_Lights_State() {
        if (is_Trunk_Lights_Restricted) {
            trunk_Lights_Overlay.opacity = 0.0;
        }
        else {
            if (BODY.get_Parking_Lights_State) {
                trunk_Lights_Overlay.opacity = 1.0;
            }
            else {
                trunk_Lights_Overlay.opacity = 0.0;
            }
        }
    }

    function update_Reverse_Lights_State() {
        if (is_Trunk_Lights_Restricted) {
            reverse_Lights_Mask.opacity = 0.0;
        }
        else {
            if (BODY.get_Reverse_Lights_State) {
                reverse_Lights_Mask.opacity = 1.0;
            }
            else {
                reverse_Lights_Mask.opacity = 0.0;
            }
        }
    }

    function update_Brake_Lights_State() {
        if (BODY.get_Brake_Lights_State) {
            brake_Lights_Mask.opacity = 1.0;
        }
        else {
            brake_Lights_Mask.opacity = 0.0;
        }

        update_TailLights_Overlay();
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



    function update_TailLights_Overlay() {
        let opacity = 0.0;

        if (BODY.get_Low_Beam_State) {
            opacity = 0.4;
        }

        if (BODY.get_Brake_Lights_State) {
            opacity = 0.8;
        }

        tailLights_Overlay.opacity = opacity;
    }

    function update_Headlights_Overlay() {
        let opacity = 0.0;

        if (BODY.get_Low_Beam_State) {
            opacity = 0.6;
        }

        if (BODY.get_High_Beam_State) {
            opacity = 1.0;
        }

        headlights_Overlay.opacity = opacity;
    }



    function update_Trunk_State() {
        if (BODY.get_Trunk_State) {
            is_Trunk_Lights_Restricted = true;
        }
        else {
            trunk_Lights_Restriction_Timer.restart();
        }

        update_Trunk_Lights_State();
        update_Reverse_Lights_State();
    }



    function update_LKA_State() {
        let LKA_State = PRE_AP.get_LKA_State;

        if (LKA_State) {
            lka_Left_Lane_Mask.visible = true;
            lka_Right_Lane_Mask.visible = true;
        }
        else {
            lka_Left_Lane_Mask.visible = false;
            lka_Right_Lane_Mask.visible = false;
        }
    }

    function update_LKA_LeftLane() {
        let lane_State = PRE_AP.get_LeftLane_State;

        if (lane_State === "not_Detected") {
            lka_Left_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Gray.png";
        }
        else if (lane_State === "detected") {
            lka_Left_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Green.png";
        }
        else if (lane_State === "departuring") {
            lka_Left_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Yellow.png";
        }
        else if (lane_State === "departured") {
            lka_Left_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Red.png";
        }
    }

    function update_LKA_RightLane() {
        let lane_State = PRE_AP.get_RightLane_State;

        if (lane_State === "not_Detected") {
            lka_Right_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Gray.png";
        }
        else if (lane_State === "detected") {
            lka_Right_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Green.png";
        }
        else if (lane_State === "departuring") {
            lka_Right_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Yellow.png";
        }
        else if (lane_State === "departured") {
            lka_Right_Lane_Mask.source = "qrc:/images/3d_Model/LKA/LKA_Red.png";
        }
    }



    Image {
        id: vehicle_Shadow
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/back_View_Shadow.png"
        asynchronous: true
        anchors.fill: parent
    }



    Image {
        id: tailLights_Overlay
        opacity: 0.0
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/tailLights_Overlay.png"
        asynchronous: true
        anchors.fill: parent
    }

    Image {
        id: headlights_Overlay
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/headlights_Overlay.png"
        asynchronous: true
        fillMode: Image.PreserveAspectFit
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 100
    }



    Image {
        id: lka_Left_Lane_Mask
        visible: false
        source: "qrc:/images/3d_Model/LKA/LKA_Green.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Image {
        id: lka_Right_Lane_Mask
        visible: false
        mirror: true
        source: "qrc:/images/3d_Model/LKA/LKA_Green.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }



    View3D {
        id: view3D

        anchors.fill: parent
        environment: sceneEnvironment

        ExtendedSceneEnvironment {
            id: sceneEnvironment
            temporalAAEnabled: true
            specularAAEnabled: true
            probeOrientation.z: -285
            probeOrientation.y: -235
            probeOrientation.x: 270
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
                y: 220
                z: 620
                eulerRotation.x: 350
            }

            Fusion_17 {
                id: fusion_17
            }
        }
    }



    Image {
        id: tail_Lights_Mask
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/tailLights_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Image {
        id: trunk_Lights_Overlay
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/trunk_Lights_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Image {
        id: reverse_Lights_Mask
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/reverse_Lights_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Image {
        id: brake_Lights_Mask
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/brake_Lights_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Image {
        id: left_Blinker_Mask
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/left_Blinker_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }

    Image {
        id: right_Blinker_Mask
        opacity: 0.0
        asynchronous: true
        source: "qrc:/images/3d_Model/Fusion_17/back_View_Masks/right_Blinker_Mask.png"
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
    }



    Timer {
        id: trunk_Lights_Restriction_Timer
        interval: 250
        onTriggered: {
            is_Trunk_Lights_Restricted = false;
            update_Trunk_Lights_State();
            update_Reverse_Lights_State();
        }
    }



    Component.onCompleted: {
        //Lights
        update_Parking_Lights_State();
        update_Trunk_Lights_State();
        update_Brake_Lights_State();
        update_Reverse_Lights_State();
        //Overlays
        update_Headlights_Overlay();
        //Turn signals
        update_Left_Blinker_State();
        update_Right_Blinker_State();
        //Closures
        update_Trunk_State();
        //ADAS
        update_LKA_State();
        update_LKA_LeftLane();
        update_LKA_RightLane();
    }



    Connections {
        target: BODY

        //Lights
        function onParking_Lights_State_Changed() {
            update_Parking_Lights_State();
            update_Trunk_Lights_State();
        }

        function onLow_Beam_State_Changed() {
            update_TailLights_Overlay();
            update_Headlights_Overlay();
        }

        function onHigh_Beam_State_Changed() {
            update_Headlights_Overlay();
        }

        function onBrake_Lights_State_Changed() {
            update_Brake_Lights_State();
        }

        function onReverse_Lights_State_Changed() {
            update_Reverse_Lights_State();
        }

        //Closures
        function onTrunk_State_Changed() {
            update_Trunk_State();
        }
    }

    Connections {
        target: TURN_SIGNALS

        function onLeft_Blinker_Changed() {
            update_Left_Blinker_State();
        }

        function onRight_Blinker_Changed(state) {
            update_Right_Blinker_State();
        }
    }

    Connections {
        target: PRE_AP

        function onLka_State_Changed() {
            update_LKA_State();
        }

        function onLka_LeftLane_State_Changed() {
            update_LKA_LeftLane();
        }

        function onLka_RightLane_State_Changed() {
            update_LKA_RightLane();
        }
    }
}

/*##^##
Designer {
    D{i:0}D{i:1;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}D{i:9;cameraSpeed3d:25;cameraSpeed3dMultiplier:1}
}
##^##*/
