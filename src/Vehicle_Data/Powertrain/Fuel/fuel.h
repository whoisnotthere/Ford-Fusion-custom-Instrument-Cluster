#ifndef FUEL_H
#define FUEL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>
#include <QDebug>
#include "../../Data_Units/data_units.h"

class Fuel : public QObject {
    Q_OBJECT
    //DATA
    Q_PROPERTY(int get_Display_Fuel_Value READ get_Display_Fuel_Value NOTIFY display_Fuel_Value_Changed)
    Q_PROPERTY(QString get_Fuel_State READ get_Fuel_State NOTIFY fuel_State_Changed)
    Q_PROPERTY(double get_Display_Instant_Efficiency READ get_Display_Instant_Efficiency NOTIFY instant_Consumption_Changed)
    Q_PROPERTY(double get_Display_Instant_Consumption READ get_Display_Instant_Consumption NOTIFY instant_Consumption_Changed)
    Q_PROPERTY(double get_Display_Average_Efficiency READ get_Display_Average_Efficiency NOTIFY average_Efficiency_Changed)
    Q_PROPERTY(int get_Display_Average_Last_Reset READ get_Display_Average_Last_Reset NOTIFY average_Last_Reset_Changed)
    Q_PROPERTY(QJsonArray get_Average_Efficiency_Chart READ get_Average_Efficiency_Chart CONSTANT)
    //UNITS
    Q_PROPERTY(QString get_Distance_Unit READ get_Distance_Unit NOTIFY distance_Unit_Changed)
    Q_PROPERTY(QString get_FuelDisplay_Unit READ get_FuelDisplay_Unit NOTIFY fuel_Display_Unit_Changed)
    Q_PROPERTY(QString get_Fuel_Unit READ get_Fuel_Unit NOTIFY fuel_Unit_Changed)

public:
    explicit Fuel(Data_Units *dataUnits, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    //DATA
    int get_Display_Fuel_Value();
    QString get_Fuel_State();
    double get_Display_Instant_Efficiency();
    double get_Display_Instant_Consumption();
    double get_Display_Average_Efficiency();
    int get_Display_Average_Last_Reset();
    QJsonArray get_Average_Efficiency_Chart();
    //UNITS
    QString get_Distance_Unit();
    QString get_FuelDisplay_Unit();
    QString get_Fuel_Unit();

signals:
    //DATA
    void display_Fuel_Value_Changed();
    void fuel_State_Changed();
    void instant_Consumption_Changed();
    void average_Efficiency_Changed();
    void average_Last_Reset_Changed();
    //UNITS
    void distance_Unit_Changed();
    void fuel_Display_Unit_Changed();
    void fuel_Unit_Changed();

private slots:
    void S_update_Data_Units();

private: //Private functions
    //PROCESS DATA
    void _update_Data_Units();
    void _process_Instant_Consumption_Data(QJsonObject &data);
    void _process_Average_Efficiency_Data(QJsonObject &data);
    void _process_Average_Chart_Data(QJsonObject &data);
    //UPDATE GUI VALUES
    void _update_Fuel_Display_Value();
    void _update_Fuel_Display_Instant_Consumption();
    void _update_Fuel_Display_Average_Efficiency();

private: //Private variables
    //OBJECTS
    Data_Units *_DATA_UNITS;

    // TIMERS
    QTimer *T_data_Units_Updater;

    //UNITS
    QString _GTW_Distance_Unit = "kilometers";
    QString _GTW_FuelDisplay_Unit = "percent";
    QString _GTW_Fuel_Unit = "L/100km";

    //Vehicle States
    bool _GTW_WakeUp_State = false;
    bool _GTW_Ignition_State = false;

    //FUEL
    double _GTW_Fuel_Level = 0;
    double _GTW_Distance_To_Empty_KM = 0;
    double _GTW_Distance_To_Empty_MI = 0;
    int _display_Fuel_Value = 0;
    QString _GTW_Fuel_State = "fuel_Level_Critical";

    //INSTANT CONSUMPTION
    //BY DISTANCE
    double _GTW_Instant_Efficiency_MPG = 0;
    double _GTW_Instant_Efficiency_L100KM = 0;
    double _GTW_Instant_Efficiency_KML = 0;
    double _display_Instant_Efficiency = 0;

    //BY QUANTITY
    double _GTW_Instant_Consumption_GallonsPerHour = 0;
    double _GTW_Instant_Consumption_LitersPerHour = 0;
    double _display_Instant_Consumption = 0;

    //AVERAGE CONSUMPTION
    //QUANTITY
    double _GTW_Average_Efficiency_MPG = 0;
    double _GTW_Average_Efficiency_L100KM = 0;
    double _GTW_Average_Efficiency_KML = 0;
    double _display_Average_Efficiency = 0;

    //LAST RESET
    int _GTW_Average_Last_Reset_KM = 0;
    int _GTW_Average_Last_Reset_MI = 0;
    int _display_Average_Last_Reset = 0;

    //AVERAGE CONSUMPTION CHART
    QJsonArray _GTW_Efficiency_Chart;
};

#endif // FUEL_H
