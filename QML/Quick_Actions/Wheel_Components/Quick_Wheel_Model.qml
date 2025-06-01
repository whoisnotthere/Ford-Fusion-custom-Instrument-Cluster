import QtQuick

ListModel {
    id: quick_Wheel_Model
    ListElement {
        quick_Key: "HVAC_Temperature"
        quick_Name: "Temperature"
        quick_Icon: "qrc:/icons/quick_Access/temperature.svg"
    }

    ListElement {
        quick_Key: "HVAC_FanSpeed"
        quick_Name: "Fan speed"
        quick_Icon: "qrc:/icons/quick_Access/fan.svg"
    }

    ListElement {
        quick_Key: "display_Brightness"
        quick_Name: "Display brightness"
        quick_Icon: "qrc:/icons/quick_Access/brightness.svg"
    }

    ListElement {
        quick_Key: "recent_Calls"
        quick_Name: "Recent calls"
        quick_Icon: "qrc:/icons/quick_Access/phone.svg"
    }

    ListElement {
        quick_Key: "contacts"
        quick_Name: "Contacts"
        quick_Icon: "qrc:/icons/quick_Access/phone.svg"
    }

    ListElement {
        quick_Key: ""
        quick_Name: ""
        quick_Icon: ""
    }

    ListElement {
        quick_Key: ""
        quick_Name: ""
        quick_Icon: ""
    }
}
