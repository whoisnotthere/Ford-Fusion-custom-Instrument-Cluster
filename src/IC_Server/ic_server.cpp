#include "ic_server.h"
#include <QDebug>

IC_Server::IC_Server(Vehicle_Data *vehicleData,
                     Vehicle_Features *vehicleFeatures,
                     Appearance *appearance,
                     Steering_Wheel_Buttons *steeringWheelButtons,
                     Adas *adas,
                     Hvac *hvac,
                     Tpms *tpms,
                     Trips *trips,
                     Vehicle_Alerts *vehicleAlerts,
                     Now_Playing *nowPlaying,
                     QObject *parent) : QObject(parent),
    _VEHICLE_DATA(vehicleData),
    _VEHICLE_FEATURES(vehicleFeatures),
    _APPEARANCE(appearance),
    _STEERING_WHEEL_BUTTONS(steeringWheelButtons),
    _ADAS(adas),
    _HVAC(hvac),
    _TPMS(tpms),
    _TRIPS(trips),
    _VEHICLE_ALERTS(vehicleAlerts),
    _NOW_PLAYING(nowPlaying) {
    _udp_Socket = new QUdpSocket(this);
    _udp_Socket->bind(QHostAddress::Any, 8080);

    connect(_udp_Socket, &QUdpSocket::readyRead, this, &IC_Server::read_Pending_Datagrams);

    if (_udp_Socket->isValid()) {
        qDebug() << "IC UDP SOCKET OPEN, and ready for use.";
        qDebug() << "IC IP:" << _udp_Socket->localAddress().toString();
        qDebug() << "IC Port:" << _udp_Socket->localPort();
    }
    else {
        qDebug() << "UDP SOCKET NOT READY.";
    }
}



void IC_Server::read_Pending_Datagrams() {
    QHostAddress sender;
    unsigned short port;

    while (_udp_Socket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(_udp_Socket->pendingDatagramSize());
        _udp_Socket->readDatagram(datagram.data(), datagram.size(), &sender, &port);

        _json_Data = QJsonDocument::fromJson(datagram);
        _json_Object = _json_Data.object();
        QString payload_ID = _json_Object["payload_ID"].toString();

        if (payload_ID == "vehicle_Data") {
            _VEHICLE_DATA->process_Vehicle_Data(_json_Object);
        }
        else if (payload_ID == "vehicle_Features") {
            _VEHICLE_FEATURES->process_Data(_json_Object);
        }
        else if (payload_ID == "appearance_Data") {
            _APPEARANCE->process_Data(_json_Object);
        }
        else if (payload_ID == "steeringWheel_Buttons") {
            _STEERING_WHEEL_BUTTONS->process_Buttons_Data(_json_Object);
        }
        else if (payload_ID == "ADAS_Data") {
            _ADAS->process_Data(_json_Object);
        }
        else if (payload_ID == "HVAC_Data") {
            _HVAC->process_Data(_json_Object);
        }
        else if (payload_ID == "TPMS_Data") {
            _TPMS->process_Data(_json_Object);
        }
        else if (payload_ID == "trips_Data") {
            _TRIPS->process_Data(_json_Object);
        }
        else if (payload_ID == "DTC_Codes") {
            _VEHICLE_ALERTS->process_Data(_json_Object);
        }
        else if (payload_ID == "media_Data") {
            _NOW_PLAYING->process_Data(_json_Object);
        }
    }
}
