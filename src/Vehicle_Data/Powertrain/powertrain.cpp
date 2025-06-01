#include "powertrain.h"

Powertrain::Powertrain(Data_Units *dataUnits, Fuel *fuel, QObject *parent) : QObject{parent},
    _DATA_UNITS(dataUnits),
    _FUEL(fuel) {
    //Timer for updating data units
    T_data_Units_Updater = new QTimer();
    T_data_Units_Updater->setInterval(100);
    connect(T_data_Units_Updater, SIGNAL(timeout()), this, SLOT(S_update_Data_Units()));
    T_data_Units_Updater->start();
}



void Powertrain::_update_Data_Units() {
    bool data_Unit_Changed = false;

    QString distance_Unit = _DATA_UNITS->get_Distance_Unit();
    if (distance_Unit != _GTW_Distance_Unit) {
        _GTW_Distance_Unit = distance_Unit;
        data_Unit_Changed = true;
        emit distance_Unit_Changed();
    }

    QString speed_Unit = _DATA_UNITS->get_Speed_Unit();
    if (speed_Unit != _GTW_Speed_Unit) {
        _GTW_Speed_Unit = speed_Unit;
        data_Unit_Changed = true;
        emit speed_Unit_Changed();
    }

    QString temperature_Unit = _DATA_UNITS->get_Temperature_Unit();
    if (temperature_Unit != _GTW_Temperature_Unit) {
        _GTW_Temperature_Unit = temperature_Unit;
        data_Unit_Changed = true;
        emit temperature_Unit_Changed();
    }

    if (data_Unit_Changed) {
        _update_Vehicle_Speed_Value();
        _update_Engine_Coolant_Temperature_Value();
        _update_Engine_Oil_Temperature_Value();
        _update_Cruise_Speed_Value();
    }
}



void Powertrain::S_update_Data_Units() {
    _update_Data_Units();
}



void Powertrain::process_Data(QJsonObject &data) {
    QJsonObject fuel_JSON = data["fuel"].toObject();
    _FUEL->process_Data(fuel_JSON);

    _process_Vehicle_Speed_Data(data);
    _process_RPM_Data(data);
    _process_Shifter_Position_Data(data);
    _process_Gear_Data(data);
    _process_Engine_Coolant_Temperature_Data(data);
    _process_Engine_Oil_Temperature_Data(data);
    _process_Cruise_Data(data);
}



void Powertrain::_process_Vehicle_Speed_Data(QJsonObject &data) {
    QJsonObject vehicle_Speed = data["vehicle_Speed"].toObject();

    double JSON_Vehicle_Speed_KPH = vehicle_Speed["kph"].toDouble();
    if (_GTW_Vehicle_Speed_KPH != JSON_Vehicle_Speed_KPH) {
        _GTW_Vehicle_Speed_KPH = JSON_Vehicle_Speed_KPH;
    }

    double JSON_Vehicle_Speed_MPH = vehicle_Speed["mph"].toDouble();
    if (_GTW_Vehicle_Speed_MPH != JSON_Vehicle_Speed_MPH) {
        _GTW_Vehicle_Speed_MPH = JSON_Vehicle_Speed_MPH;
    }

    _update_Vehicle_Speed_Value();
}



void Powertrain::_update_Vehicle_Speed_Value() {
    if (_GTW_Speed_Unit == "kph") {
        if (_display_Vehicle_Speed_Value != _GTW_Vehicle_Speed_KPH) {
            _display_Vehicle_Speed_Value = _GTW_Vehicle_Speed_KPH;
            emit vehicle_Speed_Changed();
        }
    }
    else if (_GTW_Speed_Unit == "mph") {
        if (_display_Vehicle_Speed_Value != _GTW_Vehicle_Speed_MPH) {
            _display_Vehicle_Speed_Value = _GTW_Vehicle_Speed_MPH;
            emit vehicle_Speed_Changed();
        }
    }
}



void Powertrain::_process_RPM_Data(QJsonObject &data) {
    int engine_RPM = data["engine_RPM"].toInt();
    if (_GTW_Engine_RPM != engine_RPM) {
        _GTW_Engine_RPM = engine_RPM;
        emit engine_RPM_Changed();
    }
}



void Powertrain::_process_Shifter_Position_Data(QJsonObject &data) {
    QString shifter_Position = data["shifter_Position"].toString();

    if (shifter_Position == "parking" || shifter_Position == "reverse" || shifter_Position == "neutral" || shifter_Position == "drive" || shifter_Position == "sport" || shifter_Position == "unknown") {
        if (_GTW_Shifter_Position != shifter_Position) {
            _GTW_Shifter_Position = shifter_Position;
            emit shifter_Position_Changed();
        }
    }
    else {
        if (_GTW_Shifter_Position != "unknown") {
            _GTW_Shifter_Position = "unknown";
            emit shifter_Position_Changed();
        }
    }
}



void Powertrain::_process_Gear_Data(QJsonObject &data) {
    int gear = data["gear"].toInt();
    if (gear != _GTW_Current_Gear) {
        _GTW_Current_Gear = gear;
        emit gear_Changed();
    }
}



void Powertrain::_process_Engine_Coolant_Temperature_Data(QJsonObject &data) {
    QJsonObject coolant_Temperature = data["engine_Coolant_Temperature"].toObject();

    int celsius = coolant_Temperature["celsius"].toInt();
    if (celsius != _GTW_Engine_Coolant_C) {
        _GTW_Engine_Coolant_C = celsius;
    }

    int fahrenheit = coolant_Temperature["fahrenheit"].toInt();
    if (fahrenheit != _GTW_Engine_Coolant_F) {
        _GTW_Engine_Coolant_F = fahrenheit;
    }

    _update_Engine_Coolant_Temperature_Value();
}



void Powertrain::_update_Engine_Coolant_Temperature_Value() {
    if (_GTW_Temperature_Unit == "celsius") {
        if (_display_Engine_Coolant_Temperature_Value != _GTW_Engine_Coolant_C) {
            _display_Engine_Coolant_Temperature_Value = _GTW_Engine_Coolant_C;
            emit engine_Coolant_Temperature_Changed();
        }
    }
    else if (_GTW_Temperature_Unit == "fahrenheit") {
        if (_display_Engine_Coolant_Temperature_Value != _GTW_Engine_Coolant_F) {
            _display_Engine_Coolant_Temperature_Value = _GTW_Engine_Coolant_F;
            emit engine_Coolant_Temperature_Changed();
        }
    }
}



void Powertrain::_process_Engine_Oil_Temperature_Data(QJsonObject &data) {
    QJsonObject oil_Temperature = data["engine_Oil_Temperature"].toObject();

    int celsius = oil_Temperature["celsius"].toInt();
    if (celsius != _GTW_Engine_Oil_C) {
        _GTW_Engine_Oil_C = celsius;
    }

    int fahrenheit = oil_Temperature["fahrenheit"].toInt();
    if (fahrenheit != _GTW_Engine_Oil_F) {
        _GTW_Engine_Oil_F = fahrenheit;
    }

    _update_Engine_Oil_Temperature_Value();
}



void Powertrain::_update_Engine_Oil_Temperature_Value() {
    if (_GTW_Temperature_Unit == "celsius") {
        if (_display_Engine_Oil_Temperature_Value != _GTW_Engine_Oil_C) {
            _display_Engine_Oil_Temperature_Value = _GTW_Engine_Oil_C;
            emit engine_Oil_Temperature_Changed();
        }
    }
    else if (_GTW_Temperature_Unit == "fahrenheit") {
        if (_display_Engine_Oil_Temperature_Value != _GTW_Engine_Oil_F) {
            _display_Engine_Oil_Temperature_Value = _GTW_Engine_Oil_F;
            emit engine_Oil_Temperature_Changed();
        }
    }
}



void Powertrain::_process_Cruise_Data(QJsonObject &data) {
    QJsonObject cruise_Data = data["cruise"].toObject();

    QString cruise_State = cruise_Data["state"].toString();
    if (_GTW_Cruise_State != cruise_State) {
        _GTW_Cruise_State = cruise_State;
        emit cruise_State_Changed();
    }

    QJsonObject cruise_Speed = cruise_Data["speed"].toObject();
    int cruise_Speed_KPH = cruise_Speed["kph"].toInt();
    if (_GTW_Cruise_Speed_KPH != cruise_Speed_KPH) {
        _GTW_Cruise_Speed_KPH = cruise_Speed_KPH;
    }

    int cruise_Speed_MPH = cruise_Speed["mph"].toInt();
    if (_GTW_Cruise_Speed_MPH != cruise_Speed_MPH) {
        _GTW_Cruise_Speed_MPH = cruise_Speed_MPH;
    }

    _update_Cruise_Speed_Value();
}



void Powertrain::_update_Cruise_Speed_Value() {
    if (_GTW_Speed_Unit == "kph") {
        if (_display_Cruise_Speed_Value != _GTW_Cruise_Speed_KPH) {
            _display_Cruise_Speed_Value = _GTW_Cruise_Speed_KPH;
            emit cruise_Speed_Changed();
        }
    }
    else if (_GTW_Speed_Unit == "mph") {
        if (_display_Cruise_Speed_Value != _GTW_Cruise_Speed_MPH) {
            _display_Cruise_Speed_Value = _GTW_Cruise_Speed_MPH;
            emit cruise_Speed_Changed();
        }
    }
}



QString Powertrain::get_Distance_Unit() {
    return _GTW_Distance_Unit;
}



QString Powertrain::get_Speed_Unit() {
    return _GTW_Speed_Unit;
}



QString Powertrain::get_Temperature_Unit() {
    return _GTW_Temperature_Unit;
}



double Powertrain::get_Vehicle_Speed_Value() {
    return _display_Vehicle_Speed_Value;
}



double Powertrain::get_Vehicle_Speed_KPH() {
    return _GTW_Vehicle_Speed_KPH;
}



double Powertrain::get_Vehicle_Speed_MPH() {
    return _GTW_Vehicle_Speed_MPH;
}



int Powertrain::get_Engine_RPM() {
    return _GTW_Engine_RPM;
}



QString Powertrain::get_Shifter_Position() {
    return _GTW_Shifter_Position;
}



int Powertrain::get_Current_Gear() {
    return _GTW_Current_Gear;
}



int Powertrain::get_Engine_Coolant_Temperature() {
    return _display_Engine_Coolant_Temperature_Value;
}



int Powertrain::get_Engine_Oil_Temperature() {
    return _display_Engine_Oil_Temperature_Value;
}



QString Powertrain::get_Cruise_State() {
    return _GTW_Cruise_State;
}



int Powertrain::get_Cruise_Speed() {
    return _display_Cruise_Speed_Value;
}
