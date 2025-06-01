#ifndef PRE_AP_H
#define PRE_AP_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>
#include <QDebug>

#include "src/Vehicle_Data/Powertrain/powertrain.h"
#include "src/Vehicle_API/Sounds/sounds_API.h"

class Pre_AP : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool get_Speed_Restriction_State READ get_Speed_Restriction_State NOTIFY speed_Restriction_State_Changed)
    Q_PROPERTY(bool get_Speed_Special_Restriction_State READ get_Speed_Special_Restriction_State NOTIFY speed_Special_Restriction_State_Changed)
    Q_PROPERTY(bool get_Overtaking_Prohibited_State READ get_Overtaking_Prohibited_State NOTIFY overtaking_Prohibiting_State_Changed)

    Q_PROPERTY(int get_Speed_Restriction READ get_Speed_Restriction NOTIFY speed_Restriction_Changed)
    Q_PROPERTY(int get_Speed_Special_Restriction READ get_Speed_Special_Restriction NOTIFY speed_Special_Restriction_Changed)

    Q_PROPERTY(bool get_LKA_State READ get_LKA_State NOTIFY lka_State_Changed)
    Q_PROPERTY(QString get_LeftLane_State READ get_LeftLane_State NOTIFY lka_LeftLane_State_Changed)
    Q_PROPERTY(QString get_RightLane_State READ get_RightLane_State NOTIFY lka_RightLane_State_Changed)

public:
    explicit Pre_AP(Powertrain *powertrain, Sounds_API *soundsApi, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    bool get_Speed_Restriction_State();
    bool get_Speed_Special_Restriction_State();
    bool get_Overtaking_Prohibited_State();

    int get_Speed_Restriction();
    int get_Speed_Special_Restriction();

    bool get_LKA_State();
    QString get_LeftLane_State();
    QString get_RightLane_State();

signals:
    void speed_Restriction_State_Changed();
    void speed_Special_Restriction_State_Changed();
    void overtaking_Prohibiting_State_Changed();

    void speed_Restriction_Changed();
    void speed_Special_Restriction_Changed();

    void restriction_Overspeed();
    void restriction_Overspeed_Ended();
    void restriction_Special_Overspeed();
    void restriction_Special_Overspeed_Ended();

    void lka_State_Changed();
    void lka_LeftLane_State_Changed();
    void lka_RightLane_State_Changed();

private slots:
    void S_check_Vehicle_Data();

private: //Private functions
    void _process_TSR_Data(QJsonValue &data);
    void _process_TSR_Overspeed();
    void _process_LKA_Data(QJsonValue &data);

private:
    Powertrain *_POWERTRAIN;
    Sounds_API *_SOUNDS_API;

    QTimer *T_vehicle_Data_Checker;

    QString _GTW_ADAS_Units_System = "metric";

    bool _GTW_TSR_Active = false;
    bool _GTW_Speed_Restriction_Active = false;
    bool _GTW_Speed_Special_Restriction_Active = false;
    bool _GTW_Overtaking_Prohibited_Active = false;
    bool _GTW_Overspeed_Warning = true;
    bool _GTW_Overspeed_Chime = false;

    int _GTW_Restriction_Speed = 5;
    int _GTW_Restriction_Special_Speed = 5;

    bool _GTW_LKA_Active = false;
    QString _GTW_LeftLane_State = "not_Detected";
    QString _GTW_RightLane_State = "not_Detected";

    int _vehicle_Speed = 0;
    bool _overspeed = false;
    bool _overspeed_Special = false;
};

#endif // PRE_AP_H
