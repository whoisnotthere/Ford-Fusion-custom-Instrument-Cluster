#include "appearance.h"

Appearance::Appearance(QObject *parent) : QObject{parent} {

}



void Appearance::process_Data(QJsonObject &data) {
    QJsonValue JSON_Data = data["data"];

    QString JSON_DayNight_Mode = JSON_Data["dayNight_Mode"].toString("day");
    if (JSON_DayNight_Mode != _GTW_DayNight_Mode) {
        _GTW_DayNight_Mode = JSON_DayNight_Mode;
        emit dayNight_Mode_Changed();
    }

    QString JSON_Gauge_View = JSON_Data["gauge_View"].toString("speedometer");
    if (JSON_Gauge_View != _GTW_Gauge_View) {
        _GTW_Gauge_View = JSON_Gauge_View;
        emit gauge_View_Changed();
    }

    QString JSON_Vehicle_Name = JSON_Data["vehicle_Name"].toString();
    if (JSON_Vehicle_Name != _GTW_Vehicle_Name) {
        _GTW_Vehicle_Name = JSON_Vehicle_Name;
        emit vehicle_Name_Changed();
    }

    QJsonObject vehicle_Body_Color = JSON_Data["vehicle_Body_Color"].toObject();
    QString JSON_HEX = vehicle_Body_Color["HEX"].toString();
    if (JSON_HEX != _GTW_Vehicle_Color.name()) {
        _GTW_Vehicle_Color.setNamedColor(JSON_HEX);
        emit vehicle_Body_Color_Changed();
    }

    double JSON_Metallic = vehicle_Body_Color["metallic"].toDouble();
    if (JSON_Metallic != _GTW_Vehicle_Color_Metallic) {
        _GTW_Vehicle_Color_Metallic = JSON_Metallic;
        emit vehicle_Body_Color_Changed();
    }

    double JSON_Matte = vehicle_Body_Color["matte"].toDouble();
    if (JSON_Matte != _GTW_Vehicle_Color_Matte) {
        _GTW_Vehicle_Color_Matte = JSON_Matte;
        emit vehicle_Body_Color_Changed();
    }
}



QString Appearance::get_DayNight_Mode() {
    return _GTW_DayNight_Mode;
}



QString Appearance::get_GaugeView_Mode() {
    return _GTW_Gauge_View;
}



QString Appearance::get_Vehicle_Name() {
    return _GTW_Vehicle_Name;
}

QString Appearance::get_Vehicle_Body_Color() {
    return _GTW_Vehicle_Color.name();
}

double Appearance::get_Vehicle_Body_Metallic_Value() {
    return _GTW_Vehicle_Color_Metallic;
}

double Appearance::get_Vehicle_Body_Matte_Value() {
    return _GTW_Vehicle_Color_Matte;
}
