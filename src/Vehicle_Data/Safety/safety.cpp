#include "safety.h"

Safety::Safety(Vehicle_States *vehicleStates, Powertrain *powertrain, Instrument_Cluster_Lights *instrumentClusterLights, Sounds_API *soundsApi, QObject *parent) : QObject{parent},
    _VEHICLE_STATES(vehicleStates),
    _POWERTRAIN(powertrain),
    _INSTRUMENT_CLUSTER_LIGHTS(instrumentClusterLights),
    _SOUNDS_API(soundsApi) {
    T_vehicle_Data_Checker = new QTimer();
    T_vehicle_Data_Checker->setInterval(100);
    connect(T_vehicle_Data_Checker, SIGNAL(timeout()), this, SLOT(S_check_Vehicle_Data()));
    T_vehicle_Data_Checker->start();

    T_seatBelt_Notification = new QTimer();
    T_seatBelt_Notification->setInterval(10000);
    connect(T_seatBelt_Notification, SIGNAL(timeout()), this, SLOT(S_seatBelt_Notification()));

    T_play_SeatBelt_Sound = new QTimer();
    T_play_SeatBelt_Sound->setInterval(900);
    T_play_SeatBelt_Sound->setTimerType(Qt::PreciseTimer);
    connect(T_play_SeatBelt_Sound, SIGNAL(timeout()), this, SLOT(S_play_SeatBelt_Sound()));

    T_internal_SeatBelt_Call = new QTimer();
    T_internal_SeatBelt_Call->setInterval(8000);
    connect(T_internal_SeatBelt_Call, SIGNAL(timeout()), this, SLOT(S_internal_SeatBelt_Call_Completed()));
}



void Safety::process_Data(QJsonObject &data) {
    bool driver_SeatBelt_Buckled = data["driver_SeatBelt_Buckled"].toBool();
    if (_GTW_Driver_SeatBelt_Buckled != driver_SeatBelt_Buckled) {
        _GTW_Driver_SeatBelt_Buckled = driver_SeatBelt_Buckled;
        emit driver_SeatBelt_State_Changed();
    }

    bool passenger_SeatBelt_Buckled = data["passenger_SeatBelt_Buckled"].toBool();
    if (_GTW_Passenger_SeatBelt_Buckled != passenger_SeatBelt_Buckled) {
        _GTW_Passenger_SeatBelt_Buckled = passenger_SeatBelt_Buckled;
        emit passenger_SeatBelt_State_Changed();
    }
}



QList<QString> Safety::return_Internal_DTCs() {
    return _control_Internal_DTCs();
}



void Safety::_control_SeatBelt_Indicator() {
    bool indicator_Changing_Required = false;

    if (_GTW_Ignition_State) {
        if (!_GTW_Driver_SeatBelt_Buckled || !_GTW_Passenger_SeatBelt_Buckled) {
            if (_seatBelt_Reminder_Active) {
                if (_seatBelt_Indicator_Requested_State != "blink_Fast") {
                    _seatBelt_Indicator_Requested_State = "blink_Fast";
                    indicator_Changing_Required = true;
                }
            }
            else {
                if (_seatBelt_Indicator_Requested_State != "constant") {
                    _seatBelt_Indicator_Requested_State = "constant";
                    indicator_Changing_Required = true;
                }
            }
        }
        else {
            if (_seatBelt_Indicator_Requested_State != "off") {
                _seatBelt_Indicator_Requested_State = "off";
                indicator_Changing_Required = true;
            }
        }
    }
    else {
        if (_seatBelt_Indicator_Requested_State != "off") {
            _seatBelt_Indicator_Requested_State = "off";
            indicator_Changing_Required = true;
        }
    }

    if (indicator_Changing_Required) {
        _INSTRUMENT_CLUSTER_LIGHTS->set_SeatBelt_Light_State(_seatBelt_Indicator_Requested_State);
    }
}



QList<QString> Safety::_control_Internal_DTCs() {
    QList<QString> internal_DTCs = QList<QString>();

    if (_seatBelt_Reminder_Armed) {
        if (_seatBelt_Notification_Counter <= _seatBelt_Notification_Repeats) { //If the seat belt reminder is not expired add internal DTCs
            if (!_GTW_Driver_SeatBelt_Buckled) {
                internal_DTCs.append("INTERNAL_DriverSeatBeltUnbuckled");
            }

            if (!_GTW_Passenger_SeatBelt_Buckled) {
                internal_DTCs.append("INTERNAL_PassengerSeatBeltUnbuckled");
            }
        }
    }

    return internal_DTCs;
}



void Safety::_control_SeatBelt_Reminder() {
    if (_GTW_Ignition_State) {
        if (!_GTW_Driver_SeatBelt_Buckled || !_GTW_Passenger_SeatBelt_Buckled) {
            if (!_seatBelt_Reminder_Internal_Call) {
                if (_GTW_Vehicle_Speed_KPH > 20) {
                    _start_SeatBelt_Reminder();
                }
                else {
                    if (_GTW_Vehicle_Speed_KPH == 0) {
                        _stop_SeatBelt_Reminder();
                    }
                }
            }
        }
        else {
            _stop_SeatBelt_Reminder();
        }
    }
}



void Safety::S_internal_SeatBelt_Call_Completed() {
    T_internal_SeatBelt_Call->stop();
    _stop_SeatBelt_Reminder();
    _seatBelt_Reminder_Internal_Call = false;
}



void Safety::S_check_Vehicle_Data() {
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
            if (!_GTW_Driver_SeatBelt_Buckled || !_GTW_Passenger_SeatBelt_Buckled) {
                _seatBelt_Reminder_Internal_Call = true;
                _start_SeatBelt_Reminder();
                T_internal_SeatBelt_Call->start();
            }
        }
        else {
            T_internal_SeatBelt_Call->stop();
            _stop_SeatBelt_Reminder();
            _seatBelt_Reminder_Internal_Call = false;
        }
    }

    int vehicle_Speed = _POWERTRAIN->get_Vehicle_Speed_KPH();
    if (vehicle_Speed != _GTW_Vehicle_Speed_KPH) {
        _GTW_Vehicle_Speed_KPH = vehicle_Speed;
    }

    _control_SeatBelt_Reminder();
    _control_SeatBelt_Indicator();
}



void Safety::S_seatBelt_Notification() {
    if (_seatBelt_Notification_Counter < _seatBelt_Notification_Repeats) {
        _seatBelt_Gong_Counter = 0; //Reset seatbelt gong counter
        T_play_SeatBelt_Sound->start(); //Start seatbelt gong
    }
    else {
        T_seatBelt_Notification->stop();
    }

    _seatBelt_Notification_Counter += 1;
}



void Safety::S_play_SeatBelt_Sound() {
    if (_seatBelt_Gong_Counter < _seatBelt_Gong_Max_Count) {
        _SOUNDS_API->play_seatBelt_Chime();
        _seatBelt_Reminder_Active = true;
    }
    else {
        T_play_SeatBelt_Sound->stop();
        T_seatBelt_Notification->start(); //Start next seatbelt notification timer
        _seatBelt_Reminder_Active = false;
    }

    _seatBelt_Gong_Counter += 1;
}



void Safety::_start_SeatBelt_Reminder() {
    if (!_seatBelt_Reminder_Armed) {
        _seatBelt_Reminder_Armed = true;
        _seatBelt_Gong_Counter = 0;
        _seatBelt_Notification_Counter = 0;
        T_play_SeatBelt_Sound->start();
    }
}



void Safety::_stop_SeatBelt_Reminder() {
    if (_seatBelt_Reminder_Armed) {
        _seatBelt_Reminder_Armed = false;
        _seatBelt_Reminder_Active = false;
        T_play_SeatBelt_Sound->stop();
        T_seatBelt_Notification->stop();
    }
}
