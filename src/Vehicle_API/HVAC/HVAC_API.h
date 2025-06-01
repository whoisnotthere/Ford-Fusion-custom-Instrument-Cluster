#ifndef HVAC_API_H
#define HVAC_API_H

#include <QObject>
#include "src/IC_Config/ic_config.h"
#include "src/Vehicle_API/http_client.h"

class Hvac_API : public QObject {
    Q_OBJECT

public:
    explicit Hvac_API(IC_Config *icConfig, HTTP_Client *httpClient, QObject *parent = nullptr);

    void toggle_Front_Climate_State();

    void request_Front_Climate_Auto_Mode();

    void driver_Temperature_Plus();
    void driver_Temperature_Minus();

    void front_Climate_Fan_Speed_Plus();
    void front_Climate_Fan_Speed_Minus();

signals:

private:
    IC_Config *_IC_CONFIG;
    HTTP_Client *_HTTP_CLIENT;

    QString _VAPI_HVAC_Endpoint = "http://127.0.0.1:8000/Vehicle_API/HVAC";

};

#endif // HVAC_API_H
