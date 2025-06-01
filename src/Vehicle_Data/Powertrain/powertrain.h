#ifndef POWERTRAIN_H
#define POWERTRAIN_H

#include <QObject>
#include <QJsonObject>
#include <QTimer>
#include <QDebug>
#include "../Data_Units/data_units.h"
#include "Fuel/fuel.h"

class Powertrain : public QObject {
    Q_OBJECT
    //DATA UNITS
    Q_PROPERTY(QString get_Distance_Unit READ get_Distance_Unit NOTIFY distance_Unit_Changed)
    Q_PROPERTY(QString get_Speed_Unit READ get_Speed_Unit NOTIFY speed_Unit_Changed)
    Q_PROPERTY(QString get_Temperature_Unit READ get_Temperature_Unit NOTIFY temperature_Unit_Changed)
    //SPEED
    Q_PROPERTY(double get_Vehicle_Speed_Value READ get_Vehicle_Speed_Value NOTIFY vehicle_Speed_Changed)
    //RPM
    Q_PROPERTY(int get_Engine_RPM READ get_Engine_RPM NOTIFY engine_RPM_Changed)
    //GEARBOX
    Q_PROPERTY(QString get_Shifter_Position READ get_Shifter_Position NOTIFY shifter_Position_Changed)
    Q_PROPERTY(int get_Current_Gear READ get_Current_Gear NOTIFY gear_Changed)
    //ENGINE COOLANT TEMPERATURE
    Q_PROPERTY(int get_Engine_Coolant_Temperature READ get_Engine_Coolant_Temperature NOTIFY engine_Coolant_Temperature_Changed)
    //ENGINE OIL TEMPERATURE
    Q_PROPERTY(int get_Engine_Oil_Temperature READ get_Engine_Oil_Temperature NOTIFY engine_Oil_Temperature_Changed)
    //CRUISE
    Q_PROPERTY(QString get_Cruise_State READ get_Cruise_State NOTIFY cruise_State_Changed)
    Q_PROPERTY(int get_Cruise_Speed READ get_Cruise_Speed NOTIFY cruise_Speed_Changed)


public:
    explicit Powertrain(Data_Units *dataUnits, Fuel *fuel, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    //DATA UNITS
    QString get_Distance_Unit();
    QString get_Speed_Unit();
    QString get_Temperature_Unit();
    //VALUES
    //SPEED
    double get_Vehicle_Speed_Value();
    double get_Vehicle_Speed_KPH();
    double get_Vehicle_Speed_MPH();
    //RPM
    int get_Engine_RPM();
    //GEARBOX
    QString get_Shifter_Position();
    int get_Current_Gear();
    //ENGINE COOLANT
    int get_Engine_Coolant_Temperature();
    //ENGINE OIL
    int get_Engine_Oil_Temperature();
    //CRUISE
    QString get_Cruise_State();
    int get_Cruise_Speed();

signals:
    //DATA UNITS
    void distance_Unit_Changed();
    void speed_Unit_Changed();
    void temperature_Unit_Changed();
    //VALUES
    void vehicle_Speed_Changed();
    void engine_RPM_Changed();
    void shifter_Position_Changed();
    void gear_Changed();
    void engine_Coolant_Temperature_Changed();
    void engine_Oil_Temperature_Changed();
    void cruise_State_Changed();
    void cruise_Speed_Changed();

private slots:
    void S_update_Data_Units();

private: //Private functions
    //DATA UNITS
    void _update_Data_Units();
    //VALUES
    //SPEED
    void _process_Vehicle_Speed_Data(QJsonObject &data);
    void _update_Vehicle_Speed_Value();
    //RPM
    void _process_RPM_Data(QJsonObject &data);
    //GEARBOX
    void _process_Gear_Data(QJsonObject &data);
    void _process_Shifter_Position_Data(QJsonObject &data);
    //ENGINE COOLANT
    void _process_Engine_Coolant_Temperature_Data(QJsonObject &data);
    void _update_Engine_Coolant_Temperature_Value();
    //ENGINE OIL
    void _process_Engine_Oil_Temperature_Data(QJsonObject &data);
    void _update_Engine_Oil_Temperature_Value();
    //CRUISE
    void _process_Cruise_Data(QJsonObject &data);
    void _update_Cruise_Speed_Value();

private: //Private variables
    //OBJECTS
    Data_Units *_DATA_UNITS;
    Fuel *_FUEL;

    // TIMERS
    QTimer *T_data_Units_Updater;

    //DATA UNITS
    QString _GTW_Distance_Unit = "kilometers";
    QString _GTW_Speed_Unit = "kph";
    QString _GTW_Temperature_Unit = "celsius";

    //VALUES
    //VEHICLE SPEED
    double _GTW_Vehicle_Speed_KPH = 0;
    double _GTW_Vehicle_Speed_MPH = 0;
    double _display_Vehicle_Speed_Value = 0;

    //ENGINE RPM
    int _GTW_Engine_RPM = 0;

    //GEARBOX
    QString _GTW_Shifter_Position = "unknown";
    int _GTW_Current_Gear = 0;

    //ENGINE COOLANT
    int _GTW_Engine_Coolant_C = 0;
    int _GTW_Engine_Coolant_F = 0;
    int _display_Engine_Coolant_Temperature_Value = 0;

    //ENGINE OIL
    int _GTW_Engine_Oil_C = 0;
    int _GTW_Engine_Oil_F = 0;
    int _display_Engine_Oil_Temperature_Value = 0;

    //CRUISE
    QString _GTW_Cruise_State = "off";
    int _GTW_Cruise_Speed_KPH = 0;
    int _GTW_Cruise_Speed_MPH = 0;
    int _display_Cruise_Speed_Value = 0;
};

#endif // POWERTRAIN_H
