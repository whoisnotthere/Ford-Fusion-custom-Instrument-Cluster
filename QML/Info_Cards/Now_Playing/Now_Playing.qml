import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    id: item1
    width: 660
    height: 720

    function millis_To_Time(millis) {
        let minutes = Math.floor(millis / 60000);
        let seconds = ((millis % 60000) / 1000).toFixed(0);

        return (seconds == 60 ? (minutes + 1) + ":00" : minutes + ":" + (seconds < 10 ? "0" : "") + seconds);
    }

    function update_Media_Data() {
        source_Name.text = NOW_PLAYING.return_Source_Name;
        metadata_Field_1.text = NOW_PLAYING.return_Media_Field_1;
        metadata_Field_2.text = NOW_PLAYING.return_Media_Field_2;
        metadata_Field_3.text = NOW_PLAYING.return_Media_Field_3;

        album_Cover.source = "qrc:/images/media/now_Playing_No_Image.png"; //Set image source to placeholder to force update image
        album_Cover.source = NOW_PLAYING.return_Album_Cover_URL;
    }

    function update_Media_Progress() {
        let duration = NOW_PLAYING.return_Media_Duration;
        let progress = NOW_PLAYING.return_Media_Progress;

        song_Time_Duration.text = millis_To_Time(duration);
        song_Time_Progress.text = millis_To_Time(progress);
        song_Progress_Bar.to = duration;
        song_Progress_Bar.value = progress;

        song_Progress.visible = duration > 0 ? true : false;
    }

    function update_Pause_State() {
        media_Paused.visible = NOW_PLAYING.return_Pause_State;
    }

    function update_Muted_State() {
        let volume = NOW_PLAYING.return_Volume;
        sound_Muted.visible = volume === 0 ? true : false;
    }



    Column {
        id: now_Playing_Info
        spacing: 10
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: source_Name
            width: Math.min(implicitWidth, 380)
            color: StyleSheet.special_Text
            text: "No Media Data"
            elide: Text.ElideRight
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            font.family: FontsManager.systemFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: album_Cover_Item
            width: 250
            height: 250
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                id: album_Cover
                width: 250
                height: 250
                visible: false
                source: "qrc:/images/media/now_Playing_No_Image.png"
                asynchronous: true
                retainWhileLoading: true
                cache: false
                onStatusChanged: {
                    if (album_Cover.status == Image.Null || album_Cover.status == Image.Error) {
                        album_Cover.source = "qrc:/images/media/now_Playing_No_Image.png";
                    }
                }
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                id: album_Cover_Mask
                radius: 15
                smooth: true
                visible: false
                anchors.fill: album_Cover
            }

            OpacityMask {
                id: album_Cover_Opacity_Mask
                visible: false
                source: album_Cover
                maskSource: album_Cover_Mask
                anchors.fill: album_Cover
            }

            DropShadow {
                id: album_Cover_Shadow
                source: album_Cover_Opacity_Mask
                color: StyleSheet.mediaCover_Shadow
                horizontalOffset: 8
                verticalOffset: 8
                radius: 8
                smooth: true
                anchors.fill: album_Cover_Opacity_Mask
            }

            Image {
                id: sound_Muted
                visible: false
                width: 65
                height: 65
                asynchronous: true
                mipmap: true
                source: "qrc:/icons/media/sound_Muted.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: -sound_Muted.paintedWidth / 2
            }

            Rectangle {
                id: media_Paused
                width: 125
                height: 125
                visible: false
                color: StyleSheet.overlay_Background_Regular
                radius: 15
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: paused_Icon
                    width: 125
                    height: 50
                    asynchronous: true
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/icons/media/media_Paused.svg"
                    fillMode: Image.PreserveAspectFit
                }

                ColorOverlay {
                    source: paused_Icon
                    color: StyleSheet.overlay_Icon
                    anchors.fill: paused_Icon
                }
            }
        }

        Text {
            id: metadata_Field_1
            width: Math.min(implicitWidth, 480)
            color: StyleSheet.regular_Text
            text: "No Media Data"
            elide: Text.ElideRight
            font.pixelSize: 26
            horizontalAlignment: Text.AlignHCenter
            font.family: FontsManager.systemFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: metadata_Field_2
            width: Math.min(implicitWidth, 380)
            color: StyleSheet.special_Text
            text: ""
            elide: Text.ElideRight
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            font.family: FontsManager.systemFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: metadata_Field_3
            width: Math.min(implicitWidth, 380)
            color: StyleSheet.special_Text
            text: ""
            elide: Text.ElideRight
            font.pixelSize: 22
            horizontalAlignment: Text.AlignHCenter
            font.family: FontsManager.systemFont_Medium.name
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            id: song_Progress
            width: 300
            height: 50
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter

            ProgressBar {
                id: song_Progress_Bar
                width: song_Progress.width
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                to: 0
                value: 0

                background: Rectangle {
                    implicitWidth: 5
                    implicitHeight: 5
                    color: StyleSheet.progress_Background
                    radius: 3
                }

                contentItem: Item {
                    Rectangle {
                        width: song_Progress_Bar.visualPosition * song_Progress_Bar.width
                        height: song_Progress_Bar.height
                        radius: 3
                        color: StyleSheet.progress_Completed
                    }
                }
            }

            Text {
                id: song_Time_Progress
                color: StyleSheet.special_Text
                text: ""
                anchors.left: parent.left
                anchors.top: song_Progress_Bar.bottom
                font.pixelSize: 22
                font.family: FontsManager.monospacedFont_Medium.name
                anchors.topMargin: 5
                anchors.leftMargin: 0
            }

            Text {
                id: song_Time_Duration
                color: StyleSheet.special_Text
                text: ""
                anchors.right: parent.right
                anchors.top: song_Progress_Bar.bottom
                font.pixelSize: 22
                horizontalAlignment: Text.AlignRight
                font.family: FontsManager.monospacedFont_Medium.name
                anchors.topMargin: 5
                anchors.rightMargin: 0
            }
        }
    }



    Component.onCompleted: {
        update_Media_Data();
        update_Media_Progress();
        update_Pause_State();
        update_Muted_State();
    }



    Connections {
        target: NOW_PLAYING

        function onMedia_Data_Changed() {
            update_Media_Data();
        }

        function onMedia_Time_Changed() {
            update_Media_Progress();
        }

        function onPause_State_Changed() {
            update_Pause_State();
        }

        function onVolume_Changed() {
            update_Muted_State();
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.9}
}
##^##*/
