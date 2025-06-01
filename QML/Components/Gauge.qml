import QtQml
import QtQuick

Item {
    id: gauge

    readonly property real angle_Range: maximumValueAngle - minimumValueAngle

    readonly property real outerRadius: Math.min(gauge.width, gauge.height) * 0.5

    readonly property int labelCount: (maximumValue - minimumValue) / labelStepSize + 1

    readonly property real labelSectionSize: rangeUsed(labelCount, labelStepSize) / (labelCount - 1)

    readonly property real tickmarkCount: tickmarkStepSize > 0 ? (maximumValue - minimumValue) / tickmarkStepSize + 1 : 0

    readonly property real tickmarkSectionSize: rangeUsed(tickmarkCount, tickmarkStepSize) / (tickmarkCount - 1)

    readonly property real tickmarkSectionValue: (maximumValue - minimumValue) / (tickmarkCount - 1)

    readonly property real needle_Rotation: {
        var percentage = (gauge.displayValue - gauge.minimumValue) / (gauge.maximumValue - gauge.minimumValue);
        minimumValueAngle + percentage * angle_Range;
    }

    //VALUES
    property real maximumValue: 0
    property real minimumValue: 0
    property real setValue: 0
    property real displayValue: 0

    onSetValueChanged: {
        if (setValue <= maximumValue && setValue >= minimumValue) {
            displayValue = setValue;
        }
        else {
            if (setValue > maximumValue) {
                displayValue = maximumValue;
            }
            else if (setValue < minimumValue) {
                displayValue = minimumValue;
            }
        }
    }

    //ANGLES
    property real maximumValueAngle: 145
    property real minimumValueAngle: -145

    //TICKMARK
    property real tickmarkStepSize: 10
    property real tickmarkInset: 0

    //LABELS
    property real labelStepSize: tickmarkStepSize
    property real labelInset: outerRadius / 2.6



    function rangeUsed(count, stepSize) {
        return (((count - 1) * stepSize) / (maximumValue - minimumValue)) * angle_Range;
    }

    function valueToAngle(value) {
        let normalised = (value - minimumValue) / (maximumValue - minimumValue);
        return (maximumValueAngle - minimumValueAngle) * normalised + minimumValueAngle;
    }

    function labelAngleFromIndex(labelIndex) {
        return labelIndex * labelSectionSize + minimumValueAngle;
    }

    function centerAlongCircle(xCenter, yCenter, width, height, angleOnCircle, distanceAlongRadius) {
        let x = (xCenter - width / 2) + (distanceAlongRadius * Math.cos(angleOnCircle));
        let y = (yCenter - height / 2) + (distanceAlongRadius * Math.sin(angleOnCircle));

        return [x, y];
    }

    function degToRadOffset(degrees) {
      return (degrees - 90) * Math.PI / 180;
    }

    function labelPosFromIndex(index, labelWidth, labelHeight) {
        return centerAlongCircle(outerRadius, outerRadius, labelWidth, labelHeight, degToRadOffset(labelAngleFromIndex(index)), outerRadius - labelInset)
    }

    function tickmarkAngleFromIndex(tickmarkIndex) {
        return tickmarkIndex * tickmarkSectionSize + minimumValueAngle;
    }

    function tickmarkValueFromIndex(majorIndex) {
        return (majorIndex * tickmarkSectionValue) + minimumValue;
    }

    function radToDeg(radians) {
      return (180 / Math.PI) * radians;
    }



    property Component background

    property Component needle

    property Component tickmark

    property Component tickmarkLabel



    Loader {
        id: backgroundLoader
        sourceComponent: background
        width: outerRadius * 2
        height: outerRadius * 2
        anchors.centerIn: parent
    }

    Loader {
        id: tickMarkLoader
        active: tickmark != null
        width: outerRadius * 2
        height: outerRadius * 2
        anchors.centerIn: parent

        sourceComponent: Repeater {
            id: tickmarkRepeater
            model: tickmarkCount
            delegate: Loader {
                id: tickmarkLoader
                objectName: "tickmark" + styleData.index
                x: tickmarkRepeater.width / 2
                y: tickmarkRepeater.height / 2

                transform: [
                    Translate {
                        y: -outerRadius + tickmarkInset
                    },
                    Rotation {
                        angle: tickmarkAngleFromIndex(styleData.index) - __tickmarkWidthAsAngle / 2
                    }
                ]

                sourceComponent: tickmark

                property int __index: index
                property QtObject styleData: QtObject {
                    readonly property alias index: tickmarkLoader.__index
                    readonly property real value: tickmarkValueFromIndex(index)
                }

                readonly property real __tickmarkWidthAsAngle: radToDeg((width / (1.57079632679489661923 * outerRadius)) * 1.57079632679489661923)
            }
        }
    }

    Loader {
        id: labelLoader
        active: tickmarkLabel != null
        width: outerRadius * 2
        height: outerRadius * 2
        anchors.centerIn: parent

        sourceComponent: Item {
            id: labelItem
            width: outerRadius * 2
            height: outerRadius * 2
            anchors.centerIn: parent

            Connections {
                target: gauge
                function onMinimumValueChanged() {
                    valueTextModel.update()
                }
                function onMaximumValueChanged() {
                    valueTextModel.update()
                }
                function onTickmarkStepSizeChanged() {
                    valueTextModel.update()
                }
                function onLabelStepSizeChanged() {
                    valueTextModel.update()
                }
            }

            Repeater {
                id: labelItemRepeater

                Component.onCompleted: valueTextModel.update();

                model: ListModel {
                    id: valueTextModel

                    function update() {
                        if (gauge.labelStepSize === 0) {
                            return;
                        }

                        // Make bigger if it's too small and vice versa.
                        // +1 because we want to show 11 values, with, for example: 0, 10, 20... 100.
                        var difference = gauge.labelCount - count;
                        if (difference > 0) {
                            for (; difference > 0; --difference) {
                                append({ value: 0 });
                            }
                        } else if (difference < 0) {
                            for (; difference < 0; ++difference) {
                                remove(count - 1);
                            }
                        }

                        var index = 0;
                        for (var value = gauge.minimumValue;
                             value <= gauge.maximumValue && index < count;
                             value += gauge.labelStepSize, ++index) {
                            setProperty(index, "value", value);
                        }
                    }
                }
                delegate: Loader {
                    id: tickmarkLabelDelegateLoader
                    objectName: "labelDelegateLoader" + index
                    sourceComponent: tickmarkLabel
                    x: pos.x
                    y: pos.y

                    readonly property point pos: Qt.point(labelPosFromIndex(index, width, height)[0], labelPosFromIndex(index, width, height)[1]);

                    readonly property int _index: index
                    readonly property real _value: value
                    property QtObject styleData: QtObject {
                        readonly property var value: index != -1 ? tickmarkLabelDelegateLoader._value : 0
                        readonly property alias index: tickmarkLabelDelegateLoader._index
                    }
                }
            }
        }
    }

    Loader {
        id: needle_Loader
        sourceComponent: needle
        transform: [
            Rotation {
                angle: needle_Rotation
                origin.x: needle_Loader.width / 2
                origin.y: needle_Loader.height
            },
            Translate {
                x: gauge.width / 2 - needle_Loader.width / 2
                y: gauge.height / 2 - needle_Loader.height
            }
        ]
    }
}
