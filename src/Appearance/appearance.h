#ifndef APPEARANCE_H
#define APPEARANCE_H

#include <QObject>
#include <QJsonObject>
#include <QColor>
#include <QDebug>

class Appearance : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString get_DayNight_Mode READ get_DayNight_Mode NOTIFY dayNight_Mode_Changed)
    Q_PROPERTY(QString get_GaugeView_Mode READ get_GaugeView_Mode NOTIFY gauge_View_Changed)
    Q_PROPERTY(QString get_Vehicle_Name READ get_Vehicle_Name NOTIFY vehicle_Name_Changed)

    Q_PROPERTY(QString get_Vehicle_Body_Color READ get_Vehicle_Body_Color NOTIFY vehicle_Body_Color_Changed)
    Q_PROPERTY(double get_Vehicle_Body_Metallic_Value READ get_Vehicle_Body_Metallic_Value NOTIFY vehicle_Body_Color_Changed)
    Q_PROPERTY(double get_Vehicle_Body_Matte_Value READ get_Vehicle_Body_Matte_Value NOTIFY vehicle_Body_Color_Changed)

public:
    explicit Appearance(QObject *parent = nullptr);
    void process_Data(QJsonObject &data);

    QString get_DayNight_Mode();
    QString get_GaugeView_Mode();
    QString get_Vehicle_Name();

    QString get_Vehicle_Body_Color();
    double get_Vehicle_Body_Metallic_Value();
    double get_Vehicle_Body_Matte_Value();

signals:
    void dayNight_Mode_Changed();
    void gauge_View_Changed();
    void vehicle_Name_Changed();
    void vehicle_Body_Color_Changed();

private: //Private functions

private: //Private variables
    QString _GTW_DayNight_Mode = "day";
    QString _GTW_Gauge_View = "speedometer";
    QString _GTW_Vehicle_Name = "No car name";

    QColor _GTW_Vehicle_Color = "#7f7f7f";
    double _GTW_Vehicle_Color_Metallic = 0.1;
    double _GTW_Vehicle_Color_Matte = 0.1;

};

#endif // APPEARANCE_H
