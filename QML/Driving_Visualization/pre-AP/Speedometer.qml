import QtQuick
import Qt5Compat.GraphicalEffects

//IMPORT gauge components
import "../../Components"
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 650
    height: 650

    property string gauge_View: "speedometer"
    property bool gauge_View_Changing: false
    property int gauge_Step_Size: 200
    property int gauge_Tickmark_Step_Size: 100
    property int gauge_Tickmark_Label_Divider: 10
    property int gauge_Tickmark_Font_Size: 24
    property double gauge_Label_Inset_Divider: 3

    function update_Gauge_View() {
        gauge_View = APPEARANCE.get_GaugeView_Mode;

        renew_Gauge_View.start();
    }

    function update_Speed_Value() {
        if (gauge_View == "speedometer") {
            if (update_Gauge_Speed.running) {
                update_Gauge_Speed.restart();
            }
            else {
                update_Gauge_Speed.start();
            }
        }
    }

    function update_RPM_Value() {
        if (gauge_View == "tachometer") {
            if (update_Gauge_RPM.running) {
                update_Gauge_RPM.restart();
            }
            else {
                update_Gauge_RPM.start();
            }
        }
    }

    function update_Distance_Unit() {
        let distance_Unit = VEHICLE_DATA.get_Distance_Unit;

        if (distance_Unit === "kilometers") {
            odometer_Unit.text = "km";
        }
        else if (distance_Unit === "miles") {
            odometer_Unit.text = "mi";
        }
    }

    function update_Speed_Unit() {
        if (gauge_View == "speedometer") {
            let speed_Unit = POWERTRAIN.get_Speed_Unit;

            speedometer_Gauge.setValue = 0;

            if (speed_Unit === "kph") {
                speedometer_Gauge.maximumValue = 2600;
            }
            else if (speed_Unit === "mph") {
                speedometer_Gauge.maximumValue = 1600;
            }
        }
    }

    function change_Gauge_View() {
        if (gauge_View == "speedometer") {
            gauge_Step_Size = 200;
            gauge_Tickmark_Step_Size = 100;
            gauge_Tickmark_Label_Divider = 10;
            gauge_Tickmark_Font_Size = 26;
            gauge_Label_Inset_Divider = 3;
            rpm_Multiplier_Note.visible = false;
            update_Speed_Unit(); //Force update speed unit
            update_Speed_Value(); //Force update vehicle speed
        }
        else if (gauge_View == "tachometer") {
            speedometer_Gauge.maximumValue = 8000;
            gauge_Step_Size = 1000;
            gauge_Tickmark_Step_Size = 250;
            gauge_Tickmark_Label_Divider = 1000;
            gauge_Tickmark_Font_Size = 32;
            gauge_Label_Inset_Divider = 3.3;
            rpm_Multiplier_Note.visible = true;
            update_RPM_Value(); //Force update engine RPM
        }

        show_Gauge.start();
    }

    function control_Tickmark_Color(value) {
        if (value > 6500 && gauge_View == "tachometer") {
            return StyleSheet.tachometer_RedZone
        }
        else {
            if (value % 200 == 0) {
                return StyleSheet.speedometer_TickMark
            }
            else {
                return StyleSheet.speedometer_MinorTickMark
            }
        }
    }

    function update_Odometer_Value() {
        let odometer = VEHICLE_DATA.get_Odometer_Value.toFixed(1);
        let odometer_Text = String(odometer).replace(/(\d)(?=(\d{3})+([^\d]|$))/g, '$1,');

        odometer_Value.text = odometer_Text;
    }

    function update_Ignition_State() {
        let ignition_State = VEHICLE_STATES.get_Ignition_State;

        if (ignition_State) {
            adas_Loading_Timer.start();
        }
        else {
            adas_Loading_Timer.stop();
            show_Adas_View.stop();
            adas_View.opacity = 0.0;
        }
    }



    Image {
        id: gauge_Island_Background
        source: AssetsManager.speedometer_Island
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    ADAS_View {
        id: adas_View
        opacity: 0.0
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Image {
        id: gauge_Background
        source: AssetsManager.speedometer_Body
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: rpm_Multiplier_Note
        visible: false
        color: StyleSheet.speedometer_Unit
        text: "RPM X1000"
        anchors.top: parent.top
        font.pixelSize: 18
        anchors.topMargin: 120
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
        font.family: FontsManager.systemFont_Medium.name
    }

    Gauge {
        id: speedometer_Gauge
        anchors.fill: parent
        opacity: 1.0

        minimumValue: 0
        maximumValue: 2600

        minimumValueAngle: -150
        maximumValueAngle: 149

        labelStepSize: gauge_Step_Size
        tickmarkStepSize: gauge_Tickmark_Step_Size
        labelInset: outerRadius / gauge_Label_Inset_Divider
        tickmarkInset: outerRadius / 5.9

        needle: Rectangle {
            y: -162
            visible: speedometer_Gauge.displayValue > 0 ? true : false
            implicitWidth: 5
            implicitHeight: 123
            antialiasing: true
            color: StyleSheet.speedometer_Needle
        }

        tickmarkLabel:  Text {
            visible: styleData.value !== speedometer_Gauge.minimumValue && styleData.value !== speedometer_Gauge.maximumValue ? true : false
            font.pixelSize: gauge_Tickmark_Font_Size
            text: styleData.value / gauge_Tickmark_Label_Divider
            color: StyleSheet.speedometer_Value
            antialiasing: true
            font.family: FontsManager.systemFont_Medium.name
        }

        background: Canvas {
            property real value: speedometer_Gauge.displayValue
            property real outer_Radius: speedometer_Gauge.outerRadius

            visible: value > 0 ? true : false
            anchors.fill: parent
            onValueChanged: requestPaint()

            function degreesToRadians(degrees) {
                return degrees * (Math.PI / 180);
            }

            onPaint: {
                let ctx = getContext("2d");
                ctx.reset();
                ctx.beginPath();
                let gradient = ctx.createRadialGradient(outer_Radius, outer_Radius, outer_Radius * 0.75, outer_Radius, outer_Radius, outer_Radius * 0.9);
                gradient.addColorStop(0.0, StyleSheet.speedometer_Needle);
                gradient.addColorStop(0.59, StyleSheet.speedometer_Needle);
                gradient.addColorStop(0.69, Qt.darker(StyleSheet.speedometer_Needle, 1.5)); //Gradient center
                gradient.addColorStop(0.79, StyleSheet.speedometer_Needle);
                gradient.addColorStop(1.0, StyleSheet.speedometer_Needle);
                ctx.strokeStyle = gradient;
                ctx.lineWidth = 15;
                ctx.arc(outer_Radius,
                        outer_Radius,
                        outer_Radius / 1.171,
                        degreesToRadians(speedometer_Gauge.valueToAngle(speedometer_Gauge.minimumValue) - 90.6),
                        degreesToRadians(speedometer_Gauge.valueToAngle(speedometer_Gauge.displayValue) - 90));
                ctx.stroke();
            }
        }

        tickmark: Rectangle {
            visible: styleData.value !== speedometer_Gauge.minimumValue && styleData.value !== speedometer_Gauge.maximumValue ? true : false
            implicitWidth: styleData.value % 200 == 0 ? 6 : 4
            implicitHeight: 12
            antialiasing: true
            smooth: true
            color: control_Tickmark_Color(styleData.value)
        }
    }

    Item {
        id: speedometer_Body
        width: 620
        height: 620
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Speedometer_Island {
            id: speedometer_Island
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: odometer_Container
            width: 200
            height: 70
            anchors.top: speedometer_Island.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                id: odometer_Value
                color: StyleSheet.speedometer_Value
                text: "------"
                anchors.top: parent.top
                font.pixelSize: 28
                anchors.topMargin: 0
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.family: FontsManager.monospacedFont_Bold.name
            }

            Text {
                id: odometer_Unit
                color: StyleSheet.speedometer_Unit
                text: "km"
                anchors.top: odometer_Value.bottom
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 22
                font.family: FontsManager.systemFont_Medium.name
            }
        }
    }

    Cruise_Gauge {
        id: cruise_Gauge
        visible: gauge_View == "speedometer" ? true : false
    }



    NumberAnimation { id: update_Gauge_Speed; target: speedometer_Gauge; property: "setValue"; from: speedometer_Gauge.displayValue; to: POWERTRAIN.get_Vehicle_Speed_Value * 10; duration: 500 }

    NumberAnimation { id: update_Gauge_RPM; target: speedometer_Gauge; property: "setValue"; from: speedometer_Gauge.displayValue; to: POWERTRAIN.get_Engine_RPM; duration: 150 }

    NumberAnimation { id: renew_Gauge_View; target: speedometer_Gauge; property: "opacity"; from: 1.0; to: 0.0; duration: 250; onFinished: change_Gauge_View() }

    NumberAnimation { id: show_Gauge; target: speedometer_Gauge; property: "opacity"; from: 0.0; to: 1.0; duration: 250 }

    NumberAnimation { id: show_Adas_View; target: adas_View; property: "opacity"; from: 0.0; to: 1.0; duration: 250 }



    Timer {
        id: adas_Loading_Timer
        interval: 1000
        onTriggered: {
            show_Adas_View.start();
        }
    }



    Component.onCompleted: {
        update_Distance_Unit();
        update_Speed_Unit();
        update_Gauge_View();
        update_Odometer_Value();
        update_Ignition_State();

        if (!gauge_View_Changing) {
            update_Speed_Value();
        }

        if (!gauge_View_Changing) {
            update_RPM_Value();
        }
    }



    Connections {
        target: VEHICLE_STATES

        function onIgnition_State_Changed() {
            update_Ignition_State();
        }
    }

    Connections {
        target: POWERTRAIN
        function onVehicle_Speed_Changed() {
            if (!gauge_View_Changing) {
                update_Speed_Value();
            }
        }

        function onEngine_RPM_Changed() {
            if (!gauge_View_Changing) {
                update_RPM_Value();
            }
        }

        function onSpeed_Unit_Changed() {
            update_Speed_Unit();
        }
    }

    Connections {
        target: VEHICLE_DATA

        function onOdometer_Value_Changed() {
            update_Odometer_Value();
        }

        function onDistance_Unit_Changed() {
            update_Distance_Unit();
        }
    }

    Connections {
        target: APPEARANCE

        function onGauge_View_Changed() {
            update_Gauge_View();
        }
    }
}


