#ifndef CLIMATE_H
#define CLIMATE_H

#include <QObject>
#include <QJsonObject>
#include <QTimer>
#include <QDebug>
#include "src/Vehicle_Data/Data_Units/data_units.h"
#include "src/Vehicle_API/HVAC/HVAC_API.h"

class Hvac : public QObject {
    Q_OBJECT
    //DATA
    Q_PROPERTY(int get_Display_Exterior_Temperature READ get_Display_Exterior_Temperature NOTIFY exterior_Temperature_Changed)
    Q_PROPERTY(QString get_Display_Fan_Speed READ get_Display_Fan_Speed NOTIFY fan_Speed_Changed)
    Q_PROPERTY(QString get_Display_Driver_Temperature READ get_Display_Driver_Temperature NOTIFY driver_Temperature_Changed)
    //UNITS
    Q_PROPERTY(QString get_Temperature_Unit READ get_Temperature_Unit NOTIFY temperature_Unit_Changed)

public:
    explicit Hvac(Data_Units *dataUnits, Hvac_API *hvacAPI, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    //GUI CALLS
    //DRIVER TEMPERATURE
    Q_INVOKABLE void driver_Temperature_Plus();
    Q_INVOKABLE void driver_Temperature_Minus();
    //FAN SPEED
    Q_INVOKABLE void fan_Speed_Plus();
    Q_INVOKABLE void fan_Speed_Minus();

    //DATA
    int get_Display_Exterior_Temperature();
    QString get_Display_Fan_Speed();
    QString get_Display_Driver_Temperature();
    //UNITS
    QString get_Temperature_Unit();

signals:
    //DATA
    void exterior_Temperature_Changed();
    void fan_Speed_Changed();
    void driver_Temperature_Changed();
    //UNITS
    void temperature_Unit_Changed();

private slots:
    void S_update_Data_Units();

private: //Private functions
    //PROCESS DATA
    void _update_Data_Units();
    void _process_Exterior_Temperature_Data(QJsonObject &data);
    void _process_Climate_States_Data(QJsonObject &data);
    void _process_Fan_Speed_Data(QJsonObject &data);
    void _process_Driver_Temperature_Data(QJsonObject &data);
    //UPDATE GUI VALUES
    void _update_Exterior_Temperature_Display_Value();
    void _update_Fan_Speed_Display_Value();
    void _update_Driver_Temperature_Display_Value();

private: //Private variables
    //OBJECTS
    Data_Units *_DATA_UNITS;
    Hvac_API *_HVAC_API;

    //TIMERS
    QTimer *T_data_Units_Updater;

    //UNITS
    QString _GTW_Temperature_Unit = "celsius";

    //EXTERIOR TEMPERATURE
    int _GTW_Exterior_Temperature_C = 0;
    int _GTW_Exterior_Temperature_F = 0;

    //EXTERIOR TEMPERATURE DISPLAY
    int _display_Exterior_Temperature_Value = 0;

    //CLIMATE
    //STATES
    bool _GTW_Climate_ON = false;
    QString _GTW_Auto_State = "off";

    //FAN SPEED
    int _GTW_Fan_Speed = 0;
    QString _display_Fan_Speed = "off";

    //DRIVER TEMPERATURE
    double _GTW_Driver_Temperature_C = 0;
    double _GTW_Driver_Temperature_F = 0;
    QString _display_Driver_Temperature = "off";
};

#endif // CLIMATE_H
