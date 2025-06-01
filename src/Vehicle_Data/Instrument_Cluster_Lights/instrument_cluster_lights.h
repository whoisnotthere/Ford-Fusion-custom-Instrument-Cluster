#ifndef INSTRUMENT_CLUSTER_LIGHTS_H
#define INSTRUMENT_CLUSTER_LIGHTS_H

#include <QObject>
#include <QJsonObject>
#include <QTimer>
#include <QDebug>
#include "turn_signals.h"
#include "../Vehicle_States/vehicle_states.h"

class Instrument_Cluster_Lights : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool get_DoorOpen_Light_State READ get_DoorOpen_Light_State NOTIFY doorOpen_Light_Changed)
    Q_PROPERTY(bool get_SeatBelt_Light_State READ get_SeatBelt_Light_State NOTIFY seatBelt_Light_Changed)
    Q_PROPERTY(bool get_Airbag_Light_State READ get_Airbag_Light_State NOTIFY airbag_Light_Changed)
    Q_PROPERTY(bool get_Battery_Light_State READ get_Battery_Light_State NOTIFY battery_Light_Changed)
    Q_PROPERTY(bool get_FogLights_Light_State READ get_FogLights_Light_State NOTIFY fogLights_Light_Changed)
    Q_PROPERTY(bool get_ParkingLights_Light_State READ get_ParkingLights_Light_State NOTIFY parkingLights_Light_Changed)
    Q_PROPERTY(QString get_LowBeam_Light_State READ get_LowBeam_Light_State NOTIFY lowBeam_Light_Changed)
    Q_PROPERTY(QString get_HighBeam_Light_State READ get_HighBeam_Light_State NOTIFY highBeam_Light_Changed)

    Q_PROPERTY(bool get_Coolant_Overheated_Light_State READ get_Coolant_Overheated_Light_State NOTIFY coolant_Overheated_Light_Changed)
    Q_PROPERTY(bool get_Oil_Pressure_Low_Light_State READ get_Oil_Pressure_Low_Light_State NOTIFY oil_Pressure_Low_Light_Changed)
    Q_PROPERTY(bool get_Electric_Parking_Brake_Light_State READ get_Electric_Parking_Brake_Light_State NOTIFY electric_Parking_Brake_Light_Changed)
    Q_PROPERTY(bool get_Parking_Brake_Light_State READ get_Parking_Brake_Light_State NOTIFY parking_Brake_Light_Changed)
    Q_PROPERTY(bool get_ABS_Light_State READ get_ABS_Light_State NOTIFY abs_Light_Changed)
    Q_PROPERTY(bool get_Check_Engine_Light_State READ get_Check_Engine_Light_State NOTIFY check_Engine_Light_Changed)
    Q_PROPERTY(bool get_Stability_Control_Light_State READ get_Stability_Control_Light_State NOTIFY stability_Control_Light_Changed)
    Q_PROPERTY(bool get_Stability_Control_Off_Light_State READ get_Stability_Control_Off_Light_State NOTIFY stability_Control_Off_Light_Changed)
    Q_PROPERTY(bool get_TPMS_Light_State READ get_TPMS_Light_State NOTIFY tpms_Light_Changed)



public:
    explicit Instrument_Cluster_Lights(Vehicle_States *vehicleStates, Turn_Signals *turnSignals, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    void set_SeatBelt_Light_State(QString requested_State);
    bool get_DoorOpen_Light_State();
    bool get_Airbag_Light_State();
    bool get_Battery_Light_State();
    bool get_FogLights_Light_State();
    bool get_ParkingLights_Light_State();
    bool get_SeatBelt_Light_State();
    QString get_LowBeam_Light_State(); //off - Off; auto_Off - Auto Light On, Low Beam Off; auto_On - Auto Light On, Low Beam On; regular_On - Low Beam On.
    QString get_HighBeam_Light_State(); //off - Off; auto_Off - Auto High Beam On, High Beam Off; auto_On - Auto High Beam On, High Beam On; regular_On - Auto High Beam Off, High Beam On

    bool get_Coolant_Overheated_Light_State();
    bool get_Oil_Pressure_Low_Light_State();
    bool get_Electric_Parking_Brake_Light_State();
    bool get_Parking_Brake_Light_State();
    bool get_ABS_Light_State();
    bool get_Check_Engine_Light_State();
    bool get_Stability_Control_Light_State();
    bool get_Stability_Control_Off_Light_State();
    bool get_TPMS_Light_State();



signals:
    void seatBelt_Light_Changed();
    void doorOpen_Light_Changed();
    void airbag_Light_Changed();
    void battery_Light_Changed();
    void fogLights_Light_Changed();
    void parkingLights_Light_Changed();
    void lowBeam_Light_Changed();
    void highBeam_Light_Changed();

    void coolant_Overheated_Light_Changed();
    void oil_Pressure_Low_Light_Changed();
    void electric_Parking_Brake_Light_Changed();
    void parking_Brake_Light_Changed();
    void abs_Light_Changed();
    void check_Engine_Light_Changed();
    void stability_Control_Light_Changed();
    void stability_Control_Off_Light_Changed();
    void tpms_Light_Changed();



private slots:
    void S_process_Blinks();
    void S_check_Vehicle_Data();
    void S_self_Testing_Completed();



private: //Private functions
    void _start_Lights_Testing();
    void _update_Lights_State();

    void _process_SeatBelt_Light(QString state);
    void _process_DoorOpen_Light(bool state);
    void _process_Airbag_Light(QString state);
    void _process_Battery_Light(bool state);
    void _process_FogLights_Light(bool state);
    void _process_ParkingLights_Light(bool state);
    void _process_LowBeam_Light(QString state);
    void _process_HighBeam_Light(QString state);

    void _process_CoolantOverheated_Light(bool state);
    void _process_OilPressure_Light(bool state);
    void _process_ElectricParkingBrake_Light(QString state);
    void _process_ParkingBrake_Light(QString state);
    void _process_ABS_Light(QString state);
    void _process_CheckEngine_Light(QString state);
    void _process_StabilityControl_Light(QString state);
    void _process_StabilityControlOff_Light(QString state);
    void _process_TPMS_Light(QString state);



private: //Private variables
    Vehicle_States *_VEHICLE_STATES;
    Turn_Signals *_TURN_SIGNALS;

    // TIMERS
    QTimer *T_blink_Timer;
    QTimer *T_vehicle_Data_Checker;
    QTimer *T_lights_Self_Check;

    //Vehicle States
    bool _GTW_WakeUp_State = false;
    bool _GTW_Ignition_State = false;
    // WARNING LIGHTS TEST MODE
    bool _GTW_Warning_Lights_Testing = false;
    bool _warning_Lights_Testing = false;

    //Timers intervals
    int _blink_Timer_Interval = 50; //Default value for blink timer is 50 ms, this value is used for calculating counters for slow and fast blinks

    int _blink_Slow_Interval = 400; //400 ms blink interval
    int _blink_Fast_Interval = 200; //200 ms blink interval

    //Counts calculated by dividing blink interval to timer interval
    int _blink_Slow_Count = 0;
    int _blink_Fast_Count = 0;

    int _blink_Slow_Counter = 0;
    int _blink_Fast_Counter = 0;

    bool _blink_Slow_State = false;
    bool _blink_Fast_State = false;

    // SEATBELT LIGHT
    QString _GTW_SeatBelt_Light_Requested_State = "off";
    QString _seatBelt_Light_Requested_State = "off";
    QString _seatBelt_Light_Requested_State_Default = "off";
    bool _seatBelt_Light_State = false;

    // DOOR OPEN
    bool _GTW_DoorOpen_Light_State = true;
    bool _doorOpen_Light_State = true;
    bool _doorOpen_Light_State_Default = true;

    // AIRBAG LIGHT
    QString _GTW_Airbag_Light_Requested_State = "blink_Slow";
    QString _airbag_Light_Requested_State = "blink_Slow";
    QString _airbag_Light_Requested_State_Default = "blink_Slow";
    bool _airbag_Light_State = false;

    // BATTERY LIGHT
    bool _GTW_Battery_Light_State = true;
    bool _battery_Light_State = true;
    bool _battery_Light_State_Default = true;

    // FOG LIGHT
    bool _GTW_FogLights_Light_State = false;
    bool _fogLights_Light_State = false;
    bool _fogLights_Light_State_Default = false;

    // PARKING LIGHTS LIGHT
    bool _GTW_ParkingLights_Light_State = false;
    bool _parkingLights_Light_State = false;
    bool _parkingLights_Light_State_Default = false;

    // LOWBEAM LIGHT
    QString _GTW_LowBeam_Light_State = "off";
    QString _lowBeam_Light_State = "off";
    QString _lowBeam_Light_State_Default = "off";

    // HIGHBEAM LIGHT
    QString _GTW_HighBeam_Light_State = "off";
    QString _highBeam_Light_State = "off";
    QString _highBeam_Light_State_Default = "off";

    // COOLANT OVERHEATED LIGHT
    bool _GTW_Coolant_Overheated_Light_State = true;
    bool _coolant_Overheated_Light_State = true;
    bool _coolant_Overheated_Light_State_Default = true;

    // OIL PRESSURE LOW LIGHT
    bool _GTW_Oil_Pressure_Low_State = true;
    bool _oil_Pressure_Low_State = true;
    bool _oil_Pressure_Low_State_Default = true;

    // ELECTRIC PARKING BRAKE MALFUNCTION LIGHT
    QString _GTW_Electric_Parking_Brake_Light_Requested_State = "blink_Slow";
    QString _electric_Parking_Brake_Light_Requested_State = "blink_Slow";
    QString _electric_Parking_Brake_Light_Requested_State_Default = "blink_Slow";
    bool _electric_Parking_Brake_Light_State = false;

    // PARKING BRAKE LIGHT
    QString _GTW_Parking_Brake_Light_Requested_State = "blink_Slow";
    QString _parking_Brake_Light_Requested_State = "blink_Slow";
    QString _parking_Brake_Light_Requested_State_Default = "blink_Slow";
    bool _parking_Brake_Light_State = false;

    // ABS LIGHT
    QString _GTW_ABS_Light_Requested_State = "blink_Slow";
    QString _ABS_Light_Requested_State = "blink_Slow";
    QString _ABS_Light_Requested_State_Default = "blink_Slow";
    bool _ABS_Light_State = false;

    // CHECK ENGINE LIGHT
    QString _GTW_Check_Engine_Light_Requested_State = "blink_Slow";
    QString _check_Engine_Light_Requested_State = "blink_Slow";
    QString _check_Engine_Light_Requested_State_Default = "blink_Slow";
    bool _check_Engine_Light_State = false;

    // STABILITY CONTROL LIGHT
    QString _GTW_Stability_Control_Light_Requested_State = "blink_Slow";
    QString _stability_Control_Light_Requested_State = "blink_Slow";
    QString _stability_Control_Light_Requested_State_Default = "blink_Slow";
    bool _stability_Control_Light_State = false;

    // STABILITY CONTROL OFF LIGHT
    QString _GTW_Stability_Control_Off_Light_Requested_State = "blink_Slow";
    QString _stability_Control_Off_Light_Requested_State = "blink_Slow";
    QString _stability_Control_Off_Light_Requested_State_Default = "blink_Slow";
    bool _stability_Control_Off_Light_State = false;

    // TPMS LIGHT
    QString _GTW_TPMS_Light_Requested_State = "blink_Slow";
    QString _TPMS_Light_Requested_State = "blink_Slow";
    QString _TPMS_Light_Requested_State_Default = "blink_Slow";
    bool _TPMS_Light_State = false;
};

#endif // INSTRUMENT_CLUSTER_LIGHTS_H
