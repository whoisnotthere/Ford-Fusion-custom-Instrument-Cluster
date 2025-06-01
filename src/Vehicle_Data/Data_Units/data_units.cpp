#include "data_units.h"

Data_Units::Data_Units(QObject *parent) : QObject{parent} {

}



void Data_Units::process_Data(QJsonObject &data) {
    QString distance_Unit = data["distance_Unit"].toString();
    QString fuelDisplay_Unit = data["fuelDisplay_Unit"].toString();
    QString fuel_Unit = data["fuel_Unit"].toString();
    QString speed_Unit = data["speed_Unit"].toString();
    QString temperature_Unit = data["temperature_Unit"].toString();
    QString pressure_Unit = data["pressure_Unit"].toString();

    if (_GTW_Distance_Unit != distance_Unit) {
        if (distance_Unit == "kilometers" || distance_Unit == "miles") {
            _GTW_Distance_Unit = distance_Unit;
        }
    }

    if (_GTW_FuelDisplay_Unit != fuelDisplay_Unit) {
        if (fuelDisplay_Unit == "percent" || fuelDisplay_Unit == "distance") {
            _GTW_FuelDisplay_Unit = fuelDisplay_Unit;
        }
    }

    if (_GTW_Fuel_Unit != fuel_Unit) {
        if (fuel_Unit == "L/100km" || fuel_Unit == "MPG" || fuel_Unit == "km/L") {
            _GTW_Fuel_Unit = fuel_Unit;
        }
    }

    if (_GTW_Speed_Unit != speed_Unit) {
        if (speed_Unit == "kph" || speed_Unit == "mph") {
            _GTW_Speed_Unit = speed_Unit;
        }
    }

    if (_GTW_Temperature_Unit != temperature_Unit) {
        if (temperature_Unit == "celsius" || temperature_Unit == "fahrenheit") {
            _GTW_Temperature_Unit = temperature_Unit;
        }
    }

    if (_GTW_Pressure_Unit != pressure_Unit) {
        if (pressure_Unit == "bar" || pressure_Unit == "kPa" || pressure_Unit == "psi") {
            _GTW_Pressure_Unit = pressure_Unit;
        }
    }
}



QString Data_Units::get_Distance_Unit() {
    return _GTW_Distance_Unit;
}



QString Data_Units::get_FuelDisplay_Unit() {
    return _GTW_FuelDisplay_Unit;
}



QString Data_Units::get_Fuel_Unit() {
    return _GTW_Fuel_Unit;
}



QString Data_Units::get_Speed_Unit() {
    return _GTW_Speed_Unit;
}



QString Data_Units::get_Temperature_Unit() {
    return _GTW_Temperature_Unit;
}



QString Data_Units::get_Pressure_Unit() {
    return _GTW_Pressure_Unit;
}
