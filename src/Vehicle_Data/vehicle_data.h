#ifndef MAIN_VEHICLE_DATA_H
#define MAIN_VEHICLE_DATA_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>
#include <QTimer>

#include "Data_Units/data_units.h"
#include "Powertrain/powertrain.h"
#include "Instrument_Cluster_Lights/instrument_cluster_lights.h"
#include "Vehicle_States/vehicle_states.h"
#include "Safety/safety.h"
#include "Body/body.h"

class Vehicle_Data : public QObject {
    Q_OBJECT
    //DATA UNITS
    Q_PROPERTY(QString get_Distance_Unit READ get_Distance_Unit NOTIFY distance_Unit_Changed)
    //VEHICLE GLOBAL TIME
    Q_PROPERTY(unsigned int get_Global_Time READ get_Global_Time NOTIFY global_Time_Changed)
    //VEHICLE ODOMETER
    Q_PROPERTY(double get_Odometer_Value READ get_Odometer_Value NOTIFY odometer_Value_Changed)

public:
    explicit Vehicle_Data(Data_Units *dataUnits,
                            Instrument_Cluster_Lights *instrumentClusterLights,
                            Powertrain *powertrain,
                            Vehicle_States *vehicleStates,
                            Safety *safety,
                            Body *body,
                            QObject *parent = nullptr);

    void process_Vehicle_Data(QJsonObject &new_Data);

    QList<QString> return_Internal_DTCs();

    //DATA UNITS
    QString get_Distance_Unit();
    //VEHICLE GLOBAL TIME
    double get_Global_Time();
    //ODOMETER
    double get_Odometer_Value();

signals:
    //DATA UNITS
    void distance_Unit_Changed();
    //VALUES
    void global_Time_Changed();
    void odometer_Value_Changed();

private slots:
    void S_data_Is_Rotten();
    void S_update_Data_Units();

private: //Private functions
    //DATA UNITS
    void _update_Data_Units();
    //INTERNAL DTCs
    QList<QString> _control_Internal_DTCs();
    //PROCESS VEHICLE GLOBAL TIME
    void _process_Global_Time_Data(QJsonObject &data);
    //ODOMETER
    void _process_Odometer_Data(QJsonObject &data);
    void _update_Odometer_Value();

private: //Private variables
    //OBJECTS
    Data_Units *_DATA_UNITS;
    Powertrain *_POWERTRAIN;
    Instrument_Cluster_Lights *_INSTRUMENT_CLUSTER_LIGHTS;
    Vehicle_States *_VEHICLE_STATES;
    Safety *_SAFETY;
    Body *_BODY;

    //TIMERS
    QTimer *T_freshness_Timer;
    QTimer *T_data_Units_Updater;

    //DATA UNITS
    QString _GTW_Distance_Unit = "kilometers";

    //VEHICLE GLOBAL TIME
    double _GTW_Global_Time = 0;

    //ODOMETER
    double _GTW_Odometer_KM = 0;
    double _GTW_Odometer_MI = 0;
    double _display_Odometer_value = 0;

    //FLAGS
    bool _data_Is_Rotten = false;

};

#endif // MAIN_VEHICLE_DATA_H
