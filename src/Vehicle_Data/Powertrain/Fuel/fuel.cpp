#include "fuel.h"

Fuel::Fuel(Data_Units *dataUnits, QObject *parent) : QObject{parent}, _DATA_UNITS(dataUnits) {
    //Timer for updating data units
    T_data_Units_Updater = new QTimer();
    T_data_Units_Updater->setInterval(100);
    connect(T_data_Units_Updater, SIGNAL(timeout()), this, SLOT(S_update_Data_Units()));
    T_data_Units_Updater->start();
}



void Fuel::_update_Data_Units() {
    bool data_Unit_Changed = false;

    QString distance_Unit = _DATA_UNITS->get_Distance_Unit();
    if (_GTW_Distance_Unit != distance_Unit) {
        _GTW_Distance_Unit = distance_Unit;
        data_Unit_Changed = true;
        emit distance_Unit_Changed();
    }

    QString fuel_Display_Unit = _DATA_UNITS->get_FuelDisplay_Unit();
    if (_GTW_FuelDisplay_Unit != fuel_Display_Unit) {
        _GTW_FuelDisplay_Unit = fuel_Display_Unit;
        data_Unit_Changed = true;
        emit fuel_Display_Unit_Changed();
    }

    QString fuel_Unit = _DATA_UNITS->get_Fuel_Unit();
    if (_GTW_Fuel_Unit != fuel_Unit) {
        _GTW_Fuel_Unit = fuel_Unit;
        data_Unit_Changed = true;
        emit fuel_Unit_Changed();
    }

    if (data_Unit_Changed) {
        _update_Fuel_Display_Value();
        _update_Fuel_Display_Instant_Consumption();
        _update_Fuel_Display_Average_Efficiency();
    }
}



void Fuel::S_update_Data_Units() {
    _update_Data_Units();
}



void Fuel::process_Data(QJsonObject &data) {
    double JSON_Fuel_Level = data["fuel_Level"].toDouble();
    if (_GTW_Fuel_Level != JSON_Fuel_Level) {
        _GTW_Fuel_Level = JSON_Fuel_Level;
    }

    QString fuel_State = data["fuel_State"].toString();
    if (_GTW_Fuel_State != fuel_State) {
        _GTW_Fuel_State = fuel_State;
        emit fuel_State_Changed();
    }

    QJsonObject distance_To_Empty = data["distance_To_Empty"].toObject();
    double JSON_Distance_To_Empty_KM = distance_To_Empty["kilometers"].toDouble();
    if (_GTW_Distance_To_Empty_KM != JSON_Distance_To_Empty_KM) {
        _GTW_Distance_To_Empty_KM = JSON_Distance_To_Empty_KM;
    }

    double JSON_Distance_To_Empty_MI = distance_To_Empty["miles"].toDouble();
    if (_GTW_Distance_To_Empty_MI != JSON_Distance_To_Empty_MI) {
        _GTW_Distance_To_Empty_MI = JSON_Distance_To_Empty_MI;
    }

    _process_Instant_Consumption_Data(data);
    _process_Average_Efficiency_Data(data);
    _process_Average_Chart_Data(data);

    _update_Fuel_Display_Value();
    _update_Fuel_Display_Instant_Consumption();
    _update_Fuel_Display_Average_Efficiency();
}



void Fuel::_process_Instant_Consumption_Data(QJsonObject &data) {
    QJsonObject instant_Consumption_Data = data["instant_Consumption"].toObject();

    //INSTANT CONSUMPTION EFFICIENCY
    QJsonObject instant_Efficiency = instant_Consumption_Data["efficiency"].toObject();
    double JSON_Instant_Efficiency_MPG = instant_Efficiency["MPG"].toDouble();
    if (_GTW_Instant_Efficiency_MPG != JSON_Instant_Efficiency_MPG) {
        _GTW_Instant_Efficiency_MPG = JSON_Instant_Efficiency_MPG;
    }

    double JSON_Instant_Efficiency_L100KM = instant_Efficiency["L/100km"].toDouble();
    if (_GTW_Instant_Efficiency_L100KM != JSON_Instant_Efficiency_L100KM) {
        _GTW_Instant_Efficiency_L100KM = JSON_Instant_Efficiency_L100KM;
    }

    double JSON_Instant_Efficiency_KML = instant_Efficiency["km/L"].toDouble();
    if (_GTW_Instant_Efficiency_KML != JSON_Instant_Efficiency_KML) {
        _GTW_Instant_Efficiency_KML = JSON_Instant_Efficiency_KML;
    }

    //INSTANT CONSUMPTION QUANTITY
    QJsonObject instant_Consumption = instant_Consumption_Data["consumption"].toObject();
    double JSON_Instant_Consumption_GallonsPerHour = instant_Consumption["gal/h"].toDouble();
    if (_GTW_Instant_Consumption_GallonsPerHour != JSON_Instant_Consumption_GallonsPerHour) {
        _GTW_Instant_Consumption_GallonsPerHour = JSON_Instant_Consumption_GallonsPerHour;
    }

    double JSON_Instant_Consumption_LitersPerHour = instant_Consumption["L/h"].toDouble();
    if (_GTW_Instant_Consumption_LitersPerHour != JSON_Instant_Consumption_LitersPerHour) {
        _GTW_Instant_Consumption_LitersPerHour = JSON_Instant_Consumption_LitersPerHour;
    }
}



void Fuel::_process_Average_Efficiency_Data(QJsonObject &data) {
    QJsonObject average_Consumption_Data = data["average_Consumption"].toObject();

    //AVERAGE CONSUMPTION EFFICIENCY
    QJsonObject average_Efficiency = average_Consumption_Data["efficiency"].toObject();

    double JSON_Average_Efficiency_MPG = average_Efficiency["MPG"].toDouble();
    if (_GTW_Average_Efficiency_MPG != JSON_Average_Efficiency_MPG) {
        _GTW_Average_Efficiency_MPG = JSON_Average_Efficiency_MPG;
    }

    double JSON_Average_Efficiency_L100KM = average_Efficiency["L/100km"].toDouble();
    if (_GTW_Average_Efficiency_L100KM != JSON_Average_Efficiency_L100KM) {
        _GTW_Average_Efficiency_L100KM = JSON_Average_Efficiency_L100KM;
    }

    double JSON_Average_Efficiency_KML = average_Efficiency["km/L"].toDouble();
    if (_GTW_Average_Efficiency_KML != JSON_Average_Efficiency_KML) {
        _GTW_Average_Efficiency_KML = JSON_Average_Efficiency_KML;
    }

    //AVERAGE CONSUMPTION LAST RESET
    QJsonObject average_Last_Reset = average_Consumption_Data["last_Reset"].toObject();

    //DISTANCE
    QJsonObject average_Last_Reset_Distance = average_Last_Reset["distance"].toObject();

    int JSON_Average_Last_Reset_KM = average_Last_Reset_Distance["kilometers"].toInt();
    if (_GTW_Average_Last_Reset_KM != JSON_Average_Last_Reset_KM) {
        _GTW_Average_Last_Reset_KM = JSON_Average_Last_Reset_KM;
    }

    int JSON_Average_Last_Reset_MI = average_Last_Reset_Distance["miles"].toInt();
    if (_GTW_Average_Last_Reset_MI != JSON_Average_Last_Reset_MI) {
        _GTW_Average_Last_Reset_MI = JSON_Average_Last_Reset_MI;
    }
}



void Fuel::_process_Average_Chart_Data(QJsonObject &data) {
    QJsonObject average_Consumption_Data = data["average_Consumption"].toObject();

    _GTW_Efficiency_Chart = average_Consumption_Data["chart_Data"].toArray();
}



void Fuel::_update_Fuel_Display_Value() {
    if (_GTW_FuelDisplay_Unit == "percent") {
        int fuel_Level = qRound(_GTW_Fuel_Level);

        if (_display_Fuel_Value != fuel_Level) {
            _display_Fuel_Value = fuel_Level;
            emit display_Fuel_Value_Changed();
        }
    }
    else if (_GTW_FuelDisplay_Unit == "distance") {
        if (_GTW_Distance_Unit == "kilometers") {
            int DTE_KM = qRound(_GTW_Distance_To_Empty_KM);

            if (_display_Fuel_Value != DTE_KM) {
                _display_Fuel_Value = DTE_KM;
                emit display_Fuel_Value_Changed();
            }
        }
        else if (_GTW_Distance_Unit == "miles") {
            int DTE_MI = qRound(_GTW_Distance_To_Empty_MI);

            if (_display_Fuel_Value != DTE_MI) {
                _display_Fuel_Value = DTE_MI;
                emit display_Fuel_Value_Changed();
            }
        }
    }
}



void Fuel::_update_Fuel_Display_Instant_Consumption() {
    if (_GTW_Fuel_Unit == "L/100km") {
        if (_display_Instant_Efficiency != _GTW_Instant_Efficiency_L100KM) {
            _display_Instant_Efficiency = _GTW_Instant_Efficiency_L100KM;
            emit instant_Consumption_Changed();
        }

        if (_display_Instant_Consumption != _GTW_Instant_Consumption_LitersPerHour) {
            _display_Instant_Consumption = _GTW_Instant_Consumption_LitersPerHour;
            emit instant_Consumption_Changed();
        }
    }
    else if (_GTW_Fuel_Unit == "MPG") {
        if (_display_Instant_Efficiency != _GTW_Instant_Efficiency_MPG) {
            _display_Instant_Efficiency = _GTW_Instant_Efficiency_MPG;
            emit instant_Consumption_Changed();
        }

        if (_display_Instant_Consumption != _GTW_Instant_Consumption_GallonsPerHour) {
            _display_Instant_Consumption = _GTW_Instant_Consumption_GallonsPerHour;
            emit instant_Consumption_Changed();
        }
    }
    else if (_GTW_Fuel_Unit == "km/L") {
        if (_display_Instant_Efficiency != _GTW_Instant_Efficiency_KML) {
            _display_Instant_Efficiency = _GTW_Instant_Efficiency_KML;
            emit instant_Consumption_Changed();
        }

        if (_display_Instant_Consumption != _GTW_Instant_Consumption_LitersPerHour) {
            _display_Instant_Consumption = _GTW_Instant_Consumption_LitersPerHour;
            emit instant_Consumption_Changed();
        }
    }
}



void Fuel::_update_Fuel_Display_Average_Efficiency() {
    if (_GTW_Fuel_Unit == "L/100km") {
        if (_display_Average_Efficiency != _GTW_Average_Efficiency_L100KM) {
            _display_Average_Efficiency = _GTW_Average_Efficiency_L100KM;
            emit average_Efficiency_Changed();
        }
    }
    else if (_GTW_Fuel_Unit == "MPG") {
        if (_display_Average_Efficiency != _GTW_Average_Efficiency_MPG) {
            _display_Average_Efficiency = _GTW_Average_Efficiency_MPG;
            emit average_Efficiency_Changed();
        }
    }
    else if (_GTW_Fuel_Unit == "km/L") {
        if (_display_Average_Efficiency != _GTW_Average_Efficiency_KML) {
            _display_Average_Efficiency = _GTW_Average_Efficiency_KML;
            emit average_Efficiency_Changed();
        }
    }

    if (_GTW_Distance_Unit == "kilometers") {
        if (_display_Average_Last_Reset != _GTW_Average_Last_Reset_KM) {
            _display_Average_Last_Reset = _GTW_Average_Last_Reset_KM;
            emit average_Last_Reset_Changed();
        }
    }
    else if (_GTW_Distance_Unit == "miles") {
        if (_display_Average_Last_Reset != _GTW_Average_Last_Reset_MI) {
            _display_Average_Last_Reset = _GTW_Average_Last_Reset_MI;
            emit average_Last_Reset_Changed();
        }
    }
}



int Fuel::get_Display_Fuel_Value() {
    return _display_Fuel_Value;
}



QString Fuel::get_Fuel_State() {
    return _GTW_Fuel_State;
}



double Fuel::get_Display_Instant_Efficiency() {
    return _display_Instant_Efficiency;
}



double Fuel::get_Display_Instant_Consumption() {
    return _display_Instant_Consumption;
}



double Fuel::get_Display_Average_Efficiency() {
    return _display_Average_Efficiency;
}



int Fuel::get_Display_Average_Last_Reset() {
    return _display_Average_Last_Reset;
}



QJsonArray Fuel::get_Average_Efficiency_Chart() {
    return _GTW_Efficiency_Chart;
}



QString Fuel::get_Distance_Unit() {
    return _GTW_Distance_Unit;
}



QString Fuel::get_FuelDisplay_Unit() {
    return _GTW_FuelDisplay_Unit;
}



QString Fuel::get_Fuel_Unit(){
    return _GTW_Fuel_Unit;
}
