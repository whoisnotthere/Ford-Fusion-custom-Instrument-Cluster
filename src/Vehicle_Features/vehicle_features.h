#ifndef VEHICLE_FEATURES_H
#define VEHICLE_FEATURES_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

class Vehicle_Features : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString get_Light_Switch_State READ get_Light_Switch_State NOTIFY light_Switch_State_Changed)

public:
    explicit Vehicle_Features(QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    QString get_Light_Switch_State();

signals:
    void light_Switch_State_Changed();

private:
    QString _GTW_Light_Switch_State = "off";

};

#endif // VEHICLE_FEATURES_H
