import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
//IMPORT StyleSheet, FontsManager
import "../"

Item {
    id: alerts_Overlay
    width: 1200
    height: 240

    property int max_Alert_Text_Width: 800

    function display_Alert() {
        let alert_Code = VEHICLE_ALERTS.return_Alert_Code;
        let alert_Header = VEHICLE_ALERTS.return_Alert_Header;
        let alert_Body = VEHICLE_ALERTS.return_Alert_Body;
        let alert_Style = VEHICLE_ALERTS.return_Alert_Style;
        let alert_Priority = VEHICLE_ALERTS.return_Alert_Priority;
        let alert_Custom_Icon = VEHICLE_ALERTS.return_Alert_Custom_Icon;
        let alert_Visible = VEHICLE_ALERTS.return_Alert_Visible;
        let alert_Lifetime = VEHICLE_ALERTS.return_Alert_Lifetime;

        if (!alert_Code) { //If no code alert, return from function
            return;
        }

        //Control alert background
        if (alert_Style === "WARNING_CRITICAL") {
            overlay_Background.color = StyleSheet.notification_Background_Critical;
        }
        else {
            overlay_Background.color = StyleSheet.notification_Background_Regular;
        }

        //Control alert icon
        if (alert_Style === "INFORMATION") {
            alert_Icon.source = "qrc:/icons/alerts/information.svg";
            icon_Color.color = StyleSheet.icon_Info;
        }
        else if (alert_Style === "NOTIFICATION") {
            alert_Icon.source = "qrc:/icons/alerts/warning.svg";
            icon_Color.color = StyleSheet.notification_Icon;
        }
        else if (alert_Style === "WARNING") {
            alert_Icon.source = "qrc:/icons/alerts/warning.svg";
            icon_Color.color = StyleSheet.warning_Icon;
        }
        else if (alert_Style === "WARNING_CRITICAL") {
            alert_Icon.source = "qrc:/icons/alerts/warning.svg";
            icon_Color.color = StyleSheet.critical_Icon_Dark;
        }
        else if (alert_Style === "CUSTOM") {
            alert_Icon.source = alert_Custom_Icon;
            icon_Color.color = "transparent";
        }

        if (alert_Custom_Icon) {
            alert_Icon.source = alert_Custom_Icon;
        }

        //Control alert properties
        alert_Code_Value.text = alert_Code;
        alert_Header_Value.text = alert_Header;
        alert_Body_Value.text = alert_Body;
        alert_Style_Value.text = alert_Style;
        alert_Priority_Value.text = alert_Priority;
        alert_Visible_Value.text = alert_Visible ? "Yes" : "No";
        alert_Visible_Value.color = alert_Visible ? StyleSheet.state_Yes : StyleSheet.state_No;

        if (alert_Container.y > 0) {
            pull_Overlay.start();
        }

        icon_Blinker.restart();
        alert_Watchdog_Timer.interval = alert_Lifetime + 500; //Adding 500 milliseconds to the notification lifetime in case the backend doesn't update the notification in time
        alert_Watchdog_Timer.restart();
    }

    function hide_Alert() {
        if (pull_Overlay.running) {
            pull_Overlay.stop();
        }

        push_Overlay.start();
        alert_Watchdog_Timer.stop();
        icon_Blinker.stop();
    }

    function blink_Icon() {
        let alert_Style = VEHICLE_ALERTS.return_Alert_Style;
        let colorMap = {
            "INFO": [StyleSheet.icon_Info, StyleSheet.icon_Info_Dark],
            "NOTIFICATION": [StyleSheet.notification_Icon, StyleSheet.notification_Icon_Dark],
            "WARNING": [StyleSheet.warning_Icon, StyleSheet.warning_Icon_Dark],
            "WARNING_CRITICAL": [StyleSheet.critical_Icon, StyleSheet.critical_Icon_Dark]
        };

        if (colorMap.hasOwnProperty(alert_Style)) {
            let [currentColor, darkColor] = colorMap[alert_Style];
            icon_Color.color = (icon_Color.color === currentColor) ? darkColor : currentColor;
        }
    }

    function update_DebugMode_State() {
        let debugMode_State = VEHICLE_STATES.get_DebugMode_State;

        alert_Code_Row.visible = debugMode_State;
        alert_Style_Row.visible = debugMode_State;
        alert_Priority_Row.visible = debugMode_State;
        alert_Visible_Row.visible = debugMode_State;
    }

    Item {
        id: alert_Container
        y: parent.y + parent.height //Initially create container retracted
        width: parent.width
        height: parent.height

        Rectangle {
            id: overlay_Background
            height: alert_Row.height > 100 ? alert_Row.height + 40 : 100 //100 - Alert icon (60 pixels) + 40 pixels for borders
            width: alert_Row.width + 60 //60 pixels for borders
            color: StyleSheet.notification_Background_Regular
            opacity: 0.65
            radius: 50 //Default overlay height of 100 pixels divided by 2
            anchors.verticalCenter: alert_Row.verticalCenter
            anchors.horizontalCenter: alert_Row.horizontalCenter
        }

        Row {
            id: alert_Row
            spacing: 15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                id: alert_Icon_Item
                width: 60
                height: 60
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: alert_Icon
                    visible: false
                    asynchronous: true
                    source: "qrc:/icons/alerts/information.svg"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.fill: parent
                }

                ColorOverlay {
                    id: icon_Color
                    source: alert_Icon
                    color: StyleSheet.icon_Info
                    anchors.fill: alert_Icon
                }
            }

            Column {
                id: alert_Column
                spacing: 5
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: alert_Header_Value
                    width: Math.min(implicitWidth, alerts_Overlay.max_Alert_Text_Width)
                    wrapMode: Text.WordWrap
                    color: StyleSheet.regular_Text
                    text: "?"
                    font.pixelSize: 26
                    font.family: FontsManager.systemFont_Medium.name
                }

                Text {
                    id: alert_Body_Value
                    width: Math.min(implicitWidth, alerts_Overlay.max_Alert_Text_Width)
                    wrapMode: Text.WordWrap
                    color: StyleSheet.special_Text
                    text: "?"
                    font.pixelSize: 22
                    font.family: FontsManager.systemFont_Medium.name
                }

                Row {
                    id: alert_Code_Row
                    spacing: 5

                    Text {
                        id: alert_Code_Name
                        text: "Code:"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }

                    Text {
                        id: alert_Code_Value
                        text: "?"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }
                }

                Row {
                    id: alert_Style_Row
                    spacing: 5

                    Text {
                        id: alert_Style_Name
                        text: "Style:"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }

                    Text {
                        id: alert_Style_Value
                        text: "?"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }
                }

                Row {
                    id: alert_Priority_Row
                    spacing: 5

                    Text {
                        id: alert_Priority_Name
                        text: "Priority:"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }

                    Text {
                        id: alert_Priority_Value
                        text: "?"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }
                }

                Row {
                    id: alert_Visible_Row
                    spacing: 5

                    Text {
                        id: alert_Visible_Name
                        text: "Customer visible:"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }

                    Text {
                        id: alert_Visible_Value
                        text: "?"
                        color: StyleSheet.regular_Text
                        font.pixelSize: 22
                        font.family: FontsManager.systemFont_Medium.name
                    }
                }
            }
        }
    }



    NumberAnimation {
        id: pull_Overlay; target: alert_Container; property: "y"; from: parent.y + parent.height; to: 0.0; duration: 500; easing.type: Easing.OutExpo
    }


    NumberAnimation {
        id: push_Overlay; target: alert_Container; property: "y"; from: parent.y; to: parent.y + parent.height; duration: 350; easing.type: Easing.InExpo
    }



    Timer {
        id: alert_Watchdog_Timer //The timer is used to prevent the notification from getting stuck on the screen if for some reason the backend did not clear the notification
        interval: 5500
        onTriggered: hide_Alert()
    }



    Timer {
        id: icon_Blinker
        interval: 500
        repeat: true
        onTriggered: blink_Icon()
    }



    Component.onCompleted: {
        display_Alert();
        update_DebugMode_State();
    }



    Connections {
        target: VEHICLE_ALERTS
        function onNew_Alert() {
            display_Alert();
        }

        function onHide_Alert() {
            hide_Alert();
        }
    }

    Connections {
        target: VEHICLE_STATES

        function onDebugMode_State_Changed() {
            update_DebugMode_State();
        }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
