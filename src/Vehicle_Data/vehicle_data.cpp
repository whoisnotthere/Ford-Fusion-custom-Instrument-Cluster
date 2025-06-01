#include "vehicle_data.h"

Vehicle_Data::Vehicle_Data(Data_Units *dataUnits,
                            Instrument_Cluster_Lights *instrumentClusterLights,
                            Powertrain *powertrain,
                            Vehicle_States *vehicleStates,
                            Safety *safety,
                            Body *body,
                            QObject *parent) : QObject(parent),
    _DATA_UNITS(dataUnits),
    _POWERTRAIN(powertrain),
    _INSTRUMENT_CLUSTER_LIGHTS(instrumentClusterLights),
    _VEHICLE_STATES(vehicleStates),
    _SAFETY(safety),
    _BODY(body) {
    //Timer for checking relevance of gateway data
    T_freshness_Timer = new QTimer();
    T_freshness_Timer->setInterval(250);
    connect(T_freshness_Timer, SIGNAL(timeout()), this, SLOT(S_data_Is_Rotten()));
    T_freshness_Timer->start();

    //Timer for updating data units
    T_data_Units_Updater = new QTimer();
    T_data_Units_Updater->setInterval(100);
    connect(T_data_Units_Updater, SIGNAL(timeout()), this, SLOT(S_update_Data_Units()));
    T_data_Units_Updater->start();
}



void Vehicle_Data::S_data_Is_Rotten() {
    _data_Is_Rotten = true;
    T_freshness_Timer->stop();
}



QList<QString> Vehicle_Data::return_Internal_DTCs() {
    return _control_Internal_DTCs();
}



QList<QString> Vehicle_Data::_control_Internal_DTCs() {
    QList<QString> internal_DTCs = QList<QString>();

    if (_data_Is_Rotten) {
        internal_DTCs.append("INTERNAL_DataTooOld");
    }

    return internal_DTCs;
}



void Vehicle_Data::_update_Data_Units() {
    bool data_Unit_Changed = false;

    QString distance_Unit = _DATA_UNITS->get_Distance_Unit();
    if (distance_Unit != _GTW_Distance_Unit) {
        _GTW_Distance_Unit = distance_Unit;
        data_Unit_Changed = true;
        emit distance_Unit_Changed();
    }

    if (data_Unit_Changed) {
        _update_Odometer_Value();
    }
}



void Vehicle_Data::S_update_Data_Units() {
    _update_Data_Units();
}



void Vehicle_Data::_process_Global_Time_Data(QJsonObject &data) {
    double JSON_Global_Time = data["global_Time"].toDouble();
    if (_GTW_Global_Time != JSON_Global_Time) {
        _GTW_Global_Time = JSON_Global_Time;
        emit global_Time_Changed();
    }
}



void Vehicle_Data::_process_Odometer_Data(QJsonObject &data) {
    QJsonObject odometer = data["odometer"].toObject();

    double JSON_Odometer_KM = odometer["kilometers"].toDouble();
    if (_GTW_Odometer_KM != JSON_Odometer_KM) {
        _GTW_Odometer_KM = JSON_Odometer_KM;
    }

    double JSON_Odometer_MI = odometer["miles"].toDouble();
    if (_GTW_Odometer_MI != JSON_Odometer_MI) {
        _GTW_Odometer_MI = JSON_Odometer_MI;
    }

    _update_Odometer_Value();
}



void Vehicle_Data::_update_Odometer_Value() {
    if (_GTW_Distance_Unit == "kilometers") {
        if (_display_Odometer_value != _GTW_Odometer_KM) {
            _display_Odometer_value = _GTW_Odometer_KM;
            emit odometer_Value_Changed();
        }
    }
    else if (_GTW_Distance_Unit == "miles") {
        if (_display_Odometer_value != _GTW_Odometer_MI) {
            _display_Odometer_value = _GTW_Odometer_MI;
            emit odometer_Value_Changed();
        }
    }
}



void Vehicle_Data::process_Vehicle_Data(QJsonObject &new_Data) {
    T_freshness_Timer->start();
    _data_Is_Rotten = false;

    QJsonValue vehicle_Data = new_Data["data"];

    QJsonObject data_Units_JSON = vehicle_Data["data_Units"].toObject();
    _DATA_UNITS->process_Data(data_Units_JSON);

    QJsonObject data_JSON = vehicle_Data.toObject();
    _process_Global_Time_Data(data_JSON);
    _process_Odometer_Data(data_JSON);

    QJsonObject powertrain_JSON = vehicle_Data["powertrain"].toObject();
    _POWERTRAIN->process_Data(powertrain_JSON);

    QJsonObject instrument_Cluster_Lights_JSON = vehicle_Data["instrument_Cluster_Lights"].toObject();
    _INSTRUMENT_CLUSTER_LIGHTS->process_Data(instrument_Cluster_Lights_JSON);

    QJsonObject vehicle_States_JSON = vehicle_Data["vehicle_States"].toObject();
    _VEHICLE_STATES->process_Data(vehicle_States_JSON);

    QJsonObject safety_JSON = vehicle_Data["safety"].toObject();
    _SAFETY->process_Data(safety_JSON);

    QJsonObject body_JSON = vehicle_Data["body"].toObject();
    _BODY->process_Data(body_JSON);
}



QString Vehicle_Data::get_Distance_Unit(){
    return _GTW_Distance_Unit;
}



double Vehicle_Data::get_Global_Time() {
    return _GTW_Global_Time;
}



double Vehicle_Data::get_Odometer_Value() {
    return _display_Odometer_value;
}
