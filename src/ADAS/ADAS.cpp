#include "ADAS.h"

Adas::Adas(Pre_AP *pre_AP, QObject *parent) : QObject{parent}, _PRE_AP(pre_AP) {

}

void Adas::process_Data(QJsonObject &data) {
    QJsonValue ADAS_Data = data["data"];

    QString API_Level = ADAS_Data["API_Level"].toString();

    if (API_Level == "pre-AP") {
        _PRE_AP->process_Data(data);
    }
}
