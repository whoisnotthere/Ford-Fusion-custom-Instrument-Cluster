pragma Singleton
import QtQuick

Item {
    //SYSTEM FONT
    readonly property var systemFont_Light: FontLoader {
        source: "qrc:/fonts/gotham/Gotham-Light.otf"
    }

    readonly property var systemFont_Regular: FontLoader {
        source: "qrc:/fonts/gotham/Gotham-Book.otf"
    }

    readonly property var systemFont_Medium: FontLoader {
        source: "qrc:/fonts/gotham/Gotham-Medium.otf"
    }

    readonly property var systemFont_Bold: FontLoader {
        source: "qrc:/fonts/gotham/Gotham-Bold.otf"
    }

    //MONOSPACED FONT
    readonly property var monospacedFont_Light: FontLoader {
        source: "qrc:/fonts/roboto/Roboto-Light.ttf"
    }

    readonly property var monospacedFont_Regular: FontLoader {
        source: "qrc:/fonts/roboto/Roboto-Regular.ttf"
    }

    readonly property var monospacedFont_Medium: FontLoader {
        source: "qrc:/fonts/roboto/Roboto-Medium.ttf"
    }

    readonly property var monospacedFont_Bold: FontLoader {
        source: "qrc:/fonts/roboto/Roboto-Bold.ttf"
    }
}
