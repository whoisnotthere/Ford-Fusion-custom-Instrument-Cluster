#include "vehicle_states.h"

Vehicle_States::Vehicle_States(QObject *parent) : QObject{parent} {

}



void Vehicle_States::process_Data(QJsonObject &data) {
    bool wakeUp_State = data["wake_Up"].toBool();
    if (_GTW_WakeUp_State != wakeUp_State) {
        _GTW_WakeUp_State = wakeUp_State;
        emit wakeUp_State_Changed();
    }

    bool ignition_State = data["ignition"].toBool();
    if (_GTW_Ignition_State != ignition_State) {
        _GTW_Ignition_State = ignition_State;
        emit ignition_State_Changed();
    }

    bool remoteStart_State = data["remote_Start"].toBool();
    if (_GTW_RemoteStart_State != remoteStart_State) {
        _GTW_RemoteStart_State = remoteStart_State;
        emit remoteStart_State_Changed();
    }

    bool debugMode_State = data["debug_Mode"].toBool();
    if (_GTW_DebugMode_State != debugMode_State) {
        _GTW_DebugMode_State = debugMode_State;
        emit debugMode_State_Changed();
    }
}



bool Vehicle_States::get_WakeUp_State() {
    return _GTW_WakeUp_State;
}



bool Vehicle_States::get_Ignition_State() {
    return _GTW_Ignition_State;
}



bool Vehicle_States::get_RemoteStart_State() {
    return _GTW_RemoteStart_State;
}



bool Vehicle_States::get_DebugMode_State() {
    return _GTW_DebugMode_State;
}
