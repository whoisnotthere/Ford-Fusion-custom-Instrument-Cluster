#ifndef STEERING_WHEEL_BUTTONS_H
#define STEERING_WHEEL_BUTTONS_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

class Steering_Wheel_Buttons : public QObject {
    Q_OBJECT
public:
    explicit Steering_Wheel_Buttons(QObject *parent = nullptr);

    void process_Buttons_Data(QJsonObject &buttons_Data);

signals:
    void button_Pressed(QString button_Name);

};

#endif // STEERING_WHEEL_BUTTONS_H
