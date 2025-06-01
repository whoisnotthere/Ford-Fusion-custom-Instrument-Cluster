#include "pre_AP.h"

Pre_AP::Pre_AP(Powertrain *powertrain, Sounds_API *soundsApi, QObject *parent) : QObject{parent}, _POWERTRAIN(powertrain), _SOUNDS_API(soundsApi) {
    T_vehicle_Data_Checker = new QTimer();
    T_vehicle_Data_Checker->setInterval(100);
    connect(T_vehicle_Data_Checker, SIGNAL(timeout()), this, SLOT(S_check_Vehicle_Data()));
    T_vehicle_Data_Checker->start();
}



void Pre_AP::process_Data(QJsonObject &data) {
    QJsonValue ADAS_Data = data["data"];

    QString units_System = ADAS_Data["internal_Units_System"].toString();
    if (_GTW_ADAS_Units_System != units_System) {
        _GTW_ADAS_Units_System = units_System;
    }

    QJsonValue TSR_Data = ADAS_Data["TSR"];
    _process_TSR_Data(TSR_Data);

    QJsonValue LKA_Data = ADAS_Data["LKA"];
    _process_LKA_Data(LKA_Data);
}



void Pre_AP::_process_TSR_Data(QJsonValue &data) {
    bool process_Overspeed = false;

    bool TSR_Active = data["TSR_Active"].toBool();
    if (_GTW_TSR_Active != TSR_Active) {
        _GTW_TSR_Active = TSR_Active;

        if (!_GTW_TSR_Active) {
            _GTW_Speed_Restriction_Active = false;
            _GTW_Speed_Special_Restriction_Active = false;
            _GTW_Overtaking_Prohibited_Active = false;
            process_Overspeed = true; //Force process overspeed to reset overspeed flags because TSR is now off
            emit speed_Restriction_State_Changed();
            emit speed_Special_Restriction_State_Changed();
            emit overtaking_Prohibiting_State_Changed();
        }
    }

    if (_GTW_TSR_Active) {
        QJsonArray detected_Signs = data["detected_Signs"].toArray();

        //TSR ACTIVE STATUS
        bool speed_Restriction_Detected = false;
        bool speed_Special_Restriction_Detected = false;
        bool overtaking_Prohibited_Detected = false;
        for (int i = 0; i < detected_Signs.size(); i++) {
            QJsonObject detected_Sign = detected_Signs[i].toObject();
            QString sign_Type = detected_Sign["type"].toString();

            if (sign_Type == "speed_Restriction") {
                speed_Restriction_Detected = true;

                int restriction_Value = detected_Sign["value"].toInt();
                if (_GTW_Restriction_Speed != restriction_Value) {
                    _GTW_Restriction_Speed = restriction_Value;
                    _overspeed = false; //Reset overspeed flag because restriction speed changed
                    process_Overspeed = true;
                    emit speed_Restriction_Changed();
                }
            }
            else if (sign_Type == "speed_Special_Restriction") {
                speed_Special_Restriction_Detected = true;

                int restriction_Value = detected_Sign["value"].toInt();
                if (_GTW_Restriction_Special_Speed != restriction_Value) {
                    _GTW_Restriction_Special_Speed = restriction_Value;
                    _overspeed_Special = false; //Reset overspeed flag because restriction speed changed
                    process_Overspeed = true;
                    emit speed_Special_Restriction_Changed();
                }
            }
            else if (sign_Type == "overtaking_Prohibited") {
                overtaking_Prohibited_Detected = true;
            }
        }

        if (_GTW_Speed_Restriction_Active != speed_Restriction_Detected) {
            _GTW_Speed_Restriction_Active = speed_Restriction_Detected;
            process_Overspeed = true;
            emit speed_Restriction_State_Changed();
        }

        if (_GTW_Speed_Special_Restriction_Active != speed_Special_Restriction_Detected) {
            _GTW_Speed_Special_Restriction_Active = speed_Special_Restriction_Detected;
            process_Overspeed = true;
            emit speed_Special_Restriction_State_Changed();
        }

        if (_GTW_Overtaking_Prohibited_Active != overtaking_Prohibited_Detected) {
            _GTW_Overtaking_Prohibited_Active = overtaking_Prohibited_Detected;
            emit overtaking_Prohibiting_State_Changed();
        }
    }

    if (process_Overspeed) {
        _process_TSR_Overspeed();
    }
}



void Pre_AP::_process_TSR_Overspeed() {
    if (_GTW_Overspeed_Warning) {
        bool overspeed_Sound = false;

        if (!_GTW_Speed_Restriction_Active) {
            _overspeed = false;
        }

        if (!_GTW_Speed_Special_Restriction_Active) {
            _overspeed_Special = false;
        }

        //Regular speed restriction
        if (_vehicle_Speed > _GTW_Restriction_Speed && _GTW_Restriction_Speed != 0) { //_GTW_Restriction_Speed = 0 means the road has no speed limit
            if (_GTW_Speed_Restriction_Active) {
                if (!_overspeed) {
                    _overspeed = true;
                    overspeed_Sound = true;
                    emit restriction_Overspeed();
                }
            }
        }
        else {
            _overspeed = false;
            emit restriction_Overspeed_Ended();
        }

        //Special speed restriction
        if (_vehicle_Speed > _GTW_Restriction_Special_Speed) {
            if (_GTW_Speed_Special_Restriction_Active) {
                if (!_overspeed_Special) {
                    _overspeed_Special = true;
                    overspeed_Sound = true;
                    emit restriction_Special_Overspeed();
                }
            }
        }
        else {
            _overspeed_Special = false;
            emit restriction_Special_Overspeed_Ended();
        }

        //Overspeed notification
        if (overspeed_Sound) {
            if (_GTW_Overspeed_Chime) {
                _SOUNDS_API->play_Overspeed_Chime();
            }
        }
    }
    else {
        _overspeed = false;
        _overspeed_Special = false;
    }
}



void Pre_AP::_process_LKA_Data(QJsonValue &data) {
    bool LKA_Active = data["LKA_Active"].toBool();
    if (_GTW_LKA_Active != LKA_Active) {
        _GTW_LKA_Active = LKA_Active;
        emit lka_State_Changed();
    }

    if (_GTW_LKA_Active) {
        QJsonValue lanes_Status = data["lanes_Status"].toObject();

        QString leftLane_State = lanes_Status["left_Lane"].toString();
        if (_GTW_LeftLane_State != leftLane_State) {
            _GTW_LeftLane_State = leftLane_State;
            emit lka_LeftLane_State_Changed();
        }

        QString rightLane_State = lanes_Status["right_Lane"].toString();
        if (_GTW_RightLane_State != rightLane_State) {
            _GTW_RightLane_State = rightLane_State;
            emit lka_RightLane_State_Changed();
        }
    }
}



void Pre_AP::S_check_Vehicle_Data() {
    int vehicle_Speed = 0;

    if (_GTW_ADAS_Units_System == "metric") {
        vehicle_Speed = _POWERTRAIN->get_Vehicle_Speed_KPH();
    }
    else if (_GTW_ADAS_Units_System == "imperial") {
        vehicle_Speed = _POWERTRAIN->get_Vehicle_Speed_MPH();
    }

    if (_vehicle_Speed != vehicle_Speed) {
        _vehicle_Speed = vehicle_Speed;
        _process_TSR_Overspeed();
    }
}



bool Pre_AP::get_Speed_Restriction_State() {
    return _GTW_Speed_Restriction_Active;
}

bool Pre_AP::get_Speed_Special_Restriction_State() {
    return _GTW_Speed_Special_Restriction_Active;
}

bool Pre_AP::get_Overtaking_Prohibited_State() {
    return _GTW_Overtaking_Prohibited_Active;
}

int Pre_AP::get_Speed_Restriction() {
    return _GTW_Restriction_Speed;
}

int Pre_AP::get_Speed_Special_Restriction() {
    return _GTW_Restriction_Special_Speed;
}

bool Pre_AP::get_LKA_State() {
    return _GTW_LKA_Active;
}

QString Pre_AP::get_LeftLane_State() {
    return _GTW_LeftLane_State;
}

QString Pre_AP::get_RightLane_State() {
    return _GTW_RightLane_State;
}
