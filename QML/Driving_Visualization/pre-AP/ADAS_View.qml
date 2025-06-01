import QtQuick

//IMPORT gauge components
import "../../Vehicle_Model"
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 330
    height: 330

    property bool blink_State: false
    property bool overspeed_Blink: false
    property bool overspeed_Special_Blink: false

    function update_Speed_Restriction_State() {
        let state = PRE_AP.get_Speed_Restriction_State;

        if (state) {
            speed_Limit_Sign_Container.opacity = 1.0;
        }
        else {
            speed_Limit_Sign_Container.opacity = 0.0;
        }
    }

    function update_Speed_Special_Restriction_State() {
        let state = PRE_AP.get_Speed_Special_Restriction_State;

        if (state) {
            speed_Special_Limit_Sign_Container.opacity = 1.0;
        }
        else {
            speed_Special_Limit_Sign_Container.opacity = 0.0;
        }
    }

    function update_Overtaking_Prohibiting_State() {
        let state = PRE_AP.get_Overtaking_Prohibited_State;

        if (state) {
            overtaking_Prohibited_Sign_Container.opacity = 1.0;
        }
        else {
            overtaking_Prohibited_Sign_Container.opacity = 0.0;
        }
    }

    function update_Speed_Restriction_Value() {
        let value = PRE_AP.get_Speed_Restriction;

        if (value > 0) {
            speed_Limit_Sign.source = "qrc:/images/adas/signs/speed_Sign.png";
            limit_Value.visible = true;
            limit_Value.text = value;
        }
        else {
            speed_Limit_Sign.source = "qrc:/images/adas/signs/no_Restrictions.png";
            limit_Value.visible = false;
        }
    }

    function update_Speed_Special_Restriction_Value() {
        let value = PRE_AP.get_Speed_Special_Restriction;

        limit_Special_Value.text = value;
    }

    function process_Restriction_Overspeed() {
        overspeed_Timer.restart();
        overspeed_Blink = true;
        control_Signs_Blinks();
    }

    function process_Restriction_Special_Overspeed() {
        overspeed_Special_Timer.restart();
        overspeed_Special_Blink = true;
        control_Signs_Blinks();
    }

    function control_Signs_Blinks() {
        blinks_Generator_Timer.start();

        if (overspeed_Blink) {
            if (blink_State) {
                speed_Limit_Sign.opacity = 0.7;
            }
            else {
                speed_Limit_Sign.opacity = 1.0;
            }
        }

        if (overspeed_Special_Blink) {
            if (blink_State) {
                speed_Special_Limit_Sign.opacity = 0.7;
            }
            else {
                speed_Special_Limit_Sign.opacity = 1.0;
            }
        }

        if (!overspeed_Blink && !overspeed_Special_Blink) {
            blinks_Generator_Timer.stop();
        }
    }



    Back_View_Model {
        id: back_View_Model
        width: 330
        height: 330
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }



    Column {
        id: left_Signs_Column
        width: 60
        height: 150
        anchors.left: parent.left
        anchors.top: parent.top
        spacing: 10
        anchors.topMargin: 90
        anchors.leftMargin: 25

        Item {
            id: speed_Limit_Sign_Container
            opacity: 1.0
            width: 60
            height: 60

            Image {
                id: speed_Limit_Sign
                opacity: 1.0
                source: "qrc:/images/adas/signs/speed_Sign.png"
                asynchronous: true
                mipmap: true
                fillMode: Image.PreserveAspectFit
                anchors.fill: parent

                Text {
                    id: limit_Value
                    text: "0"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: FontsManager.monospacedFont_Bold.name
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }

        Item {
            id: speed_Special_Limit_Sign_Container
            opacity: 1.0
            width: 60
            height: 60

            Image {
                id: speed_Special_Limit_Sign
                opacity: 1.0
                width: 60
                height: 60
                source: "qrc:/images/adas/signs/speed_Special_Sign.png"
                asynchronous: true
                mipmap: true
                fillMode: Image.PreserveAspectFit

                Text {
                    id: limit_Special_Value
                    text: "0"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 20
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: FontsManager.monospacedFont_Bold.name
                }
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }

    Column {
        id: right_Signs_Column
        width: 60
        height: 150
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: 10
        anchors.rightMargin: 25
        anchors.topMargin: 90

        Item {
            id: overtaking_Prohibited_Sign_Container
            opacity: 1.0
            width: 60
            height: 60

            Image {
                id: overtaking_Prohibited_Sign
                width: 60
                height: 60
                source: "qrc:/images/adas/signs/no_Overtaking.png"
                asynchronous: true
                mipmap: true
                fillMode: Image.PreserveAspectFit
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }



    Timer {
        id: blinks_Generator_Timer
        interval: 500
        repeat: true
        onTriggered: {
            blink_State = !blink_State;
            control_Signs_Blinks();
        }
    }

    Timer {
        id: overspeed_Timer
        interval: 5000
        onTriggered: {
            overspeed_Blink = false;
            speed_Limit_Sign.opacity = 1.0;
        }
    }

    Timer {
        id: overspeed_Special_Timer
        interval: 5000
        onTriggered: {
            overspeed_Special_Blink = false;
            speed_Special_Limit_Sign.opacity = 1.0;
        }
    }



    Component.onCompleted: {
        update_Speed_Restriction_State();
        update_Speed_Special_Restriction_State();
        update_Overtaking_Prohibiting_State();
        update_Speed_Restriction_Value();
        update_Speed_Special_Restriction_Value();
    }

    Connections {
        target: PRE_AP

        function onSpeed_Restriction_State_Changed() {
            update_Speed_Restriction_State();
        }

        function onSpeed_Special_Restriction_State_Changed() {
            update_Speed_Special_Restriction_State();
        }

        function onOvertaking_Prohibiting_State_Changed() {
            update_Overtaking_Prohibiting_State();
        }

        function onSpeed_Restriction_Changed() {
            update_Speed_Restriction_Value();
        }

        function onSpeed_Special_Restriction_Changed() {
            update_Speed_Special_Restriction_Value();
        }

        function onRestriction_Overspeed() {
            process_Restriction_Overspeed();
        }

        function onRestriction_Overspeed_Ended() {
            overspeed_Timer.stop();
            overspeed_Blink = false;
            speed_Limit_Sign.opacity = 1.0;
        }

        function onRestriction_Special_Overspeed() {
            process_Restriction_Special_Overspeed();
        }

        function onRestriction_Special_Overspeed_Ended() {
            overspeed_Special_Timer.stop();
            overspeed_Special_Blink = false;
            speed_Special_Limit_Sign.opacity = 1.0;
        }
    }
}
