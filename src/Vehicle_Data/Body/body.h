#ifndef BODY_H
#define BODY_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

class Body : public QObject {
    Q_OBJECT

    //LIGHTS
    Q_PROPERTY(bool get_DRL_State READ get_DRL_State NOTIFY drl_State_Changed)
    Q_PROPERTY(bool get_Parking_Lights_State READ get_Parking_Lights_State NOTIFY parking_Lights_State_Changed)
    Q_PROPERTY(bool get_Low_Beam_State READ get_Low_Beam_State NOTIFY low_Beam_State_Changed)
    Q_PROPERTY(bool get_High_Beam_State READ get_High_Beam_State NOTIFY high_Beam_State_Changed)
    Q_PROPERTY(bool get_Fog_Lights_State READ get_Fog_Lights_State NOTIFY fog_Lights_State_Changed)
    Q_PROPERTY(bool get_Brake_Lights_State READ get_Brake_Lights_State NOTIFY brake_Lights_State_Changed)
    Q_PROPERTY(bool get_Reverse_Lights_State READ get_Reverse_Lights_State NOTIFY reverse_Lights_State_Changed)

    //DOORS
    Q_PROPERTY(bool get_Hood_State READ get_Hood_State NOTIFY hood_State_Changed)
    Q_PROPERTY(bool get_FrontLeftDoor_State READ get_FrontLeftDoor_State NOTIFY frontLeftDoor_State_Changed)
    Q_PROPERTY(bool get_FrontRightDoor_State READ get_FrontRightDoor_State NOTIFY frontRightDoor_State_Changed)
    Q_PROPERTY(bool get_RearLeftDoor_State READ get_RearLeftDoor_State NOTIFY rearLeftDoor_State_Changed)
    Q_PROPERTY(bool get_RearRightDoor_State READ get_RearRightDoor_State NOTIFY rearRightDoor_State_Changed)
    Q_PROPERTY(bool get_Trunk_State READ get_Trunk_State NOTIFY trunk_State_Changed)

public:
    explicit Body(QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    //LIGHTS
    bool get_DRL_State();
    bool get_Parking_Lights_State();
    bool get_Low_Beam_State();
    bool get_High_Beam_State();
    bool get_Fog_Lights_State();
    bool get_Brake_Lights_State();
    bool get_Reverse_Lights_State();

    //DOORS
    bool get_Hood_State();
    bool get_FrontLeftDoor_State();
    bool get_FrontRightDoor_State();
    bool get_RearLeftDoor_State();
    bool get_RearRightDoor_State();
    bool get_Trunk_State();

signals:
    //LIGHTS
    void drl_State_Changed();
    void parking_Lights_State_Changed();
    void low_Beam_State_Changed();
    void high_Beam_State_Changed();
    void fog_Lights_State_Changed();
    void brake_Lights_State_Changed();
    void reverse_Lights_State_Changed();

    //DOORS
    void hood_State_Changed();
    void frontLeftDoor_State_Changed();
    void frontRightDoor_State_Changed();
    void rearLeftDoor_State_Changed();
    void rearRightDoor_State_Changed();
    void trunk_State_Changed();

private:
    //LIGHTS
    bool _GTW_DRL = false;
    bool _GTW_Parking_Lights = false;
    bool _GTW_Low_Beam = false;
    bool _GTW_High_Beam = false;
    bool _GTW_Fog_Lights = false;
    bool _GTW_Brake_Light = false;
    bool _GTW_Reverse_Light = false;

    //DOORS
    bool _GTW_Hood_Is_Open = false;
    bool _GTW_FrontLeftDoor_Is_Open = false;
    bool _GTW_FrontRightDoor_Is_Open = false;
    bool _GTW_RearLeftDoor_Is_Open = false;
    bool _GTW_RearRightDoor_Is_Open = false;
    bool _GTW_Trunk_Is_Open = false;
};

#endif // BODY_H
