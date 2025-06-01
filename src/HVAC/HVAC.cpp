#include "HVAC.h"

Hvac::Hvac(Data_Units *dataUnits, Hvac_API *hvacAPI, QObject *parent) : QObject{parent},
    _DATA_UNITS(dataUnits),
    _HVAC_API(hvacAPI) {
    //Timer for updating data units
    T_data_Units_Updater = new QTimer();
    T_data_Units_Updater->setInterval(100);
    connect(T_data_Units_Updater, SIGNAL(timeout()), this, SLOT(S_update_Data_Units()));
    T_data_Units_Updater->start();
}



void Hvac::_update_Data_Units() {
    bool data_Unit_Changed = false;

    QString temperature_Unit = _DATA_UNITS->get_Temperature_Unit();
    if (temperature_Unit != _GTW_Temperature_Unit) {
        _GTW_Temperature_Unit = temperature_Unit;
        data_Unit_Changed = true;
        emit temperature_Unit_Changed();
    }

    if (data_Unit_Changed) {
        _update_Exterior_Temperature_Display_Value();
        _update_Fan_Speed_Display_Value();
        _update_Driver_Temperature_Display_Value();
    }
}



void Hvac::S_update_Data_Units() {
    _update_Data_Units();
}



void Hvac::process_Data(QJsonObject &data) {
    QJsonObject HVAC_Data = data["data"].toObject();

    _process_Exterior_Temperature_Data(HVAC_Data);

    QJsonObject front_Climate = HVAC_Data["front_Climate"].toObject();

    _process_Climate_States_Data(front_Climate);
    _process_Fan_Speed_Data(front_Climate);
    _process_Driver_Temperature_Data(front_Climate);

    _update_Fan_Speed_Display_Value();
    _update_Driver_Temperature_Display_Value();
}



void Hvac::driver_Temperature_Plus() {
    if (_GTW_Climate_ON) {
        _HVAC_API->driver_Temperature_Plus();
    }
    else {
        _HVAC_API->toggle_Front_Climate_State();
    }
}



void Hvac::driver_Temperature_Minus() {
    if (_GTW_Climate_ON) {
        _HVAC_API->driver_Temperature_Minus();
    }
    else {
        _HVAC_API->toggle_Front_Climate_State();
    }
}



void Hvac::fan_Speed_Plus() {
    if (_GTW_Climate_ON) {
        _HVAC_API->front_Climate_Fan_Speed_Plus();
    }
    else {
        _HVAC_API->toggle_Front_Climate_State();
    }
}



void Hvac::fan_Speed_Minus() {
    if (_GTW_Climate_ON) {
        if (_GTW_Auto_State == "flow+fan" || _GTW_Auto_State == "fan") {
            _HVAC_API->toggle_Front_Climate_State();
        }
        else {
            if (_GTW_Fan_Speed > 1) {
                _HVAC_API->front_Climate_Fan_Speed_Minus();
            }
            else {
                _HVAC_API->request_Front_Climate_Auto_Mode();
            }
        }
    }
}



void Hvac::_process_Exterior_Temperature_Data(QJsonObject &data) {
    QJsonObject exterior_Temperature = data["exterior_Temperature"].toObject();

    int JSON_Exterior_Temperature_C = exterior_Temperature["celsius"].toInt();
    if (_GTW_Exterior_Temperature_C != JSON_Exterior_Temperature_C) {
        _GTW_Exterior_Temperature_C = JSON_Exterior_Temperature_C;
    }

    int JSON_Exterior_Temperature_F = exterior_Temperature["fahrenheit"].toInt();
    if (_GTW_Exterior_Temperature_F != JSON_Exterior_Temperature_F) {
        _GTW_Exterior_Temperature_F = JSON_Exterior_Temperature_F;
    }

    _update_Exterior_Temperature_Display_Value();
}



void Hvac::_process_Climate_States_Data(QJsonObject &data) {
    bool JSON_Climate_ON = data["climate_ON"].toBool();
    if (_GTW_Climate_ON != JSON_Climate_ON) {
        _GTW_Climate_ON = JSON_Climate_ON;
        _update_Driver_Temperature_Display_Value();
    }

    QString JSON_Auto_State = data["auto_State"].toString();
    if (_GTW_Auto_State != JSON_Auto_State) {
        _GTW_Auto_State = JSON_Auto_State;
    }
}



void Hvac::_process_Fan_Speed_Data(QJsonObject &data) {
    int JSON_Fan_Speed = data["fan_Speed"].toInt();
    if (_GTW_Fan_Speed != JSON_Fan_Speed) {
        _GTW_Fan_Speed = JSON_Fan_Speed;
    }
}



void Hvac::_process_Driver_Temperature_Data(QJsonObject &data) {
    QJsonObject driver_Temperature = data["driver_Temperature"].toObject();

    double JSON_Driver_Temperature_C = driver_Temperature["celsius"].toDouble();
    if (_GTW_Driver_Temperature_C != JSON_Driver_Temperature_C) {
        _GTW_Driver_Temperature_C = JSON_Driver_Temperature_C;
        _update_Driver_Temperature_Display_Value();
    }

    double JSON_Driver_Temperature_F = driver_Temperature["fahrenheit"].toDouble();
    if (_GTW_Driver_Temperature_F != JSON_Driver_Temperature_F) {
        _GTW_Driver_Temperature_F = JSON_Driver_Temperature_F;
        _update_Driver_Temperature_Display_Value();
    }
}



void Hvac::_update_Exterior_Temperature_Display_Value() {
    if (_GTW_Temperature_Unit == "celsius") {
        if (_display_Exterior_Temperature_Value != _GTW_Exterior_Temperature_C) {
            _display_Exterior_Temperature_Value = _GTW_Exterior_Temperature_C;
            emit exterior_Temperature_Changed();
        }
    }
    else if (_GTW_Temperature_Unit == "fahrenheit") {
        if (_display_Exterior_Temperature_Value != _GTW_Exterior_Temperature_F) {
            _display_Exterior_Temperature_Value = _GTW_Exterior_Temperature_F;
            emit exterior_Temperature_Changed();
        }
    }
}



void Hvac::_update_Fan_Speed_Display_Value() {
    if (_GTW_Climate_ON) {
        if (_GTW_Auto_State == "flow+fan" || _GTW_Auto_State == "fan") {
            if (_display_Fan_Speed != "auto") {
                _display_Fan_Speed = "auto";
                emit fan_Speed_Changed();
            }
        }
        else {
            if (_display_Fan_Speed != QString::number(_GTW_Fan_Speed)) {
                _display_Fan_Speed = QString::number(_GTW_Fan_Speed);
                emit fan_Speed_Changed();
            }
        }
    }
    else {
        if (_display_Fan_Speed != "off") {
            _display_Fan_Speed = "off";
            emit fan_Speed_Changed();
        }
    }
}



void Hvac::_update_Driver_Temperature_Display_Value() {
    if (_GTW_Climate_ON) {
        if (_GTW_Driver_Temperature_C > 0 && _GTW_Driver_Temperature_C < 100) {
            if (_GTW_Temperature_Unit == "celsius") {
                if (_display_Driver_Temperature != QString::number(_GTW_Driver_Temperature_C)) {
                    _display_Driver_Temperature = QString::number(_GTW_Driver_Temperature_C);
                    emit driver_Temperature_Changed();
                }
            }
            else if (_GTW_Temperature_Unit == "fahrenheit") {
                if (_display_Driver_Temperature != QString::number(_GTW_Driver_Temperature_F)) {
                    _display_Driver_Temperature = QString::number(_GTW_Driver_Temperature_F);
                    emit driver_Temperature_Changed();
                }
            }
        }
        else {
            if (_GTW_Driver_Temperature_C <= 0) {
                if (_display_Driver_Temperature != "lo") {
                    _display_Driver_Temperature = "lo";
                    emit driver_Temperature_Changed();
                }
            }
            else if (_GTW_Driver_Temperature_C >= 100) {
                if (_display_Driver_Temperature != "hi") {
                    _display_Driver_Temperature = "hi";
                    emit driver_Temperature_Changed();
                }
            }
        }
    }
    else {
        if (_display_Driver_Temperature != "off") {
            _display_Driver_Temperature = "off";
            emit driver_Temperature_Changed();
        }
    }
}



int Hvac::get_Display_Exterior_Temperature() {
    return _display_Exterior_Temperature_Value;
}



QString Hvac::get_Display_Fan_Speed() {
    return _display_Fan_Speed;
}



QString Hvac::get_Display_Driver_Temperature() {
    return _display_Driver_Temperature;
}



QString Hvac::get_Temperature_Unit() {
    return _GTW_Temperature_Unit;
}
