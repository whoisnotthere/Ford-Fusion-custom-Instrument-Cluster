#ifndef SAFETY_H
#define SAFETY_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>
#include <QTimer>

#include "src/Vehicle_Data/Vehicle_States/vehicle_states.h"
#include "src/Vehicle_Data/Powertrain/powertrain.h"
#include "src/Vehicle_Data/Instrument_Cluster_Lights/instrument_cluster_lights.h"
#include "src/Vehicle_API/Sounds/sounds_API.h"

class Safety : public QObject {
    Q_OBJECT
public:
    explicit Safety(Vehicle_States *vehicleStates, Powertrain *powertrain, Instrument_Cluster_Lights *instrumentClusterLights, Sounds_API *soundsApi, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);
    QList<QString> return_Internal_DTCs();

signals:
    void driver_SeatBelt_State_Changed();
    void passenger_SeatBelt_State_Changed();

private slots:
    void S_check_Vehicle_Data();
    void S_seatBelt_Notification();
    void S_play_SeatBelt_Sound();
    void S_internal_SeatBelt_Call_Completed();

private: //Private functions
    void _start_SeatBelt_Reminder();
    void _stop_SeatBelt_Reminder();
    void _control_SeatBelt_Indicator();
    void _control_SeatBelt_Reminder();
    QList<QString> _control_Internal_DTCs();

private: //Private variables
    Vehicle_States *_VEHICLE_STATES;
    Powertrain *_POWERTRAIN;
    Instrument_Cluster_Lights *_INSTRUMENT_CLUSTER_LIGHTS;
    Sounds_API *_SOUNDS_API;

    //Timers
    QTimer *T_vehicle_Data_Checker;
    QTimer *T_seatBelt_Notification;
    QTimer *T_play_SeatBelt_Sound;
    QTimer *T_internal_SeatBelt_Call;
    //Vehicle States
    bool _GTW_WakeUp_State = false;
    bool _GTW_Ignition_State = false;
    //Vehicle speed
    int _GTW_Vehicle_Speed_KPH = 0;
    //Seat belt reminder status
    bool _seatBelt_Reminder_Internal_Call = false;
    bool _seatBelt_Reminder_Armed = false;
    bool _seatBelt_Reminder_Active = false;
    QString _seatBelt_Indicator_Requested_State = "off";

    //Seat belts status
    bool _GTW_Driver_SeatBelt_Buckled = false;
    bool _GTW_Passenger_SeatBelt_Buckled = false;

    //Seat belts counters
    int _seatBelt_Notification_Repeats = 5;
    int _seatBelt_Notification_Counter = 0;
    int _seatBelt_Gong_Max_Count = 6;
    int _seatBelt_Gong_Counter = 0;

    //Seat belt reminder sound
    QSoundEffect _seatbelt_Sound;

};

#endif // SAFETY_H
