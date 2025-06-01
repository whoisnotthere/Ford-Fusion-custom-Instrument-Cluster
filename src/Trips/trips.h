#ifndef TRIPS_H
#define TRIPS_H

#include <QObject>
#include <QJsonObject>
#include <QTimer>
#include <QDebug>
#include "src/Vehicle_Data/Data_Units/data_units.h"

class Trips : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool return_SinceLastRestart_Visible READ return_SinceLastRestart_Visible NOTIFY sinceLastRestart_Visible_Changed)
    Q_PROPERTY(bool return_SinceLastRefuel_Visible READ return_SinceLastRefuel_Visible NOTIFY sinceLastRefuel_Visible_Changed)
    Q_PROPERTY(bool return_TripA_Visible READ return_TripA_Visible NOTIFY tripA_Visible_Changed)
    Q_PROPERTY(bool return_TripB_Visible READ return_TripB_Visible NOTIFY tripB_Visible_Changed)

    //SINCE LAST RESTART
    Q_PROPERTY(double return_SinceLastRestart_Distance READ return_SinceLastRestart_Distance NOTIFY sinceLastRestart_Data_Changed)
    Q_PROPERTY(int return_SinceLastRestart_Time READ return_SinceLastRestart_Time NOTIFY sinceLastRestart_Data_Changed)
    Q_PROPERTY(double return_SinceLastRestart_Efficiency READ return_SinceLastRestart_Efficiency NOTIFY sinceLastRestart_Data_Changed)

    //SINCE LAST REFUEL
    Q_PROPERTY(double return_SinceLastRefuel_Distance READ return_SinceLastRefuel_Distance NOTIFY sinceLastRefuel_Data_Changed)
    Q_PROPERTY(int return_SinceLastRefuel_Time READ return_SinceLastRefuel_Time NOTIFY sinceLastRefuel_Data_Changed)
    Q_PROPERTY(double return_SinceLastRefuel_Efficiency READ return_SinceLastRefuel_Efficiency NOTIFY sinceLastRefuel_Data_Changed)

    //TRIP A
    Q_PROPERTY(double return_TripA_Distance READ return_TripA_Distance NOTIFY tripA_Data_Changed)
    Q_PROPERTY(int return_TripA_Time READ return_TripA_Time NOTIFY tripA_Data_Changed)
    Q_PROPERTY(double return_TripA_Efficiency READ return_TripA_Efficiency NOTIFY tripA_Data_Changed)

    //TRIP B
    Q_PROPERTY(double return_TripB_Distance READ return_TripB_Distance NOTIFY tripB_Data_Changed)
    Q_PROPERTY(int return_TripB_Time READ return_TripB_Time NOTIFY tripB_Data_Changed)
    Q_PROPERTY(double return_TripB_Efficiency READ return_TripB_Efficiency NOTIFY tripB_Data_Changed)

    //DATA UNITS
    Q_PROPERTY(QString get_Distance_Unit READ get_Distance_Unit NOTIFY distance_Unit_Changed)
    Q_PROPERTY(QString get_Fuel_Unit READ get_Fuel_Unit NOTIFY fuel_Unit_Changed)

public:
    explicit Trips(Data_Units *dataUnits, QObject *parent = nullptr);
    void process_Data(QJsonObject &data);

    bool return_SinceLastRestart_Visible();
    bool return_SinceLastRefuel_Visible();
    bool return_TripA_Visible();
    bool return_TripB_Visible();

    //SINCE LAST RESTART
    double return_SinceLastRestart_Distance();
    int return_SinceLastRestart_Time();
    double return_SinceLastRestart_Efficiency();

    //SINCE LAST REFUEL
    double return_SinceLastRefuel_Distance();
    int return_SinceLastRefuel_Time();
    double return_SinceLastRefuel_Efficiency();

    //TRIP A
    double return_TripA_Distance();
    int return_TripA_Time();
    double return_TripA_Efficiency();

    //TRIP B
    double return_TripB_Distance();
    int return_TripB_Time();
    double return_TripB_Efficiency();

    //DATA UNITS
    QString get_Distance_Unit();
    QString get_Fuel_Unit();

signals:
    void sinceLastRestart_Visible_Changed();
    void sinceLastRefuel_Visible_Changed();
    void tripA_Visible_Changed();
    void tripB_Visible_Changed();

    void sinceLastRestart_Data_Changed();
    void sinceLastRefuel_Data_Changed();
    void tripA_Data_Changed();
    void tripB_Data_Changed();

    //DATA UNITS
    void distance_Unit_Changed();
    void fuel_Unit_Changed();

private slots:
    void S_update_Data_Units();

private: //Private functions
    void _update_Display_State(QJsonObject &data);
    void _update_Trip_SinceLastRestart(QJsonObject &data);
    void _update_Trip_SinceLastRefuel(QJsonObject &data);
    void _update_Trip_A(QJsonObject &data);
    void _update_Trip_B(QJsonObject &data);
    void _update_Distance_Display_Values();
    void _update_Efficiency_Display_Values();
    void _update_Data_Units();

private: //Private variables
    //OBJECTS
    Data_Units *_DATA_UNITS;

    //TIMERS
    QTimer *T_data_Units_Updater;

    //UNITS
    QString _GTW_Distance_Unit = "kilometers";
    QString _GTW_Fuel_Unit = "L/100km";

    //TRIPS VISIBLE STATES
    bool _GTW_SinceLastRestart_Visible = true;
    bool _GTW_SinceLastRefuel_Visible = true;
    bool _GTW_TripA_Visible = true;
    bool _GTW_TripB_Visible = true;

    //Since Last Restart
    double _GTW_SinceLastRestart_Distance_KM = 0;
    double _GTW_SinceLastRestart_Distance_MI = 0;
    double _sinceLastRestart_Distance_Display = 0;
    int _GTW_SinceLastRestart_Time = 0;
    double _GTW_SinceLastRestart_Efficiency_MPG = 0;
    double _GTW_SinceLastRestart_Efficiency_L100KM = 0;
    double _GTW_SinceLastRestart_Efficiency_KML = 0;
    double _sinceLastRestart_Efficiency_Display = 0;

    //Since Last Refuel
    double _GTW_SinceLastRefuel_Distance_KM = 0;
    double _GTW_SinceLastRefuel_Distance_MI = 0;
    double _sinceLastRefuel_Distance_Display = 0;
    int _GTW_SinceLastRefuel_Time = 0;
    double _GTW_SinceLastRefuel_Efficiency_MPG = 0;
    double _GTW_SinceLastRefuel_Efficiency_L100KM = 0;
    double _GTW_SinceLastRefuel_Efficiency_KML = 0;
    double _sinceLastRefuel_Efficiency_Display = 0;

    //Trip A
    double _GTW_TripA_Distance_KM = 0;
    double _GTW_TripA_Distance_MI = 0;
    double _tripA_Distance_Display = 0;
    int _GTW_TripA_Time = 0;
    double _GTW_TripA_Efficiency_MPG = 0;
    double _GTW_TripA_Efficiency_L100KM = 0;
    double _GTW_TripA_Efficiency_KML = 0;
    double _tripA_Efficiency_Display = 0;

    //Trip B
    double _GTW_TripB_Distance_KM = 0;
    double _GTW_TripB_Distance_MI = 0;
    double _tripB_Distance_Display = 0;
    int _GTW_TripB_Time = 0;
    double _GTW_TripB_Efficiency_MPG = 0;
    double _GTW_TripB_Efficiency_L100KM = 0;
    double _GTW_TripB_Efficiency_KML = 0;
    double _tripB_Efficiency_Display = 0;
};

#endif // TRIPS_H
