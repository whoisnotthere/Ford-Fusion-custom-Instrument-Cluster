#include "trips.h"

Trips::Trips(Data_Units *dataUnits, QObject *parent) : QObject{parent},
    _DATA_UNITS(dataUnits) {
    //Timer for updating data units
    T_data_Units_Updater = new QTimer();
    T_data_Units_Updater->setInterval(100);
    connect(T_data_Units_Updater, SIGNAL(timeout()), this, SLOT(S_update_Data_Units()));
    T_data_Units_Updater->start();
}



void Trips::_update_Data_Units() {
    bool data_Unit_Changed = false;

    QString distance_Unit = _DATA_UNITS->get_Distance_Unit();
    if (_GTW_Distance_Unit != distance_Unit) {
        _GTW_Distance_Unit = distance_Unit;
        data_Unit_Changed = true;
        emit distance_Unit_Changed();
    }

    QString fuel_Unit = _DATA_UNITS->get_Fuel_Unit();
    if (_GTW_Fuel_Unit != fuel_Unit) {
        _GTW_Fuel_Unit = fuel_Unit;
        data_Unit_Changed = true;
        emit fuel_Unit_Changed();
    }

    if (data_Unit_Changed) {
        _update_Distance_Display_Values();
        _update_Efficiency_Display_Values();
    }
}



void Trips::S_update_Data_Units() {
    _update_Data_Units();
}



void Trips::process_Data(QJsonObject &data) {
    QJsonValue trips_Data = data["data"];

    QJsonObject display_State = trips_Data["display_State"].toObject();
    _update_Display_State(display_State);

    QJsonObject sinceLastRestart = trips_Data["sinceLastRestart"].toObject();
    _update_Trip_SinceLastRestart(sinceLastRestart);

    QJsonObject sinceLastRefuel = trips_Data["sinceLastRefuel"].toObject();
    _update_Trip_SinceLastRefuel(sinceLastRefuel);

    QJsonObject tripA = trips_Data["tripA"].toObject();
    _update_Trip_A(tripA);

    QJsonObject tripB = trips_Data["tripB"].toObject();
    _update_Trip_B(tripB);

    _update_Distance_Display_Values();
    _update_Efficiency_Display_Values();
}



void Trips::_update_Display_State(QJsonObject &data) {
    bool JSON_SinceLastRestart_Visible = data["sinceLastRestart"].toBool();
    if (_GTW_SinceLastRestart_Visible != JSON_SinceLastRestart_Visible) {
        _GTW_SinceLastRestart_Visible = JSON_SinceLastRestart_Visible;
        emit sinceLastRestart_Visible_Changed();
    }

    bool JSON_SinceLastRefuel_Visible = data["sinceLastRefuel"].toBool();
    if (_GTW_SinceLastRefuel_Visible != JSON_SinceLastRefuel_Visible) {
        _GTW_SinceLastRefuel_Visible = JSON_SinceLastRefuel_Visible;
        emit sinceLastRefuel_Visible_Changed();
    }

    bool JSON_TripA_Visible = data["tripA"].toBool();
    if (_GTW_TripA_Visible != JSON_TripA_Visible) {
        _GTW_TripA_Visible = JSON_TripA_Visible;
        emit tripA_Visible_Changed();
    }

    bool JSON_TripB_Visible = data["tripB"].toBool();
    if (_GTW_TripB_Visible != JSON_TripB_Visible) {
        _GTW_TripB_Visible = JSON_TripB_Visible;
        emit tripB_Visible_Changed();
    }
}



//SINCE LAST RESTART DATA
void Trips::_update_Trip_SinceLastRestart(QJsonObject &data) {
    QJsonObject JSON_Distance = data["distance"].toObject();

    double JSON_Distance_KM = JSON_Distance["kilometers"].toDouble();
    if (_GTW_SinceLastRestart_Distance_KM != JSON_Distance_KM) {
        _GTW_SinceLastRestart_Distance_KM = JSON_Distance_KM;
    }

    double JSON_Distance_MI = JSON_Distance["miles"].toDouble();
    if (_GTW_SinceLastRestart_Distance_MI != JSON_Distance_MI) {
        _GTW_SinceLastRestart_Distance_MI = JSON_Distance_MI;
    }

    int JSON_Time = data["time"].toInt();
    if (_GTW_SinceLastRestart_Time != JSON_Time) {
        _GTW_SinceLastRestart_Time = JSON_Time;
        emit sinceLastRestart_Data_Changed();
    }

    QJsonObject JSON_Efficiency = data["efficiency"].toObject();
    double JSON_Efficiency_MPG = JSON_Efficiency["MPG"].toDouble();
    if (_GTW_SinceLastRestart_Efficiency_MPG != JSON_Efficiency_MPG) {
        _GTW_SinceLastRestart_Efficiency_MPG = JSON_Efficiency_MPG;
    }

    double JSON_Efficiency_L100KM = JSON_Efficiency["L/100km"].toDouble();
    if (_GTW_SinceLastRestart_Efficiency_L100KM != JSON_Efficiency_L100KM) {
        _GTW_SinceLastRestart_Efficiency_L100KM = JSON_Efficiency_L100KM;
    }

    double JSON_Efficiency_KML = JSON_Efficiency["km/L"].toDouble();
    if (_GTW_SinceLastRestart_Efficiency_KML != JSON_Efficiency_KML) {
        _GTW_SinceLastRestart_Efficiency_KML = JSON_Efficiency_KML;
    }
}



//SINCE LAST REFUEL DATA
void Trips::_update_Trip_SinceLastRefuel(QJsonObject &data) {
    QJsonObject JSON_Distance = data["distance"].toObject();

    double JSON_Distance_KM = JSON_Distance["kilometers"].toDouble();
    if (_GTW_SinceLastRefuel_Distance_KM != JSON_Distance_KM) {
        _GTW_SinceLastRefuel_Distance_KM = JSON_Distance_KM;
    }

    double JSON_Distance_MI = JSON_Distance["miles"].toDouble();
    if (_GTW_SinceLastRefuel_Distance_MI != JSON_Distance_MI) {
        _GTW_SinceLastRefuel_Distance_MI = JSON_Distance_MI;
    }

    int JSON_Time = data["time"].toInt();
    if (_GTW_SinceLastRefuel_Time != JSON_Time) {
        _GTW_SinceLastRefuel_Time = JSON_Time;
        emit sinceLastRefuel_Data_Changed();
    }

    QJsonObject JSON_Efficiency = data["efficiency"].toObject();
    double JSON_Efficiency_MPG = JSON_Efficiency["MPG"].toDouble();
    if (_GTW_SinceLastRefuel_Efficiency_MPG != JSON_Efficiency_MPG) {
        _GTW_SinceLastRefuel_Efficiency_MPG = JSON_Efficiency_MPG;
    }

    double JSON_Efficiency_L100KM = JSON_Efficiency["L/100km"].toDouble();
    if (_GTW_SinceLastRefuel_Efficiency_L100KM != JSON_Efficiency_L100KM) {
        _GTW_SinceLastRefuel_Efficiency_L100KM = JSON_Efficiency_L100KM;
    }

    double JSON_Efficiency_KML = JSON_Efficiency["km/L"].toDouble();
    if (_GTW_SinceLastRefuel_Efficiency_KML != JSON_Efficiency_KML) {
        _GTW_SinceLastRefuel_Efficiency_KML = JSON_Efficiency_KML;
    }
}



//TRIP A DATA
void Trips::_update_Trip_A(QJsonObject &data) {
    QJsonObject JSON_Distance = data["distance"].toObject();

    double JSON_Distance_KM = JSON_Distance["kilometers"].toDouble();
    if (_GTW_TripA_Distance_KM != JSON_Distance_KM) {
        _GTW_TripA_Distance_KM = JSON_Distance_KM;
    }

    double JSON_Distance_MI = JSON_Distance["miles"].toDouble();
    if (_GTW_TripA_Distance_MI != JSON_Distance_MI) {
        _GTW_TripA_Distance_MI = JSON_Distance_MI;
    }

    int JSON_Time = data["time"].toInt();
    if (_GTW_TripA_Time != JSON_Time) {
        _GTW_TripA_Time = JSON_Time;
        emit tripA_Data_Changed();
    }

    QJsonObject JSON_Efficiency = data["efficiency"].toObject();
    double JSON_Efficiency_MPG = JSON_Efficiency["MPG"].toDouble();
    if (_GTW_TripA_Efficiency_MPG != JSON_Efficiency_MPG) {
        _GTW_TripA_Efficiency_MPG = JSON_Efficiency_MPG;
    }

    double JSON_Efficiency_L100KM = JSON_Efficiency["L/100km"].toDouble();
    if (_GTW_TripA_Efficiency_L100KM != JSON_Efficiency_L100KM) {
        _GTW_TripA_Efficiency_L100KM = JSON_Efficiency_L100KM;
    }

    double JSON_Efficiency_KML = JSON_Efficiency["km/L"].toDouble();
    if (_GTW_TripA_Efficiency_KML != JSON_Efficiency_KML) {
        _GTW_TripA_Efficiency_KML = JSON_Efficiency_KML;
    }
}



//TRIP B DATA
void Trips::_update_Trip_B(QJsonObject &data) {
    QJsonObject JSON_Distance = data["distance"].toObject();

    double JSON_Distance_KM = JSON_Distance["kilometers"].toDouble();
    if (_GTW_TripB_Distance_KM != JSON_Distance_KM) {
        _GTW_TripB_Distance_KM = JSON_Distance_KM;
    }

    double JSON_Distance_MI = JSON_Distance["miles"].toDouble();
    if (_GTW_TripB_Distance_MI != JSON_Distance_MI) {
        _GTW_TripB_Distance_MI = JSON_Distance_MI;
    }

    int JSON_Time = data["time"].toInt();
    if (_GTW_TripB_Time != JSON_Time) {
        _GTW_TripB_Time = JSON_Time;
        emit tripB_Data_Changed();
    }

    QJsonObject JSON_Efficiency = data["efficiency"].toObject();
    double JSON_Efficiency_MPG = JSON_Efficiency["MPG"].toDouble();
    if (_GTW_TripB_Efficiency_MPG != JSON_Efficiency_MPG) {
        _GTW_TripB_Efficiency_MPG = JSON_Efficiency_MPG;
    }

    double JSON_Efficiency_L100KM = JSON_Efficiency["L/100km"].toDouble();
    if (_GTW_TripB_Efficiency_L100KM != JSON_Efficiency_L100KM) {
        _GTW_TripB_Efficiency_L100KM = JSON_Efficiency_L100KM;
    }

    double JSON_Efficiency_KML = JSON_Efficiency["km/L"].toDouble();
    if (_GTW_TripB_Efficiency_KML != JSON_Efficiency_KML) {
        _GTW_TripB_Efficiency_KML = JSON_Efficiency_KML;
    }
}



void Trips::_update_Distance_Display_Values() {
    if (_GTW_Distance_Unit == "kilometers") {
        if (_sinceLastRestart_Distance_Display != _GTW_SinceLastRestart_Distance_KM) {
            _sinceLastRestart_Distance_Display = _GTW_SinceLastRestart_Distance_KM;
            emit sinceLastRestart_Data_Changed();
        }

        if (_sinceLastRefuel_Distance_Display != _GTW_SinceLastRefuel_Distance_KM) {
            _sinceLastRefuel_Distance_Display = _GTW_SinceLastRefuel_Distance_KM;
            emit sinceLastRefuel_Data_Changed();
        }

        if (_tripA_Distance_Display != _GTW_TripA_Distance_KM) {
            _tripA_Distance_Display = _GTW_TripA_Distance_KM;
            emit tripA_Data_Changed();
        }

        if (_tripB_Distance_Display != _GTW_TripB_Distance_KM) {
            _tripB_Distance_Display = _GTW_TripB_Distance_KM;
            emit tripB_Data_Changed();
        }
    }
    else if (_GTW_Distance_Unit == "miles") {
        if (_sinceLastRestart_Distance_Display != _GTW_SinceLastRestart_Distance_MI) {
            _sinceLastRestart_Distance_Display = _GTW_SinceLastRestart_Distance_MI;
            emit sinceLastRestart_Data_Changed();
        }

        if (_sinceLastRefuel_Distance_Display != _GTW_SinceLastRefuel_Distance_MI) {
            _sinceLastRefuel_Distance_Display = _GTW_SinceLastRefuel_Distance_MI;
            emit sinceLastRefuel_Data_Changed();
        }

        if (_tripA_Distance_Display != _GTW_TripA_Distance_MI) {
            _tripA_Distance_Display = _GTW_TripA_Distance_MI;
            emit tripA_Data_Changed();
        }

        if (_tripB_Distance_Display != _GTW_TripB_Distance_MI) {
            _tripB_Distance_Display = _GTW_TripB_Distance_MI;
            emit tripB_Data_Changed();
        }
    }
}



void Trips::_update_Efficiency_Display_Values() {
    if (_GTW_Fuel_Unit == "L/100km") {
        if (_sinceLastRestart_Efficiency_Display != _GTW_SinceLastRestart_Efficiency_L100KM) {
            _sinceLastRestart_Efficiency_Display = _GTW_SinceLastRestart_Efficiency_L100KM;
            emit sinceLastRestart_Data_Changed();
        }

        if (_sinceLastRefuel_Efficiency_Display != _GTW_SinceLastRefuel_Efficiency_L100KM) {
            _sinceLastRefuel_Efficiency_Display = _GTW_SinceLastRefuel_Efficiency_L100KM;
            emit sinceLastRefuel_Data_Changed();
        }

        if (_tripA_Efficiency_Display != _GTW_TripA_Efficiency_L100KM) {
            _tripA_Efficiency_Display = _GTW_TripA_Efficiency_L100KM;
            emit tripA_Data_Changed();
        }

        if (_tripB_Efficiency_Display != _GTW_TripB_Efficiency_L100KM) {
            _tripB_Efficiency_Display = _GTW_TripB_Efficiency_L100KM;
            emit tripB_Data_Changed();
        }
    }
    else if (_GTW_Fuel_Unit == "MPG") {
        if (_sinceLastRestart_Efficiency_Display != _GTW_SinceLastRestart_Efficiency_MPG) {
            _sinceLastRestart_Efficiency_Display = _GTW_SinceLastRestart_Efficiency_MPG;
            emit sinceLastRestart_Data_Changed();
        }

        if (_sinceLastRefuel_Efficiency_Display != _GTW_SinceLastRefuel_Efficiency_MPG) {
            _sinceLastRefuel_Efficiency_Display = _GTW_SinceLastRefuel_Efficiency_MPG;
            emit sinceLastRefuel_Data_Changed();
        }

        if (_tripA_Efficiency_Display != _GTW_TripA_Efficiency_MPG) {
            _tripA_Efficiency_Display = _GTW_TripA_Efficiency_MPG;
            emit tripA_Data_Changed();
        }

        if (_tripB_Efficiency_Display != _GTW_TripB_Efficiency_MPG) {
            _tripB_Efficiency_Display = _GTW_TripB_Efficiency_MPG;
            emit tripB_Data_Changed();
        }
    }
    else if (_GTW_Fuel_Unit == "km/L") {
        if (_sinceLastRestart_Efficiency_Display != _GTW_SinceLastRestart_Efficiency_KML) {
            _sinceLastRestart_Efficiency_Display = _GTW_SinceLastRestart_Efficiency_KML;
            emit sinceLastRestart_Data_Changed();
        }

        if (_sinceLastRefuel_Efficiency_Display != _GTW_SinceLastRefuel_Efficiency_KML) {
            _sinceLastRefuel_Efficiency_Display = _GTW_SinceLastRefuel_Efficiency_KML;
            emit sinceLastRefuel_Data_Changed();
        }

        if (_tripA_Efficiency_Display != _GTW_TripA_Efficiency_KML) {
            _tripA_Efficiency_Display = _GTW_TripA_Efficiency_KML;
            emit tripA_Data_Changed();
        }

        if (_tripB_Efficiency_Display != _GTW_TripB_Efficiency_KML) {
            _tripB_Efficiency_Display = _GTW_TripB_Efficiency_KML;
            emit tripB_Data_Changed();
        }
    }
}



//SINCE LAST RESTART
double Trips::return_SinceLastRestart_Distance() {
    return _sinceLastRestart_Distance_Display;
}

int Trips::return_SinceLastRestart_Time() {
    return _GTW_SinceLastRestart_Time;
}

double Trips::return_SinceLastRestart_Efficiency() {
    return _sinceLastRestart_Efficiency_Display;
}



//SINCE LAST REFUEL
double Trips::return_SinceLastRefuel_Distance() {
    return _sinceLastRefuel_Distance_Display;
}

int Trips::return_SinceLastRefuel_Time() {
    return _GTW_SinceLastRefuel_Time;
}

double Trips::return_SinceLastRefuel_Efficiency() {
    return _sinceLastRefuel_Efficiency_Display;
}



//TRIP A
double Trips::return_TripA_Distance() {
    return _tripA_Distance_Display;
}

int Trips::return_TripA_Time() {
    return _GTW_TripA_Time;
}

double Trips::return_TripA_Efficiency() {
    return _tripA_Efficiency_Display;
}



//TRIP B
double Trips::return_TripB_Distance() {
    return _tripB_Distance_Display;
}

int Trips::return_TripB_Time() {
    return _GTW_TripB_Time;
}

double Trips::return_TripB_Efficiency() {
    return _tripB_Efficiency_Display;
}



//TRIPS VISIBLE
bool Trips::return_SinceLastRestart_Visible() {
    return _GTW_SinceLastRestart_Visible;
}

bool Trips::return_SinceLastRefuel_Visible() {
    return _GTW_SinceLastRefuel_Visible;
}

bool Trips::return_TripA_Visible() {
    return _GTW_TripA_Visible;
}

bool Trips::return_TripB_Visible() {
    return _GTW_TripB_Visible;
}



//DATA UNITS
QString Trips::get_Distance_Unit() {
    return _GTW_Distance_Unit;
}

QString Trips::get_Fuel_Unit() {
    return _GTW_Fuel_Unit;
}
