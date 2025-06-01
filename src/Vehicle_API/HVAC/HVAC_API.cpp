#include "HVAC_API.h"

Hvac_API::Hvac_API(IC_Config *icConfig,
                   HTTP_Client *httpClient,
                   QObject *parent) : QObject{parent},
    _IC_CONFIG(icConfig),
    _HTTP_CLIENT(httpClient) {
    QString config_GTW_IP = _IC_CONFIG->get_GTW_IP();
    int config_GTW_Port = _IC_CONFIG->get_GTW_Port();

    _VAPI_HVAC_Endpoint = QString("http://%1:%2/Vehicle_API/HVAC").arg(config_GTW_IP).arg(config_GTW_Port);
}



//TURN ON CLIMATE
void Hvac_API::toggle_Front_Climate_State() {
    QString endpoint = _VAPI_HVAC_Endpoint + "/Climate/Front_Climate/toggleClimateState";

    QUrl url(endpoint);
    QByteArray emptyPostData;

    _HTTP_CLIENT->send_Post_Request(url, emptyPostData);
}



//SET CLIMATE AUTO MODE
void Hvac_API::request_Front_Climate_Auto_Mode() {
    QString endpoint = _VAPI_HVAC_Endpoint + "/Climate/Front_Climate/requestAutoMode";

    QUrl url(endpoint);
    QByteArray emptyPostData;

    _HTTP_CLIENT->send_Post_Request(url, emptyPostData);
}



//DRIVER TEMPERATURE PLUS
void Hvac_API::driver_Temperature_Plus() {
    QString endpoint = _VAPI_HVAC_Endpoint + "/Climate/Front_Climate/driverTemperaturePlus";

    QUrl url(endpoint);
    QByteArray emptyPostData;

    _HTTP_CLIENT->send_Post_Request(url, emptyPostData);
}



//DRIVER TEMPERATURE MINUS
void Hvac_API::driver_Temperature_Minus() {
    QString endpoint = _VAPI_HVAC_Endpoint + "/Climate/Front_Climate/driverTemperatureMinus";

    QUrl url(endpoint);
    QByteArray emptyPostData;

    _HTTP_CLIENT->send_Post_Request(url, emptyPostData);
}



//FAN SPEED PLUS
void Hvac_API::front_Climate_Fan_Speed_Plus() {
    QString endpoint = _VAPI_HVAC_Endpoint + "/Climate/Front_Climate/fanSpeedPlus";

    QUrl url(endpoint);
    QByteArray emptyPostData;

    _HTTP_CLIENT->send_Post_Request(url, emptyPostData);
}



//FAN SPEED MINUS
void Hvac_API::front_Climate_Fan_Speed_Minus() {
    QString endpoint = _VAPI_HVAC_Endpoint + "/Climate/Front_Climate/fanSpeedMinus";

    QUrl url(endpoint);
    QByteArray emptyPostData;

    _HTTP_CLIENT->send_Post_Request(url, emptyPostData);
}
