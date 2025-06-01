import QtQuick
import QtQuick3D

Node {
    property double light_Brightness_Multiplier: 1.0

    function update_Ignition_State() {
        if (VEHICLE_STATES.get_Ignition_State) {
            light_Brightness_Multiplier = 10.0;
        }
        else {
            light_Brightness_Multiplier = 1.0;
        }

        update_Lights();
    }

    function update_Left_Blinker_State() {
        let state = TURN_SIGNALS.get_Left_Blinker_State;

        if (state === "on" || state === "off") {
            left_TurnSignal_material.opacity = 0.0;

        } else if (state === "on_Blink") {
            left_TurnSignal_material.opacity = 1.0;

        }
    }

    function update_Right_Blinker_State() {
        let state = TURN_SIGNALS.get_Right_Blinker_State;

        if (state === "on" || state === "off") {
            right_TurnSignal_material.opacity = 0.0;

        } else if (state === "on_Blink") {
            right_TurnSignal_material.opacity = 1.0;

        }
    }

    function update_Left_DRL_State() {
        let blinker_State = TURN_SIGNALS.get_Left_Blinker_State;
        let DRL_State = BODY.get_DRL_State;
        let parking_Lights_State = BODY.get_Parking_Lights_State;

        if (blinker_State === "on_Blink" || blinker_State === "on") {
            left_DRL_material.baseColor = "#ff3600";
            left_DRL_material.emissiveFactor = Qt.vector3d(10, 2.1223, 0);

            if (blinker_State === "on_Blink") {
                left_DRL_material.opacity = 1.0;
            }
            else if (blinker_State === "on") {
                left_DRL_material.opacity = 0.0;
            }
        }
        else {
            left_DRL_material.baseColor = "#ffffff";
            left_DRL_material.emissiveFactor = Qt.vector3d(10, 10, 10);

            if (DRL_State || parking_Lights_State) {
                left_DRL_material.opacity = 1.0;
            }
            else {
                left_DRL_material.opacity = 0.0;
            }
        }
    }

    function update_Right_DRL_State() {
        let blinker_State = TURN_SIGNALS.get_Right_Blinker_State;
        let DRL_State = BODY.get_DRL_State;
        let parking_Lights_State = BODY.get_Parking_Lights_State;

        if (blinker_State === "on_Blink" || blinker_State === "on") {
            right_DRL_material.baseColor = "#ff3600";
            right_DRL_material.emissiveFactor = Qt.vector3d(10, 2.1223, 0);

            if (blinker_State === "on_Blink") {
                right_DRL_material.opacity = 1.0;
            }
            else if (blinker_State === "on") {
                right_DRL_material.opacity = 0.0;
            }
        }
        else {
            right_DRL_material.baseColor = "#ffffff";
            right_DRL_material.emissiveFactor = Qt.vector3d(10, 10, 10);

            if (DRL_State || parking_Lights_State) {
                right_DRL_material.opacity = 1.0;
            }
            else {
                right_DRL_material.opacity = 0.0;
            }
        }
    }

    function update_Parking_Lights_State() {
        let parking_Lights_State = BODY.get_Parking_Lights_State;

        if (parking_Lights_State) {
            left_Rear_TailLight_material.opacity = 1.0;
            right_Rear_TailLight_material.opacity = 1.0;
            trunk_Light_material.opacity = 1.0;
        }
        else {
            left_Rear_TailLight_material.opacity = 0.0;
            right_Rear_TailLight_material.opacity = 0.0;
            trunk_Light_material.opacity = 0.0;
        }
    }

    function update_Low_Beam_State() {
        if (BODY.get_Low_Beam_State) {
            left_LowBeam_material.opacity = 1.0;
            right_LowBeam_material.opacity = 1.0;
        }
        else {
            left_LowBeam_material.opacity = 0.0;
            right_LowBeam_material.opacity = 0.0;
        }
    }

    function update_High_Beam_State() {
        if (BODY.get_High_Beam_State) {
            left_HighBeam_material.opacity = 1.0;
            right_HighBeam_material.opacity = 1.0;
        }
        else {
            left_HighBeam_material.opacity = 0.0;
            right_HighBeam_material.opacity = 0.0;
        }
    }

    function update_Fog_Lights_State() {
        if (BODY.get_Fog_Lights_State) {
            left_Front_FogLight_material.opacity = 1.0;
            right_Front_FogLight_material.opacity = 1.0;
        }
        else {
            left_Front_FogLight_material.opacity = 0.0;
            right_Front_FogLight_material.opacity = 0.0;
        }
    }

    function update_Brake_Lights_State() {
        if (BODY.get_Brake_Lights_State) {
            brake_Light_material.opacity = 1.0;
        }
        else {
            brake_Light_material.opacity = 0.0;
        }
    }

    function update_Reverse_Lights_State() {
        if (BODY.get_Reverse_Lights_State) {
            reverse_Light_material.opacity = 1.0;
        }
        else {
            reverse_Light_material.opacity = 0.0;
        }
    }

    function update_Hood_State() {
        if (BODY.get_Hood_State) {
            hood.eulerRotation.x = 60;
        }
        else {
            hood.eulerRotation.x = 0;
        }
    }

    function update_FrontLeftDoor_State() {
        if (BODY.get_FrontLeftDoor_State) {
            front_Left_Door.eulerRotation.y = -60;
        }
        else {
            front_Left_Door.eulerRotation.y = 0;
        }
    }

    function update_FrontRightDoor_State() {
        if (BODY.get_FrontRightDoor_State) {
            front_Right_Door.eulerRotation.y = 60;
        }
        else {
            front_Right_Door.eulerRotation.y = 0;
        }
    }

    function update_RearLeftDoor_State() {
        if (BODY.get_RearLeftDoor_State) {
            rear_Left_Door.eulerRotation.y = -50;
        }
        else {
            rear_Left_Door.eulerRotation.y = 0;
        }
    }

    function update_RearRightDoor_State() {
        if (BODY.get_RearRightDoor_State) {
            rear_Right_Door.eulerRotation.y = 50;
        }
        else {
            rear_Right_Door.eulerRotation.y = 0;
        }
    }

    function update_Trunk_State() {
        if (BODY.get_Trunk_State) {
            trunk.eulerRotation.x = -60;
        }
        else {
            trunk.eulerRotation.x = 0;
        }
    }

    function update_Lights() {
        update_Left_Blinker_State();
        update_Right_Blinker_State();
        update_Left_DRL_State();
        update_Right_DRL_State();
        update_Parking_Lights_State();
        update_Low_Beam_State();
        update_High_Beam_State();
        update_Fog_Lights_State();
        update_Brake_Lights_State();
        update_Reverse_Lights_State();
    }

    function update_Body_Color() {
        let color_HEX = APPEARANCE.get_Vehicle_Body_Color;
        let metallic = APPEARANCE.get_Vehicle_Body_Metallic_Value;
        let matte = APPEARANCE.get_Vehicle_Body_Matte_Value;

        body_Paint_material.baseColor = color_HEX;
        body_Paint_material.metalness = metallic;
        body_Paint_material.roughness = matte;
    }



    Node {
        scale.z: 100
        scale.y: 100
        scale.x: 100

        Model {
            id: body
            source: "meshes/body.mesh"
            materials: [
                glossy_Plastic_material,
                body_Paint_material,
                left_LowBeam_material,
                left_HighBeam_material,
                left_DRL_material,
                right_DRL_material,
                right_HighBeam_material,
                right_LowBeam_material,
                lights_Reflector_material,
                chrome_material,
                transparent_Glass_material,
                orange_Reflectors_material,
                left_Front_FogLight_material,
                matte_Plastic_material,
                matte_Yellow_Plastic_material,
                matte_Red_Plastic_material,
                transparent_Plastic_material,
                matte_Blue_Plastic_material,
                tinted_Glass_material,
                red_Lamp_Glass_material,
                brake_Light_material,
                matte_Chrome_material,
                left_TurnSignal_material,
                left_Rear_TailLight_material,
                right_TurnSignal_material,
                matte_Light_Plastic_material,
                beige_Plastic_material
            ]
        }

        Model {
            id: hood
            y: 0.276642382144928
            z: -1.1702526807785034
            eulerRotation.x: 0
            source: "meshes/hood.mesh"
            materials: [
                body_Paint_material,
                matte_Plastic_material
            ]
            Behavior on eulerRotation.x {
                SmoothedAnimation {
                    duration: 250
                }
            }
        }

        Model {
            id: front_Left_Door
            x: -0.8271512985229492
            y: -0.0836031585931778
            z: -0.9078778028488159
            source: "meshes/front_Left_Door.mesh"
            materials: [
                body_Paint_material,
                chrome_material,
                transparent_Glass_material,
                left_TurnSignal_material,
                tinted_Glass_material,
                matte_Plastic_material,
                matte_Chrome_material,
                matte_Light_Plastic_material,
                glossy_Plastic_material
            ]
            Behavior on eulerRotation.y {
                SmoothedAnimation {
                    duration: 250
                }
            }
        }

        Model {
            id: front_Right_Door
            x: 0.8271512985229492
            y: -0.0836031585931778
            z: -0.9078778028488159
            source: "meshes/front_Right_Door.mesh"
            materials: [
                body_Paint_material,
                chrome_material,
                transparent_Glass_material,
                right_TurnSignal_material,
                tinted_Glass_material,
                glossy_Plastic_material,
                matte_Plastic_material,
                matte_Chrome_material,
                matte_Light_Plastic_material
            ]
            Behavior on eulerRotation.y {
                SmoothedAnimation {
                    duration: 250
                }
            }
        }

        Model {
            id: rear_Left_Door
            x: -0.8308126330375671
            y: -0.03944358229637146
            z: 0.1759272813796997
            source: "meshes/rear_Left_Door.mesh"
            materials: [
                body_Paint_material,
                tinted_Glass_material,
                matte_Plastic_material,
                matte_Light_Plastic_material,
                matte_Chrome_material,
                chrome_material,
                glossy_Plastic_material
            ]
            Behavior on eulerRotation.y {
                SmoothedAnimation {
                    duration: 250
                }
            }
        }

        Model {
            id: rear_Right_Door
            x: 0.8308126330375671
            y: -0.03944358229637146
            z: 0.1759272813796997
            source: "meshes/rear_Right_Door.mesh"
            materials: [
                body_Paint_material,
                tinted_Glass_material,
                chrome_material,
                glossy_Plastic_material,
                matte_Plastic_material,
                matte_Light_Plastic_material,
                matte_Chrome_material
            ]
            Behavior on eulerRotation.y {
                SmoothedAnimation {
                    duration: 250
                }
            }
        }

        Model {
            id: trunk
            y: 0.3734903037548065
            z: 1.8722331523895264
            source: "meshes/trunk.mesh"
            materials: [
                body_Paint_material,
                chrome_material,
                matte_Plastic_material,
                glossy_Plastic_material,
                red_Lamp_Glass_material,
                transparent_Glass_material,
                reverse_Light_material,
                trunk_Light_material
            ]
            Behavior on eulerRotation.x {
                SmoothedAnimation {
                    duration: 250
                }
            }
        }

        Model {
            id: front_Left_Wheel
            x: -0.782200813293457
            y: -0.4136607050895691
            z: -1.490877628326416
            source: "meshes/wheel.mesh"
            materials: [
                wheel_Rim_material,
                ford_Emblem_Color_material,
                wheel_Tire_material,
                chrome_material,
                matte_Chrome_material,
                brake_Calipers_material
            ]
        }

        Model {
            id: front_Right_Wheel
            x: 0.78
            y: -0.414
            z: -1.49088
            source: "meshes/wheel.mesh"
            eulerRotation.y: 180
            materials: [
                wheel_Rim_material,
                ford_Emblem_Color_material,
                wheel_Tire_material,
                chrome_material,
                matte_Chrome_material,
                brake_Calipers_material
            ]
        }

        Model {
            id: rear_Left_Wheel
            x: -0.782
            y: -0.414
            z: 1.37091
            source: "meshes/wheel.mesh"
            materials: [
                wheel_Rim_material,
                ford_Emblem_Color_material,
                wheel_Tire_material,
                chrome_material,
                matte_Chrome_material,
                brake_Calipers_material
            ]
        }

        Model {
            id: rear_Right_Wheel
            x: 0.782
            y: -0.414
            z: 1.37091
            eulerRotation.y: 180
            source: "meshes/wheel.mesh"
            materials: [
                wheel_Rim_material,
                ford_Emblem_Color_material,
                wheel_Tire_material,
                chrome_material,
                matte_Chrome_material,
                brake_Calipers_material
            ]
        }
    }



    Node {
        id: __materialLibrary__

        PrincipledMaterial {
            id: body_Paint_material
            objectName: "body_Paint_material"
            baseColor: "#460d1d" //#460d1d
            metalness: 0.3
            specularAmount: 0.1
            roughness: 0.1
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: matte_Plastic_material
            objectName: "matte_Plastic_material"
            baseColor: "#080808"
            roughness: 1.0
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: matte_Yellow_Plastic_material
            objectName: "matte_Yellow_Plastic"
            baseColor: "#ffff9f04"
            roughness: 0.5
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
            indexOfRefraction: 1.4500000476837158
        }

        PrincipledMaterial {
            id: matte_Red_Plastic_material
            objectName: "matte_Red_Plastic"
            baseColor: "#ffff0808"
            roughness: 0.5
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
            indexOfRefraction: 1.4500000476837158
        }

        PrincipledMaterial {
            id: transparent_Plastic_material
            objectName: "transparent_Plastic"
            roughness: 0.800000011920929
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
            transmissionFactor: 1
            indexOfRefraction: 1.4500000476837158
        }

        PrincipledMaterial {
            id: matte_Blue_Plastic_material
            objectName: "matte_Blue_Plastic"
            baseColor: "#ff001cff"
            roughness: 0.5
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
            indexOfRefraction: 1.4500000476837158
        }

        PrincipledMaterial {
            id: glossy_Plastic_material
            objectName: "glossy_Plastic_material"
            baseColor: "#050505"
            roughness: 0.2
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: chrome_material
            objectName: "chrome_material"
            baseColor: "#ffffff"
            metalness: 1
            roughness: 0.2
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: red_Lamp_Glass_material
            objectName: "red_Lamp_Glass_material"
            baseColor: "#ff0000"
            indexOfRefraction: 1.45
            transmissionFactor: 1
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: wheel_Rim_material
            objectName: "wheel_Rim_material"
            baseColor: "#4d4d4d"
            metalness: 1
            roughness: 0.5
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: transparent_Glass_material
            objectName: "transparent_Glass_material"
            baseColor: "#ffffff"
            indexOfRefraction: 1.45
            transmissionFactor: 1.0
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: tinted_Glass_material
            objectName: "tinted_Glass_material"
            baseColor: "#7e7e7e"
            indexOfRefraction: 1.45
            transmissionFactor: 1.0
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: ford_Emblem_Color_material
            objectName: "ford_Emblem_Color_material"
            baseColor: "#000428"
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: lights_Reflector_material
            objectName: "lights_Reflector_material"
            baseColor: "#676767"
            metalness: 1
            roughness: 0.8
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: matte_Chrome_material
            objectName: "matte_Chrome_material"
            baseColor: "#cccccc"
            metalness: 1
            roughness: 0.5
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: orange_Reflectors_material
            objectName: "orange_Reflectors_material"
            baseColor: "#994e2e"
            roughness: 0.5
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: wheel_Tire_material
            objectName: "wheel_Tire_material"
            baseColor: "#010101"
            roughness: 1.0
            specularAmount: 0.1
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: brake_Calipers_material
            objectName: "brake_Calipers"
            baseColor: "#ffcc0000"
            metalness: 1
            roughness: 0.5
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: matte_Light_Plastic_material
            objectName: "matte_Light_Plastic"
            baseColor: "#ff414141"
            metalness: 0.5
            roughness: 0.30000001192092896
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
            indexOfRefraction: 1.4500000476837158
        }

        PrincipledMaterial {
            id: beige_Plastic_material
            objectName: "beige_Plastic"
            baseColor: "#ff7f6843"
            roughness: 0.5
            cullMode: PrincipledMaterial.NoCulling
            alphaMode: PrincipledMaterial.Opaque
            indexOfRefraction: 1.4500000476837158
        }

        //LIGHTS MATERIALS

        PrincipledMaterial {
            id: brake_Light_material
            opacity: 0.0
            objectName: "brake_Light_material"
            baseColor: "#ff0000"
            emissiveFactor: Qt.vector3d(10, 0, 0)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: left_Rear_TailLight_material
            opacity: 0.0
            baseColor: "#ff0000"
            metalness: 1
            emissiveFactor: Qt.vector3d(10, 0, 0)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: left_TurnSignal_material
            opacity: 0.0
            baseColor: "#ff3600"
            metalness: 1
            emissiveFactor: Qt.vector3d(10, 2.1223, 0)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: right_Rear_TailLight_material
            opacity: 0.0
            objectName: "right_Rear_TailLight_material"
            baseColor: "#ff0000"
            emissiveFactor: Qt.vector3d(10, 0, 0)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: right_TurnSignal_material
            opacity: 0.0
            objectName: "right_TurnSignal_material"
            baseColor: "#ff3600"
            emissiveFactor: Qt.vector3d(10, 2.1223, 0)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: left_DRL_material
            opacity: 0.0
            objectName: "left_DRL_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: left_HighBeam_material
            opacity: 0.0
            objectName: "left_HighBeam_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: left_LowBeam_material
            opacity: 0.0
            objectName: "left_LowBeam_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: right_DRL_material
            opacity: 0.0
            objectName: "right_DRL_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: right_HighBeam_material
            opacity: 0.0
            objectName: "right_HighBeam_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: right_LowBeam_material
            opacity: 0.0
            objectName: "right_LowBeam_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: left_Front_FogLight_material
            opacity: 0.0
            objectName: "left_Front_FogLight_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: right_Front_FogLight_material
            opacity: 0.0
            objectName: "right_Front_FogLight_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: trunk_Light_material
            opacity: 0.0
            objectName: "trunk_Light_material"
            baseColor: "#ff0000"
            emissiveFactor: Qt.vector3d(10, 0, 0)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }

        PrincipledMaterial {
            id: reverse_Light_material
            opacity: 0.0
            objectName: "reverse_Light_material"
            baseColor: "#ffffff"
            emissiveFactor: Qt.vector3d(10, 10, 10)
            cullMode: Material.NoCulling
            alphaMode: PrincipledMaterial.Opaque
        }
    }



    Component.onCompleted: {
        update_Ignition_State();
        //Update lights
        update_Lights();
        //Update doors
        update_Hood_State();
        update_FrontLeftDoor_State();
        update_FrontRightDoor_State();
        update_RearLeftDoor_State();
        update_RearRightDoor_State();
        update_Trunk_State();
        //Update body appearance
        update_Body_Color();
    }

    Connections {
        target: BODY

        function onDrl_State_Changed() {
            update_Left_DRL_State();
            update_Right_DRL_State();
        }

        function onParking_Lights_State_Changed() {
            update_Left_DRL_State();
            update_Right_DRL_State();
            update_Parking_Lights_State();
        }

        function onLow_Beam_State_Changed() {
            update_Low_Beam_State();
        }

        function onHigh_Beam_State_Changed() {
            update_High_Beam_State();
        }

        function onFog_Lights_State_Changed() {
            update_Fog_Lights_State();
        }

        function onBrake_Lights_State_Changed() {
            update_Brake_Lights_State();
        }

        function onReverse_Lights_State_Changed() {
            update_Reverse_Lights_State();
        }

        //Closures
        function onHood_State_Changed() {
            update_Hood_State();
        }

        function onFrontLeftDoor_State_Changed() {
            update_FrontLeftDoor_State();
        }

        function onFrontRightDoor_State_Changed() {
            update_FrontRightDoor_State();
        }

        function onRearLeftDoor_State_Changed() {
            update_RearLeftDoor_State();
        }

        function onRearRightDoor_State_Changed() {
            update_RearRightDoor_State();
        }

        function onTrunk_State_Changed() {
            update_Trunk_State();
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

    Connections {
        target: VEHICLE_STATES

        function onIgnition_State_Changed() {
            update_Ignition_State();
        }
    }

    Connections {
        target: APPEARANCE

        function onVehicle_Body_Color_Changed() {
            update_Body_Color();
        }
    }

}

/*##^##
Designer {
    D{i:0;cameraSpeed3d:25;cameraSpeed3dMultiplier:1;matPrevEnvDoc:"SkyBox";matPrevEnvValueDoc:"preview_studio";matPrevModelDoc:"#Sphere"}
}
##^##*/
