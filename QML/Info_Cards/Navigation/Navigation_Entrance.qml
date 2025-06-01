import QtQuick
import QtMultimedia
//IMPORT StyleSheet, FontsManager
import "../../"

Item {
    width: 660
    height: 720
	
	Video {
		id: map_Stream
		autoPlay: true
		source: "udp://192.168.1.150:8050"
		fillMode: VideoOutput.PreserveAspectFit
		anchors.fill: parent
	}
}
