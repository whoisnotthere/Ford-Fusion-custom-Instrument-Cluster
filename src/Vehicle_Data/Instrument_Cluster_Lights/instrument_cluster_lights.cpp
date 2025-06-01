#include "instrument_cluster_lights.h"

Instrument_Cluster_Lights::Instrument_Cluster_Lights(Vehicle_States *vehicleStates, Turn_Signals *turnSignals, QObject *parent) : QObject(parent),
    _VEHICLE_STATES(vehicleStates),
    _TURN_SIGNALS(turnSignals) {
    T_blink_Timer = new QTimer();
    T_blink_Timer->setInterval(_blink_Timer_Interval);
    connect(T_blink_Timer, SIGNAL(timeout()), this, SLOT(S_process_Blinks()));

    T_vehicle_Data_Checker = new QTimer();
    T_vehicle_Data_Checker->setInterval(100);
    connect(T_vehicle_Data_Checker, SIGNAL(timeout()), this, SLOT(S_check_Vehicle_Data()));

    T_lights_Self_Check = new QTimer();
    T_lights_Self_Check->setInterval(3000);
    connect(T_lights_Self_Check, SIGNAL(timeout()), this, SLOT(S_self_Testing_Completed()));

    _blink_Slow_Count = _blink_Slow_Interval / _blink_Timer_Interval;
    _blink_Fast_Count = _blink_Fast_Interval / _blink_Timer_Interval;

    T_blink_Timer->start();
    T_vehicle_Data_Checker->start();
}



void Instrument_Cluster_Lights::process_Data(QJsonObject &data) {
    _TURN_SIGNALS->process_Data(data);

    _GTW_Warning_Lights_Testing = data["warning_Lights_Test_Mode"].toBool();

    _GTW_DoorOpen_Light_State = data["door_Open"].toBool(_doorOpen_Light_State_Default);
    _GTW_Airbag_Light_Requested_State = data["airbag_Light"].toString(_airbag_Light_Requested_State_Default);
    _GTW_Battery_Light_State = data["12v_System_Fault"].toBool(_battery_Light_State_Default);
    _GTW_FogLights_Light_State = data["fog_Lights"].toBool(_fogLights_Light_State_Default);
    _GTW_ParkingLights_Light_State = data["parking_Lights"].toBool(_parkingLights_Light_State_Default);
    _GTW_HighBeam_Light_State = data["highBeam"].toString(_highBeam_Light_State_Default);
    _GTW_LowBeam_Light_State = data["lowBeam"].toString(_lowBeam_Light_State_Default);

    _GTW_Coolant_Overheated_Light_State = data["coolant_Overheated"].toBool(_coolant_Overheated_Light_State_Default);
    _GTW_Oil_Pressure_Low_State = data["oil_Pressure_Low"].toBool(_oil_Pressure_Low_State_Default);
    _GTW_Electric_Parking_Brake_Light_Requested_State = data["electric_Parking_Brake_Fault"].toString(_electric_Parking_Brake_Light_Requested_State_Default);
    _GTW_Parking_Brake_Light_Requested_State = data["parking_Brake"].toString(_parking_Brake_Light_Requested_State_Default);
    _GTW_ABS_Light_Requested_State = data["ABS_Light"].toString(_ABS_Light_Requested_State_Default);
    _GTW_Check_Engine_Light_Requested_State = data["check_Engine"].toString(_check_Engine_Light_Requested_State_Default);
    _GTW_Stability_Control_Light_Requested_State = data["stability_Control"].toString(_stability_Control_Light_Requested_State_Default);
    _GTW_Stability_Control_Off_Light_Requested_State = data["stability_Control_Off"].toString(_stability_Control_Off_Light_Requested_State_Default);
    _GTW_TPMS_Light_Requested_State = data["TPMS_Light"].toString(_TPMS_Light_Requested_State_Default);

    _update_Lights_State();
}



void Instrument_Cluster_Lights::set_SeatBelt_Light_State(QString requested_State) {
    _GTW_SeatBelt_Light_Requested_State = requested_State;
    _process_SeatBelt_Light(_GTW_SeatBelt_Light_Requested_State);
}



void Instrument_Cluster_Lights::_update_Lights_State() {
    if (_GTW_Warning_Lights_Testing || _warning_Lights_Testing) {
        _process_SeatBelt_Light("constant");
        _process_DoorOpen_Light(true);
        _process_Airbag_Light("constant");
        _process_Battery_Light(true);
        _process_FogLights_Light(true);
        _process_ParkingLights_Light(true);
        _process_LowBeam_Light("regular_On");
        _process_HighBeam_Light("regular_On");
        _process_CoolantOverheated_Light(true);
        _process_OilPressure_Light(true);
        _process_ElectricParkingBrake_Light("constant");
        _process_ParkingBrake_Light("constant");
        _process_ABS_Light("constant");
        _process_CheckEngine_Light("constant");
        _process_StabilityControl_Light("constant");
        _process_StabilityControlOff_Light("constant");
        _process_TPMS_Light("constant");
    }
    else {
        _process_SeatBelt_Light(_GTW_SeatBelt_Light_Requested_State);
        _process_DoorOpen_Light(_GTW_DoorOpen_Light_State);
        _process_Airbag_Light(_GTW_Airbag_Light_Requested_State);
        _process_Battery_Light(_GTW_Battery_Light_State);
        _process_FogLights_Light(_GTW_FogLights_Light_State);
        _process_ParkingLights_Light(_GTW_ParkingLights_Light_State);
        _process_LowBeam_Light(_GTW_LowBeam_Light_State);
        _process_HighBeam_Light(_GTW_HighBeam_Light_State);
        _process_CoolantOverheated_Light(_GTW_Coolant_Overheated_Light_State);
        _process_OilPressure_Light(_GTW_Oil_Pressure_Low_State);
        _process_ElectricParkingBrake_Light(_GTW_Electric_Parking_Brake_Light_Requested_State);
        _process_ParkingBrake_Light(_GTW_Parking_Brake_Light_Requested_State);
        _process_ABS_Light(_GTW_ABS_Light_Requested_State);
        _process_CheckEngine_Light(_GTW_Check_Engine_Light_Requested_State);
        _process_StabilityControl_Light(_GTW_Stability_Control_Light_Requested_State);
        _process_StabilityControlOff_Light(_GTW_Stability_Control_Off_Light_Requested_State);
        _process_TPMS_Light(_GTW_TPMS_Light_Requested_State);
    }
}



void Instrument_Cluster_Lights::S_self_Testing_Completed() {
    _warning_Lights_Testing = false;
    _update_Lights_State();
}



void Instrument_Cluster_Lights::_start_Lights_Testing() {
    _warning_Lights_Testing = true;
    _update_Lights_State();
    T_lights_Self_Check->start();
}



void Instrument_Cluster_Lights::S_check_Vehicle_Data() {
    bool states_Changed = false;

    bool wakeUp_State = _VEHICLE_STATES->get_WakeUp_State();
    if (wakeUp_State != _GTW_WakeUp_State) {
        _GTW_WakeUp_State = wakeUp_State;
        states_Changed = true;
    }

    bool ignition_State = _VEHICLE_STATES->get_Ignition_State();
    if (ignition_State != _GTW_Ignition_State) {
        _GTW_Ignition_State = ignition_State;
        states_Changed = true;
    }

    if (states_Changed) {
        if (_GTW_WakeUp_State && _GTW_Ignition_State) {
            _start_Lights_Testing();
        }
        else {
            T_lights_Self_Check->stop();
            _warning_Lights_Testing = false;
            _update_Lights_State();
        }
    }
}



void Instrument_Cluster_Lights::S_process_Blinks() {
    _blink_Slow_Counter += 1;
    _blink_Fast_Counter += 1;

    if (_blink_Slow_Counter == _blink_Slow_Count) {
        _blink_Slow_State = !_blink_Slow_State;

        if (_seatBelt_Light_Requested_State == "blink_Slow") {
            _seatBelt_Light_State = _blink_Slow_State;
            emit seatBelt_Light_Changed();
        }

        if (_electric_Parking_Brake_Light_Requested_State == "blink_Slow") {
            _electric_Parking_Brake_Light_State = _blink_Slow_State;
            emit electric_Parking_Brake_Light_Changed();
        }

        if (_parking_Brake_Light_Requested_State == "blink_Slow") {
            _parking_Brake_Light_State = _blink_Slow_State;
            emit parking_Brake_Light_Changed();
        }

        if (_ABS_Light_Requested_State == "blink_Slow") {
            _ABS_Light_State = _blink_Slow_State;
            emit abs_Light_Changed();
        }

        if (_check_Engine_Light_Requested_State == "blink_Slow") {
            _check_Engine_Light_State = _blink_Slow_State;
            emit check_Engine_Light_Changed();
        }

        if (_stability_Control_Light_Requested_State == "blink_Slow") {
            _stability_Control_Light_State = _blink_Slow_State;
            emit stability_Control_Light_Changed();
        }

        if (_stability_Control_Off_Light_Requested_State == "blink_Slow") {
            _stability_Control_Off_Light_State = _blink_Slow_State;
            emit stability_Control_Off_Light_Changed();
        }

        if (_TPMS_Light_Requested_State == "blink_Slow") {
            _TPMS_Light_State = _blink_Slow_State;
            emit tpms_Light_Changed();
        }

        _blink_Slow_Counter = 0;
    }

    if (_blink_Fast_Counter == _blink_Fast_Count) {
        _blink_Fast_State = !_blink_Fast_State;

        if (_seatBelt_Light_Requested_State == "blink_Fast") {
            _seatBelt_Light_State = _blink_Fast_State;
            emit seatBelt_Light_Changed();
        }

        if (_airbag_Light_Requested_State == "blink_Fast") {
            _airbag_Light_State = _blink_Fast_State;
            emit airbag_Light_Changed();
        }

        if (_electric_Parking_Brake_Light_Requested_State == "blink_Fast") {
            _electric_Parking_Brake_Light_State = _blink_Fast_State;
            emit electric_Parking_Brake_Light_Changed();
        }

        if (_parking_Brake_Light_Requested_State == "blink_Fast") {
            _parking_Brake_Light_State = _blink_Fast_State;
            emit parking_Brake_Light_Changed();
        }

        if (_ABS_Light_Requested_State == "blink_Fast") {
            _ABS_Light_State = _blink_Fast_State;
            emit abs_Light_Changed();
        }

        if (_stability_Control_Light_Requested_State == "blink_Fast") {
            _stability_Control_Light_State = _blink_Fast_State;
            emit stability_Control_Light_Changed();
        }

        if (_stability_Control_Off_Light_Requested_State == "blink_Fast") {
            _stability_Control_Off_Light_State = _blink_Fast_State;
            emit stability_Control_Off_Light_Changed();
        }

        _blink_Fast_Counter = 0;
    }
}



void Instrument_Cluster_Lights::_process_SeatBelt_Light(QString state) {
    if (_seatBelt_Light_Requested_State != state) {
        _seatBelt_Light_Requested_State = state;

        if (_seatBelt_Light_Requested_State == "off") {
            _seatBelt_Light_State = false;
        }
        else if (_seatBelt_Light_Requested_State == "constant") {
            _seatBelt_Light_State = true;
        }

        emit seatBelt_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_DoorOpen_Light(bool state) {
    if (_doorOpen_Light_State != state) {
        _doorOpen_Light_State = state;
        emit doorOpen_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_Airbag_Light(QString state) {
    if (_airbag_Light_Requested_State != state) {
        _airbag_Light_Requested_State = state;

        if (_airbag_Light_Requested_State == "off") {
            _airbag_Light_State = false;
        }
        else if (_airbag_Light_Requested_State == "constant") {
            _airbag_Light_State = true;
        }

        emit airbag_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_Battery_Light(bool state) {
    if (_battery_Light_State != state) {
        _battery_Light_State = state;
        emit battery_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_FogLights_Light(bool state) {
    if (_fogLights_Light_State != state) {
        _fogLights_Light_State = state;
        emit fogLights_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_ParkingLights_Light(bool state) {
    if (_parkingLights_Light_State != state) {
        _parkingLights_Light_State = state;
        emit parkingLights_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_LowBeam_Light(QString state) {
    if (_lowBeam_Light_State != state) {
        _lowBeam_Light_State = state;
        emit lowBeam_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_HighBeam_Light(QString state) {
    if (_highBeam_Light_State != state) {
        _highBeam_Light_State = state;
        emit highBeam_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_CoolantOverheated_Light(bool state) {
    if (_coolant_Overheated_Light_State != state) {
        _coolant_Overheated_Light_State = state;
        emit coolant_Overheated_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_OilPressure_Light(bool state) {
    if (_oil_Pressure_Low_State != state) {
        _oil_Pressure_Low_State = state;
        emit oil_Pressure_Low_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_ElectricParkingBrake_Light(QString state) {
    if (_electric_Parking_Brake_Light_Requested_State != state) {
        _electric_Parking_Brake_Light_Requested_State = state;

        if (_electric_Parking_Brake_Light_Requested_State == "off") {
            _electric_Parking_Brake_Light_State = false;
        }
        else if (_electric_Parking_Brake_Light_Requested_State == "constant") {
            _electric_Parking_Brake_Light_State = true;
        }

        emit electric_Parking_Brake_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_ParkingBrake_Light(QString state) {
    if (_parking_Brake_Light_Requested_State != state) {
        _parking_Brake_Light_Requested_State = state;

        if (_parking_Brake_Light_Requested_State == "off") {
            _parking_Brake_Light_State = false;
        }
        else if (_parking_Brake_Light_Requested_State == "constant") {
            _parking_Brake_Light_State = true;
        }

        emit parking_Brake_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_ABS_Light(QString state) {
    if (_ABS_Light_Requested_State != state) {
        _ABS_Light_Requested_State = state;

        if (_ABS_Light_Requested_State == "off") {
            _ABS_Light_State = false;
        }
        else if (_ABS_Light_Requested_State == "constant") {
            _ABS_Light_State = true;
        }

        emit abs_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_CheckEngine_Light(QString state) {
    if (_check_Engine_Light_Requested_State != state) {
        _check_Engine_Light_Requested_State = state;

        if (_check_Engine_Light_Requested_State == "off") {
            _check_Engine_Light_State = false;
        }
        else if (_check_Engine_Light_Requested_State == "constant") {
            _check_Engine_Light_State = true;
        }

        emit check_Engine_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_StabilityControl_Light(QString state) {
    if (_stability_Control_Light_Requested_State != state) {
        _stability_Control_Light_Requested_State = state;

        if (_stability_Control_Light_Requested_State == "off") {
            _stability_Control_Light_State = false;
        }
        else if (_stability_Control_Light_Requested_State == "constant") {
            _stability_Control_Light_State = true;
        }

        emit stability_Control_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_StabilityControlOff_Light(QString state) {
    if (_stability_Control_Off_Light_Requested_State != state) {
        _stability_Control_Off_Light_Requested_State = state;

        if (_stability_Control_Off_Light_Requested_State == "off") {
            _stability_Control_Off_Light_State = false;
        }
        else if (_stability_Control_Off_Light_Requested_State == "constant") {
            _stability_Control_Off_Light_State = true;
        }

        emit stability_Control_Off_Light_Changed();
    }
}

void Instrument_Cluster_Lights::_process_TPMS_Light(QString state) {
    if (_TPMS_Light_Requested_State != state) {
        _TPMS_Light_Requested_State = state;

        if (_TPMS_Light_Requested_State == "off") {
            _TPMS_Light_State = false;
        }
        else if (_TPMS_Light_Requested_State == "constant") {
            _TPMS_Light_State = true;
        }

        emit tpms_Light_Changed();
    }
}



bool Instrument_Cluster_Lights::get_SeatBelt_Light_State() {
    return _seatBelt_Light_State;
}

bool Instrument_Cluster_Lights::get_DoorOpen_Light_State() {
    return _doorOpen_Light_State;
}

bool Instrument_Cluster_Lights::get_Airbag_Light_State() {
    return _airbag_Light_State;
}

bool Instrument_Cluster_Lights::get_Battery_Light_State() {
    return _battery_Light_State;
}

bool Instrument_Cluster_Lights::get_FogLights_Light_State() {
    return _fogLights_Light_State;
}

bool Instrument_Cluster_Lights::get_ParkingLights_Light_State() {
    return _parkingLights_Light_State;
}

QString Instrument_Cluster_Lights::get_LowBeam_Light_State() {
    return _lowBeam_Light_State;
}

QString Instrument_Cluster_Lights::get_HighBeam_Light_State() {
    return _highBeam_Light_State;
}

bool Instrument_Cluster_Lights::get_Coolant_Overheated_Light_State() {
    return _coolant_Overheated_Light_State;
}

bool Instrument_Cluster_Lights::get_Oil_Pressure_Low_Light_State() {
    return _oil_Pressure_Low_State;
}

bool Instrument_Cluster_Lights::get_Electric_Parking_Brake_Light_State() {
    return _electric_Parking_Brake_Light_State;
}

bool Instrument_Cluster_Lights::get_Parking_Brake_Light_State() {
    return _parking_Brake_Light_State;
}

bool Instrument_Cluster_Lights::get_ABS_Light_State() {
    return _ABS_Light_State;
}

bool Instrument_Cluster_Lights::get_Check_Engine_Light_State() {
    return _check_Engine_Light_State;
}

bool Instrument_Cluster_Lights::get_Stability_Control_Light_State() {
    return _stability_Control_Light_State;
}

bool Instrument_Cluster_Lights::get_Stability_Control_Off_Light_State() {
    return _stability_Control_Off_Light_State;
}

bool Instrument_Cluster_Lights::get_TPMS_Light_State() {
    return _TPMS_Light_State;
}
