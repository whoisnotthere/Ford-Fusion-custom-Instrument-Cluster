import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../../3d_Objects/Fusion_17"

Item {
    id: item1
    width: 660
    height: 720

    function update_DayNight_Mode() {
        let dayNight_State = APPEARANCE.get_DayNight_Mode;

        if (dayNight_State === "day") {
            vehicle_Shadow_Image.source = "qrc:/images/3d_Model/Fusion_17/simplified_Shadow_Top.png";
        }
        else if (dayNight_State === "night") {
            vehicle_Shadow_Image.source = "qrc:/images/3d_Model/Fusion_17/simplified_Glow_Top.png";
        }
    }



    Image {
        id: vehicle_Shadow_Image
        source: "qrc:/images/3d_Model/Fusion_17/simplified_Shadow_Top.png"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
    }



    View3D {
        id: view3D

        anchors.fill: parent
        environment: sceneEnvironment

        ExtendedSceneEnvironment {
            id: sceneEnvironment
            temporalAAEnabled: true
            probeOrientation.x: 210
            probeOrientation.y: 90
            probeOrientation.z: -280
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
                y: 750
                eulerRotation.x: -90
            }

            Fusion_17 {
                id: fusion_17
            }
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
