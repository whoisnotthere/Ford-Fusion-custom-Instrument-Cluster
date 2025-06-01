#include "vehicle_features.h"

Vehicle_Features::Vehicle_Features(QObject *parent) : QObject{parent} {

}



void Vehicle_Features::process_Data(QJsonObject &data) {
    QJsonValue features_Data = data["data"];

    QJsonObject lighting_Data = features_Data["lighting"].toObject();

    QString light_Switch_State = lighting_Data["light_Switch_State"].toString();
    if (_GTW_Light_Switch_State != light_Switch_State) {
        _GTW_Light_Switch_State = light_Switch_State;
        emit light_Switch_State_Changed();
    }
}



QString Vehicle_Features::get_Light_Switch_State() {
    return _GTW_Light_Switch_State;
}
