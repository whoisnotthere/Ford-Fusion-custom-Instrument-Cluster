#ifndef DATA_UNITS_H
#define DATA_UNITS_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

class Data_Units : public QObject {
    Q_OBJECT
public:
    explicit Data_Units(QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

    QString get_Distance_Unit();
    QString get_FuelDisplay_Unit();
    QString get_Fuel_Unit();
    QString get_Speed_Unit();
    QString get_Temperature_Unit();
    QString get_Pressure_Unit();

private: //Private variables
    QString _GTW_Distance_Unit = "kilometers";
    QString _GTW_FuelDisplay_Unit = "percent";
    QString _GTW_Fuel_Unit = "L/100km";
    QString _GTW_Speed_Unit = "kph";
    QString _GTW_Temperature_Unit = "celsius";
    QString _GTW_Pressure_Unit = "bar";

};

#endif // DATA_UNITS_H
