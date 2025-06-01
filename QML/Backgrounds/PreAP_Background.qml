import QtQuick
import QtQuick3D

Item {
    id: item1
    width: 1920
    height: 720

    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            defaultMaterial.diffuseColor = "#32383f";
        }
        else if (dayNight_State === "night") {
            defaultMaterial.diffuseColor = "#131619";
        }
    }



    View3D {
        id: view3D

        anchors.fill: parent
        environment: sceneEnvironment

        SceneEnvironment {
            id: sceneEnvironment
            probeExposure: 3
            probeOrientation.z: -285
            probeOrientation.y: 90
            probeOrientation.x: 155
            tonemapMode: SceneEnvironment.TonemapModeLinear
            antialiasingMode: SceneEnvironment.SSAA
            antialiasingQuality: SceneEnvironment.High
            lightProbe: Texture {
                source: "qrc:/3d_Objects/lightProbe.hdr"
            }
        }

        Node {
            id: scene

            PerspectiveCamera {
                id: sceneCamera
                x: -500
                y: 203
                eulerRotation.x: 0
                eulerRotation.y: -90
            }

            Model {
                id: sphere
                x: -40
                y: 203
                source: "#Sphere"
                scale.z: 3
                scale.y: 2
                scale.x: 0
                materials: speedometer_Material
            }
        }

        Model {
            id: scene_Floor
            y: -75.656
            source: "#Rectangle"
            scale.y: 100
            scale.x: 50
            eulerRotation.x: -90
            materials: defaultMaterial
        }

        Model {
            id: scene_Wall_1
            x: 3348.309
            y: 165.024
            source: "#Rectangle"
            receivesShadows: false
            castsShadows: false
            eulerRotation.y: -90
            scale.y: 50
            scale.x: 120
            materials: defaultMaterial
        }

        SpotLight {
            id: lightSpot
            x: -640
            y: 1550
            eulerRotation.x: -70
            eulerRotation.y: -90
            bakeMode: Light.BakeModeIndirect
            shadowFilter: 25
            shadowFactor: 80
            castsShadow: true
            brightness: 750
            coneAngle: 80
        }
    }



    Item {
        id: __materialLibrary__

        DefaultMaterial {
            id: defaultMaterial
            diffuseColor: "#32383f"
        }

        DefaultMaterial {
            id: speedometer_Material
            diffuseColor: "#000000"
        }
    }



    Component.onCompleted: {
        update_DayNight_Mode();
    }

    Connections {
        target: APPEARANCE

        function onDayNight_Mode_Changed() {
            update_DayNight_Mode();
        }
    }
}
