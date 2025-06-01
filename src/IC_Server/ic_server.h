#ifndef IC_SERVER_H
#define IC_SERVER_H

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QUdpSocket>
#include <QNetworkDatagram>
#include <QDebug>

#include "src/Vehicle_Data/vehicle_data.h"
#include "src/Vehicle_Features/vehicle_features.h"
#include "src/Appearance/appearance.h"
#include "src/Vehicle_Controls/steering_wheel_buttons.h"
#include "src/ADAS/ADAS.h"
#include "src/HVAC/HVAC.h"
#include "src/TPMS/TPMS.h"
#include "src/Trips/trips.h"
#include "src/Alerts/vehicle_alerts.h"
#include "src/Media/now_playing.h"

class IC_Server : public QObject {
    Q_OBJECT

public:
    explicit IC_Server(Vehicle_Data *vehicleData,
                       Vehicle_Features *vehicleFeatures,
                       Appearance *appearance,
                       Steering_Wheel_Buttons *steeringWheelButtons,
                       Adas *adas,
                       Hvac *hvac,
                       Tpms *tpms,
                       Trips *trips,
                       Vehicle_Alerts *vehicleAlerts,
                       Now_Playing *nowPlaying,
                       QObject *parent = nullptr);

signals:

private slots:
    void read_Pending_Datagrams();

private:
    QUdpSocket *_udp_Socket = nullptr;

    QJsonDocument _json_Data;
    QJsonObject _json_Object;

    Vehicle_Data *_VEHICLE_DATA;
    Vehicle_Features *_VEHICLE_FEATURES;
    Appearance *_APPEARANCE;
    Steering_Wheel_Buttons *_STEERING_WHEEL_BUTTONS;
    Adas *_ADAS;
    Hvac *_HVAC;
    Tpms *_TPMS;
    Trips *_TRIPS;
    Vehicle_Alerts *_VEHICLE_ALERTS;
    Now_Playing *_NOW_PLAYING;

};

#endif // IC_SERVER_H
