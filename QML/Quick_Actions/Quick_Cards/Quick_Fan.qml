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



    function update_Fan_Speed() {
        let fan_Speed = HVAC.get_Display_Fan_Speed;

        if (fan_Speed !== "off" && fan_Speed !== "auto") {
            quick_Value.text = fan_Speed;
            quick_Slider.value = fan_Speed;
        }
        else {
            if (fan_Speed === "off") {
                quick_Value.text = "OFF";
            }
            else if (fan_Speed === "auto") {
                quick_Value.text = "AUTO";
            }
        }

        if (fan_Speed === "off" || fan_Speed === "auto") {
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
        text: "Fan speed"
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
        to: 7.0
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
        source: "qrc:/icons/quick_Access/fan.svg"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 35
    }

    ColorOverlay {
        source: quick_Icon
        color: StyleSheet.overlay_Icon
        anchors.fill: quick_Icon
    }

    Text {
        id: quick_Value
        color: "white"
        text: "0"
        anchors.top: parent.top
        font.pixelSize: 60
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: FontsManager.monospacedFont_Medium.name
    }



    Component.onCompleted: {
        update_Fan_Speed();
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

        function onFan_Speed_Changed() {
            update_Fan_Speed();
        }
    }

    Connections {
        target: STEERING_WHEEL_BUTTONS

        function onButton_Pressed(button_Name) {
            if (!quick_Wheel_Open && !cards_Wheel_Open) {
                if (button_Name === "right_Up") {
                    HVAC.fan_Speed_Plus();
                }
                else if (button_Name === "right_Down") {
                    HVAC.fan_Speed_Minus();
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
