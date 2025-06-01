#ifndef TURN_SIGNALS_H
#define TURN_SIGNALS_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

#include "src/Vehicle_API/Sounds/sounds_API.h"

class Turn_Signals : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString get_Left_Blinker_State READ get_Left_Blinker_State NOTIFY left_Blinker_Changed)
    Q_PROPERTY(QString get_Right_Blinker_State READ get_Right_Blinker_State NOTIFY right_Blinker_Changed)

public:
    explicit Turn_Signals(Sounds_API *soundsApi, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    QString get_Left_Blinker_State();
    QString get_Right_Blinker_State();

signals:
    void left_Blinker_Changed(QString state);
    void right_Blinker_Changed(QString state);

private:
    Sounds_API *_SOUNDS_API;

    QString _left_Blinker_State = "off";
    QString _right_Blinker_State = "off";

};

#endif // TURN_SIGNALS_H
