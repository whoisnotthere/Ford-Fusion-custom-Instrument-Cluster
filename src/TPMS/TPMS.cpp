#include "TPMS.h"

Tpms::Tpms(Data_Units *dataUnits, QObject *parent) : QObject{parent},
    _DATA_UNITS(dataUnits) {
    //Timer for updating data units
    T_data_Units_Updater = new QTimer();
    T_data_Units_Updater->setInterval(100);
    connect(T_data_Units_Updater, SIGNAL(timeout()), this, SLOT(S_update_Data_Units()));
    T_data_Units_Updater->start();
}



void Tpms::_update_Data_Units() {
    bool data_Unit_Changed = false;

    QString pressure_Unit = _DATA_UNITS->get_Pressure_Unit();
    if (pressure_Unit != _GTW_Pressure_Unit) {
        _GTW_Pressure_Unit = pressure_Unit;
        data_Unit_Changed = true;
        emit pressure_Unit_Changed();
    }

    if (data_Unit_Changed) {
        _process_Display_Pressure_Value(true);
    }
}



void Tpms::S_update_Data_Units() {
    _update_Data_Units();
}



void Tpms::process_Data(QJsonObject &data) {
    QJsonValue TPMS_Data = data["data"];

    QJsonObject pressure_Data = TPMS_Data["pressure"].toObject();
    _process_FL_Pressure_Data(pressure_Data);
    _process_FR_Pressure_Data(pressure_Data);
    _process_RL_Pressure_Data(pressure_Data);
    _process_RR_Pressure_Data(pressure_Data);
}



void Tpms::_process_FL_Pressure_Data(QJsonObject &data) {
    bool pressure_Value_Changed = false;

    QJsonObject FL_Wheel = data["front_Left"].toObject();

    QString FL_State = FL_Wheel["state"].toString();
    if (_GTW_FL_State != FL_State) {
        _GTW_FL_State = FL_State;
        _process_Display_Pressure_Value(true);
        emit fl_Pressure_State_Changed();
    }

    double FL_Pressure_bar = FL_Wheel["bar"].toDouble();
    if (_GTW_FL_Pressure_bar != FL_Pressure_bar) {
        _GTW_FL_Pressure_bar = FL_Pressure_bar;
        pressure_Value_Changed = true;
    }

    double FL_Pressure_kPa = FL_Wheel["kPa"].toInt();
    if (_GTW_FL_Pressure_kPa != FL_Pressure_kPa) {
        _GTW_FL_Pressure_kPa = FL_Pressure_kPa;
        pressure_Value_Changed = true;
    }

    double FL_Pressure_psi = FL_Wheel["psi"].toInt();
    if (_GTW_FL_Pressure_psi != FL_Pressure_psi) {
        _GTW_FL_Pressure_psi = FL_Pressure_psi;
        pressure_Value_Changed = true;
    }

    if (pressure_Value_Changed) {
        _process_Display_Pressure_Value();
    }
}



void Tpms::_process_FR_Pressure_Data(QJsonObject &data) {
    bool pressure_Value_Changed = false;

    QJsonObject FR_Wheel = data["front_Right"].toObject();

    QString FR_State = FR_Wheel["state"].toString();
    if (_GTW_FR_State != FR_State) {
        _GTW_FR_State = FR_State;
        _process_Display_Pressure_Value(true);
        emit fr_Pressure_State_Changed();
    }

    double FR_Pressure_bar = FR_Wheel["bar"].toDouble();
    if (_GTW_FR_Pressure_bar != FR_Pressure_bar) {
        _GTW_FR_Pressure_bar = FR_Pressure_bar;
        pressure_Value_Changed = true;
    }

    double FR_Pressure_kPa = FR_Wheel["kPa"].toInt();
    if (_GTW_FR_Pressure_kPa != FR_Pressure_kPa) {
        _GTW_FR_Pressure_kPa = FR_Pressure_kPa;
        pressure_Value_Changed = true;
    }

    double FR_Pressure_psi = FR_Wheel["psi"].toInt();
    if (_GTW_FR_Pressure_psi != FR_Pressure_psi) {
        _GTW_FR_Pressure_psi = FR_Pressure_psi;
        pressure_Value_Changed = true;
    }

    if (pressure_Value_Changed) {
        _process_Display_Pressure_Value();
    }
}



void Tpms::_process_RL_Pressure_Data(QJsonObject &data) {
    bool pressure_Value_Changed = false;

    QJsonObject RL_Wheel = data["rear_Left"].toObject();

    QString RL_State = RL_Wheel["state"].toString();
    if (_GTW_RL_State != RL_State) {
        _GTW_RL_State = RL_State;
        _process_Display_Pressure_Value(true);
        emit rl_Pressure_State_Changed();
    }

    double RL_Pressure_bar = RL_Wheel["bar"].toDouble();
    if (_GTW_RL_Pressure_bar != RL_Pressure_bar) {
        _GTW_RL_Pressure_bar = RL_Pressure_bar;
        pressure_Value_Changed = true;
    }

    double RL_Pressure_kPa = RL_Wheel["kPa"].toInt();
    if (_GTW_RL_Pressure_kPa != RL_Pressure_kPa) {
        _GTW_RL_Pressure_kPa = RL_Pressure_kPa;
        pressure_Value_Changed = true;
    }

    double RL_Pressure_psi = RL_Wheel["psi"].toInt();
    if (_GTW_RL_Pressure_psi != RL_Pressure_psi) {
        _GTW_RL_Pressure_psi = RL_Pressure_psi;
        pressure_Value_Changed = true;
    }

    if (pressure_Value_Changed) {
        _process_Display_Pressure_Value();
    }
}



void Tpms::_process_RR_Pressure_Data(QJsonObject &data) {
    bool pressure_Value_Changed = false;

    QJsonObject RR_Wheel = data["rear_Right"].toObject();

    QString RR_State = RR_Wheel["state"].toString();
    if (_GTW_RR_State != RR_State) {
        _GTW_RR_State = RR_State;
        _process_Display_Pressure_Value(true);
        emit rr_Pressure_State_Changed();
    }

    double RR_Pressure_bar = RR_Wheel["bar"].toDouble();
    if (_GTW_RR_Pressure_bar != RR_Pressure_bar) {
        _GTW_RR_Pressure_bar = RR_Pressure_bar;
        pressure_Value_Changed = true;
    }

    double RR_Pressure_kPa = RR_Wheel["kPa"].toInt();
    if (_GTW_RR_Pressure_kPa != RR_Pressure_kPa) {
        _GTW_RR_Pressure_kPa = RR_Pressure_kPa;
        pressure_Value_Changed = true;
    }

    double RR_Pressure_psi = RR_Wheel["psi"].toInt();
    if (_GTW_RR_Pressure_psi != RR_Pressure_psi) {
        _GTW_RR_Pressure_psi = RR_Pressure_psi;
        pressure_Value_Changed = true;
    }

    if (pressure_Value_Changed) {
        _process_Display_Pressure_Value();
    }
}



void Tpms::_process_Display_Pressure_Value(bool force_Update) {
    bool FL_Display_Value_Changed = false;
    bool FR_Display_Value_Changed = false;
    bool RL_Display_Value_Changed = false;
    bool RR_Display_Value_Changed = false;

    if (force_Update) {
        FL_Display_Value_Changed = true;
        FR_Display_Value_Changed = true;
        RL_Display_Value_Changed = true;
        RR_Display_Value_Changed = true;
    }

    if (_GTW_Pressure_Unit == "bar") {
        if (_FL_Display_Pressure_Value != _GTW_FL_Pressure_bar) {
            _FL_Display_Pressure_Value = _GTW_FL_Pressure_bar;
            FL_Display_Value_Changed = true;
        }

        if (_FR_Display_Pressure_Value != _GTW_FR_Pressure_bar) {
            _FR_Display_Pressure_Value = _GTW_FR_Pressure_bar;
            FR_Display_Value_Changed = true;
        }

        if (_RL_Display_Pressure_Value != _GTW_RL_Pressure_bar) {
            _RL_Display_Pressure_Value = _GTW_RL_Pressure_bar;
            RL_Display_Value_Changed = true;
        }

        if (_RR_Display_Pressure_Value != _GTW_RR_Pressure_bar) {
            _RR_Display_Pressure_Value = _GTW_RR_Pressure_bar;
            RR_Display_Value_Changed = true;
        }
    }
    else if (_GTW_Pressure_Unit == "kPa") {
        if (_FL_Display_Pressure_Value != _GTW_FL_Pressure_kPa) {
            _FL_Display_Pressure_Value = _GTW_FL_Pressure_kPa;
            FL_Display_Value_Changed = true;
        }

        if (_FR_Display_Pressure_Value != _GTW_FR_Pressure_kPa) {
            _FR_Display_Pressure_Value = _GTW_FR_Pressure_kPa;
            FR_Display_Value_Changed = true;
        }

        if (_RL_Display_Pressure_Value != _GTW_RL_Pressure_kPa) {
            _RL_Display_Pressure_Value = _GTW_RL_Pressure_kPa;
            RL_Display_Value_Changed = true;
        }

        if (_RR_Display_Pressure_Value != _GTW_RR_Pressure_kPa) {
            _RR_Display_Pressure_Value = _GTW_RR_Pressure_kPa;
            RR_Display_Value_Changed = true;
        }
    }
    else if (_GTW_Pressure_Unit == "psi") {
        if (_FL_Display_Pressure_Value != _GTW_FL_Pressure_psi) {
            _FL_Display_Pressure_Value = _GTW_FL_Pressure_psi;
            FL_Display_Value_Changed = true;
        }

        if (_FR_Display_Pressure_Value != _GTW_FR_Pressure_psi) {
            _FR_Display_Pressure_Value = _GTW_FR_Pressure_psi;
            FR_Display_Value_Changed = true;
        }

        if (_RL_Display_Pressure_Value != _GTW_RL_Pressure_psi) {
            _RL_Display_Pressure_Value = _GTW_RL_Pressure_psi;
            RL_Display_Value_Changed = true;
        }

        if (_RR_Display_Pressure_Value != _GTW_RR_Pressure_psi) {
            _RR_Display_Pressure_Value = _GTW_RR_Pressure_psi;
            RR_Display_Value_Changed = true;
        }
    }

    if (FL_Display_Value_Changed) {
        if (_GTW_FL_State != "not_Actual") {
            emit fl_Pressure_Changed();
        }
    }

    if (FR_Display_Value_Changed) {
        if (_GTW_FR_State != "not_Actual") {
            emit fr_Pressure_Changed();
        }
    }

    if (RL_Display_Value_Changed) {
        if (_GTW_RL_State != "not_Actual") {
            emit rl_Pressure_Changed();
        }
    }

    if (RR_Display_Value_Changed) {
        if (_GTW_RR_State != "not_Actual") {
            emit rr_Pressure_Changed();
        }
    }
}



QString Tpms::get_Pressure_Unit() {
    return _GTW_Pressure_Unit;
}

double Tpms::get_FL_Display_Pressure() {
    return _FL_Display_Pressure_Value;
}

double Tpms::get_FR_Display_Pressure() {
    return _FR_Display_Pressure_Value;
}

double Tpms::get_RL_Display_Pressure() {
    return _RL_Display_Pressure_Value;
}

double Tpms::get_RR_Display_Pressure() {
    return _RR_Display_Pressure_Value;
}

QString Tpms::get_FL_Display_State() {
    return _GTW_FL_State;
}

QString Tpms::get_FR_Display_State() {
    return _GTW_FR_State;
}

QString Tpms::get_RL_Display_State() {
    return _GTW_RL_State;
}

QString Tpms::get_RR_Display_State() {
    return _GTW_RR_State;
}
