#include "body.h"

Body::Body(QObject *parent) : QObject{parent} {

}



void Body::process_Data(QJsonObject &data) {
    QJsonObject JSON_Lights = data["lights_Status"].toObject();
    bool drl = JSON_Lights["DRL"].toBool();
    if (_GTW_DRL != drl) {
        _GTW_DRL = drl;
        emit drl_State_Changed();
    }

    bool parkingLights = JSON_Lights["parking"].toBool();
    if (_GTW_Parking_Lights != parkingLights) {
        _GTW_Parking_Lights = parkingLights;
        emit parking_Lights_State_Changed();
    }

    bool lowBeam = JSON_Lights["low_Beam"].toBool();
    if (_GTW_Low_Beam != lowBeam) {
        _GTW_Low_Beam = lowBeam;
        emit low_Beam_State_Changed();
    }

    bool highBeam = JSON_Lights["high_Beam"].toBool();
    if (_GTW_High_Beam != highBeam) {
        _GTW_High_Beam = highBeam;
        emit high_Beam_State_Changed();
    }

    bool fogLights = JSON_Lights["fog"].toBool();
    if (_GTW_Fog_Lights != fogLights) {
        _GTW_Fog_Lights = fogLights;
        emit fog_Lights_State_Changed();
    }

    bool brakeLights = JSON_Lights["brake"].toBool();
    if (_GTW_Brake_Light != brakeLights) {
        _GTW_Brake_Light = brakeLights;
        emit brake_Lights_State_Changed();
    }

    bool reverseLights = JSON_Lights["reverse"].toBool();
    if (_GTW_Reverse_Light != reverseLights) {
        _GTW_Reverse_Light = reverseLights;
        emit reverse_Lights_State_Changed();
    }



    QJsonObject JSON_Doors = data["doors_Status"].toObject();
    bool hoodIsOpen = JSON_Doors["hood_Is_Open"].toBool();
    if (_GTW_Hood_Is_Open != hoodIsOpen) {
        _GTW_Hood_Is_Open = hoodIsOpen;
        emit hood_State_Changed();
    }

    bool frontLeftDoorIsOpen = JSON_Doors["frontLeftDoor_Is_Open"].toBool();
    if (_GTW_FrontLeftDoor_Is_Open != frontLeftDoorIsOpen) {
        _GTW_FrontLeftDoor_Is_Open = frontLeftDoorIsOpen;
        emit frontLeftDoor_State_Changed();
    }

    bool frontRightDoorIsOpen = JSON_Doors["frontRightDoor_Is_Open"].toBool();
    if (_GTW_FrontRightDoor_Is_Open != frontRightDoorIsOpen) {
        _GTW_FrontRightDoor_Is_Open = frontRightDoorIsOpen;
        emit frontRightDoor_State_Changed();
    }

    bool rearLeftDoorIsOpen = JSON_Doors["rearLeftDoor_Is_Open"].toBool();
    if (_GTW_RearLeftDoor_Is_Open != rearLeftDoorIsOpen) {
        _GTW_RearLeftDoor_Is_Open = rearLeftDoorIsOpen;
        emit rearLeftDoor_State_Changed();
    }

    bool rearRightDoorIsOpen = JSON_Doors["rearRightDoor_Is_Open"].toBool();
    if (_GTW_RearRightDoor_Is_Open != rearRightDoorIsOpen) {
        _GTW_RearRightDoor_Is_Open = rearRightDoorIsOpen;
        emit rearRightDoor_State_Changed();
    }

    bool trunkIsOpen = JSON_Doors["trunk_Is_Open"].toBool();
    if (_GTW_Trunk_Is_Open != trunkIsOpen) {
        _GTW_Trunk_Is_Open = trunkIsOpen;
        emit trunk_State_Changed();
    }
}



//LIGHTS
bool Body::get_DRL_State() {
    return _GTW_DRL;
}

bool Body::get_Parking_Lights_State() {
    return _GTW_Parking_Lights;
}

bool Body::get_Low_Beam_State() {
    return _GTW_Low_Beam;
}

bool Body::get_High_Beam_State() {
    return _GTW_High_Beam;
}

bool Body::get_Fog_Lights_State() {
    return _GTW_Fog_Lights;
}

bool Body::get_Brake_Lights_State() {
    return _GTW_Brake_Light;
}

bool Body::get_Reverse_Lights_State() {
    return _GTW_Reverse_Light;
}

//DOORS
bool Body::get_Hood_State() {
    return _GTW_Hood_Is_Open;
}

bool Body::get_FrontLeftDoor_State() {
    return _GTW_FrontLeftDoor_Is_Open;
}

bool Body::get_FrontRightDoor_State() {
    return _GTW_FrontRightDoor_Is_Open;
}

bool Body::get_RearLeftDoor_State() {
    return _GTW_RearLeftDoor_Is_Open;
}

bool Body::get_RearRightDoor_State() {
    return _GTW_RearRightDoor_Is_Open;
}

bool Body::get_Trunk_State() {
    return _GTW_Trunk_Is_Open;
}
