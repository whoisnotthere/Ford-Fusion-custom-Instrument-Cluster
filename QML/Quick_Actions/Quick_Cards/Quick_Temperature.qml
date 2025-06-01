import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: overlay_Item
    width: 380
    height: 140

    property bool quick_Wheel_Open: false
    property bool cards_Wheel_Open: false



    function update_Temperature_Unit() {
        let temperature_Unit = HVAC.get_Temperature_Unit;

        if (temperature_Unit === "celsius") {
            quick_Slider.from = 15.0;
            quick_Slider.to = 30.0;
        }
        else if (temperature_Unit === "fahrenheit") {
            quick_Slider.from = 59.0;
            quick_Slider.to = 86.0;
        }
    }

    function update_Temperature() {
        let temperature = HVAC.get_Display_Driver_Temperature;
        let temperature_Unit = HVAC.get_Temperature_Unit;

        if (temperature !== "off" && temperature !== "hi" && temperature !== "lo") {
            quick_Slider.value = temperature;

            if (temperature_Unit === "celsius") {
                quick_Value.text = parseFloat(temperature).toFixed(1) + "°";
            }
            else if (temperature_Unit === "fahrenheit") {
                quick_Value.text = parseFloat(temperature).toFixed(0) + "°";
            }
        }
        else {
            if (temperature === "off") {
                quick_Value.text = "OFF";
            }
            else if (temperature === "hi") {
                if (temperature_Unit === "celsius") {
                    quick_Slider.value = 30.0;
                }
                else if (temperature_Unit === "fahrenheit") {
                    quick_Slider.value = 86.0;
                }

                quick_Value.text = "HI";
            }
            else if (temperature === "lo") {
                if (temperature_Unit === "celsius") {
                    quick_Slider.value = 15.0;
                }
                else if (temperature_Unit === "fahrenheit") {
                    quick_Slider.value = 59.0;
                }

                quick_Value.text = "LO";
            }
        }

        if (temperature === "off") {
            quick_Slider.visible = false;
        }
        else {
            quick_Slider.visible = true;
        }
    }



    Rectangle {
        id: overlay_Background
        visible: false
        color: StyleSheet.overlay_Background_Regular
        radius: 20
        anchors.fill: parent
    }

    DropShadow {
        id: overlay_Background_Shadow
        visible: true
        source: overlay_Background
        horizontalOffset: 0
        verticalOffset: 0
        radius: 12
        color: StyleSheet.overlay_Shadow
        smooth: true
        anchors.fill: parent
    }

    Text {
        id: quick_Name
        color: StyleSheet.special_Text
        text: "Temperature"
        anchors.bottom: parent.bottom
        font.pixelSize: 24
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: FontsManager.systemFont_Medium.name
    }

    Slider {
        id: quick_Slider
        width: 6
        from: 0.0
        to: 1.0
        value: 0.0
        orientation: Qt.Vertical

        background: Rectangle {
            x: quick_Slider.leftPadding + quick_Slider.availableWidth / 2 - width / 2
            y: quick_Slider.topPadding
            implicitWidth: quick_Slider.width
            implicitHeight: quick_Slider.height
            width: implicitWidth
            height: quick_Slider.availableHeight
            color: StyleSheet.progress_Completed

            Rectangle {
                width: parent.width
                height: quick_Slider.visualPosition * parent.height
                color: StyleSheet.progress_Background
            }
        }

        handle: Rectangle {
            x: quick_Slider.leftPadding + quick_Slider.availableWidth / 2 - width / 2
            y: quick_Slider.topPadding + quick_Slider.visualPosition * (quick_Slider.availableHeight - height)
            implicitWidth: 14
            implicitHeight: 4
            color: StyleSheet.progress_Completed
        }
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 40
        anchors.topMargin: -6
        anchors.bottomMargin: -6
    }

    Image {
        id: quick_Icon
        asynchronous: true
        mipmap: true
        width: 60
        height: 60
        source: "qrc:/icons/quick_Access/temperature.svg"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 27
    }

    ColorOverlay {
        source: quick_Icon
        color: StyleSheet.overlay_Icon
        anchors.fill: quick_Icon
    }

    Text {
        id: quick_Value
        color: "white"
        text: "0.0°"
        anchors.top: parent.top
        font.pixelSize: 60
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: FontsManager.monospacedFont_Medium.name
    }



    Component.onCompleted: {
        update_Temperature_Unit();
        update_Temperature();
    }


    Connections {
        target: quick_Access_Wheel

        function onQuick_Wheel_Open(state) {
            quick_Wheel_Open = state;
        }
    }

    Connections {
        target: right_Cards_Wheel

        function onCards_Wheel_Open(state) {
            cards_Wheel_Open = state;
        }
    }

    Connections {
        target: HVAC

        function onTemperature_Unit_Changed() {
            update_Temperature_Unit();
        }

        function onDriver_Temperature_Changed() {
            update_Temperature();
        }
    }

    Connections {
        target: STEERING_WHEEL_BUTTONS

        function onButton_Pressed(button_Name) {
            if (!quick_Wheel_Open && !cards_Wheel_Open) {
                if (button_Name === "right_Up") {
                    HVAC.driver_Temperature_Plus();
                }
                else if (button_Name === "right_Down") {
                    HVAC.driver_Temperature_Minus();
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.75}
}
##^##*/
