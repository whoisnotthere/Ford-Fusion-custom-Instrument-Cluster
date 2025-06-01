#ifndef TPMS_H
#define TPMS_H

#include <QObject>
#include <QJsonObject>
#include <QTimer>
#include <QDebug>
#include "src/Vehicle_Data/Data_Units/data_units.h"

class Tpms : public QObject {
    Q_OBJECT
    //DATA UNITS
    Q_PROPERTY(QString get_Pressure_Unit READ get_Pressure_Unit NOTIFY pressure_Unit_Changed)
    //VALUES
    Q_PROPERTY(double get_FL_Display_Pressure READ get_FL_Display_Pressure NOTIFY fl_Pressure_Changed)
    Q_PROPERTY(double get_FR_Display_Pressure READ get_FR_Display_Pressure NOTIFY fr_Pressure_Changed)
    Q_PROPERTY(double get_RL_Display_Pressure READ get_RL_Display_Pressure NOTIFY rl_Pressure_Changed)
    Q_PROPERTY(double get_RR_Display_Pressure READ get_RR_Display_Pressure NOTIFY rr_Pressure_Changed)
    //STATES
    Q_PROPERTY(QString get_FL_Display_State READ get_FL_Display_State NOTIFY fl_Pressure_State_Changed)
    Q_PROPERTY(QString get_FR_Display_State READ get_FR_Display_State NOTIFY fr_Pressure_State_Changed)
    Q_PROPERTY(QString get_RL_Display_State READ get_RL_Display_State NOTIFY rl_Pressure_State_Changed)
    Q_PROPERTY(QString get_RR_Display_State READ get_RR_Display_State NOTIFY rr_Pressure_State_Changed)

public:
    explicit Tpms(Data_Units *dataUnits, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    //DATA UNITS
    QString get_Pressure_Unit();
    //VALUES
    double get_FL_Display_Pressure();
    double get_FR_Display_Pressure();
    double get_RL_Display_Pressure();
    double get_RR_Display_Pressure();
    //STATES
    QString get_FL_Display_State();
    QString get_FR_Display_State();
    QString get_RL_Display_State();
    QString get_RR_Display_State();

signals:
    //VALUES
    void fl_Pressure_Changed();
    void fr_Pressure_Changed();
    void rl_Pressure_Changed();
    void rr_Pressure_Changed();
    //STATES
    void fl_Pressure_State_Changed();
    void fr_Pressure_State_Changed();
    void rl_Pressure_State_Changed();
    void rr_Pressure_State_Changed();
    //DATA UNITS
    void pressure_Unit_Changed();

private slots:
    void S_update_Data_Units();

private: //Private functions
    //DATA UNITS
    void _update_Data_Units();
    //VALUES
    void _process_FL_Pressure_Data(QJsonObject &data);
    void _process_FR_Pressure_Data(QJsonObject &data);
    void _process_RL_Pressure_Data(QJsonObject &data);
    void _process_RR_Pressure_Data(QJsonObject &data);
    void _process_Display_Pressure_Value(bool force_Update = false);

private: //Private variables
    //OBJECTS
    Data_Units *_DATA_UNITS;

    //TIMERS
    QTimer *T_data_Units_Updater;

    //DATA UNITS
    QString _GTW_Pressure_Unit = "bar";

    //FRONT LEFT TIRE
    double _GTW_FL_Pressure_bar = 0;
    int _GTW_FL_Pressure_kPa = 0;
    int _GTW_FL_Pressure_psi = 0;
    QString _GTW_FL_State = "critical";

    //FRONT RIGHT TIRE
    double _GTW_FR_Pressure_bar = 0;
    int _GTW_FR_Pressure_kPa = 0;
    int _GTW_FR_Pressure_psi = 0;
    QString _GTW_FR_State = "critical";

    //REAR LEFT TIRE
    double _GTW_RL_Pressure_bar = 0;
    int _GTW_RL_Pressure_kPa = 0;
    int _GTW_RL_Pressure_psi = 0;
    QString _GTW_RL_State = "critical";

    //REAR RIGHT TIRE
    double _GTW_RR_Pressure_bar = 0;
    int _GTW_RR_Pressure_kPa = 0;
    int _GTW_RR_Pressure_psi = 0;
    QString _GTW_RR_State = "critical";

    //DISPLAY VALUES
    double _FL_Display_Pressure_Value = 0;

    double _FR_Display_Pressure_Value = 0;

    double _RL_Display_Pressure_Value = 0;

    double _RR_Display_Pressure_Value = 0;
};

#endif // TPMS_H
