#ifndef VEHICLE_STATES_H
#define VEHICLE_STATES_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

class Vehicle_States : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool get_WakeUp_State READ get_WakeUp_State NOTIFY wakeUp_State_Changed)
    Q_PROPERTY(bool get_Ignition_State READ get_Ignition_State NOTIFY ignition_State_Changed)
    Q_PROPERTY(bool get_RemoteStart_State READ get_RemoteStart_State NOTIFY remoteStart_State_Changed)
    Q_PROPERTY(bool get_DebugMode_State READ get_DebugMode_State NOTIFY debugMode_State_Changed)

public:
    explicit Vehicle_States(QObject *parent = nullptr);
    void process_Data(QJsonObject &data);

    bool get_WakeUp_State();
    bool get_Ignition_State();
    bool get_RemoteStart_State();
    bool get_DebugMode_State();

signals:
    void wakeUp_State_Changed();
    void ignition_State_Changed();
    void remoteStart_State_Changed();
    void debugMode_State_Changed();

private:
    bool _GTW_WakeUp_State = false;
    bool _GTW_Ignition_State = false;
    bool _GTW_RemoteStart_State = false;
    bool _GTW_DebugMode_State = false;

};

#endif // VEHICLE_STATES_H
