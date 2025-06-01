#include "steering_wheel_buttons.h"

Steering_Wheel_Buttons::Steering_Wheel_Buttons(QObject *parent) : QObject(parent) {

}



void Steering_Wheel_Buttons::process_Buttons_Data(QJsonObject &buttons_Data) {
    QJsonValue button_Key = buttons_Data["button_Name"];

    QString button_Name = button_Key.toString();
    emit button_Pressed(button_Name);
}
