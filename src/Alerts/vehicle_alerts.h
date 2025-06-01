#ifndef VEHICLE_ALERTS_H
#define VEHICLE_ALERTS_H

#include <QObject>
#include <QFile>
#include <QTimer>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QCoreApplication>
#include <QList>
#include <QDebug>

#include "internal_DTCs_handler.h"
#include "src/Vehicle_Data/Vehicle_States/vehicle_states.h"
#include "src/Vehicle_API/Sounds/sounds_API.h"

class Vehicle_Alerts : public QObject {
    Q_OBJECT
    Q_PROPERTY(int return_Alert_Priority READ return_Alert_Priority NOTIFY new_Alert)
    Q_PROPERTY(QString return_Alert_Code READ return_Alert_Code NOTIFY new_Alert)
    Q_PROPERTY(QString return_Alert_Header READ return_Alert_Header NOTIFY new_Alert)
    Q_PROPERTY(QString return_Alert_Body READ return_Alert_Body NOTIFY new_Alert)
    Q_PROPERTY(QString return_Alert_Style READ return_Alert_Style NOTIFY new_Alert)
    Q_PROPERTY(QString return_Alert_Custom_Icon READ return_Alert_Custom_Icon NOTIFY new_Alert)
    Q_PROPERTY(bool return_Alert_Visible READ return_Alert_Visible NOTIFY new_Alert)
    Q_PROPERTY(int return_Alert_Lifetime READ return_Alert_Lifetime NOTIFY new_Alert)

public:
    explicit Vehicle_Alerts(Vehicle_States *vehicleStates, Internal_DTCs_Handler *internalDTCsHandler, Sounds_API *soundsApi, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);
    void load_Alerts();

    int return_Alert_Priority();
    QString return_Alert_Code();
    QString return_Alert_Header();
    QString return_Alert_Body();
    QString return_Alert_Style();
    QString return_Alert_Custom_Icon();
    bool return_Alert_Visible();
    int return_Alert_Lifetime();

signals:
    void new_Alert();
    void hide_Alert();

private slots:
    void S_send_Alert();
    void S_sort_DTCs();
    void S_play_Alert_Sound();
    void S_process_DTCs_List();
    void S_hide_Alert();

private: //Private functions
    void _control_Alerts_Sending();
    void _emit_Alert(QString dtc_Code);

private: //Private variables
    Internal_DTCs_Handler *_INTERNAL_DTCS_HANDLER;
    Vehicle_States *_VEHICLE_STATES;
    Sounds_API *_SOUNDS_API;

    //Gateway DTC list
    QJsonArray _DTC_List;

    //JSON transcript DTC list
    QJsonObject _alerts_JSON_Object;

    //Triggered alerts to GUI
    QList<QString> _triggered_Alerts = QList<QString>();

    //Current alerts list (internal + external from gateway)
    QJsonObject _current_Alerts_JSON;
    QList<QString> _current_Alerts_Sorted = QList<QString>();

    //Current alert index
    int _current_DTC_Index = 0;

    //Timers
    QTimer *T_alerts_Updater;
    QTimer *T_alerts_Sorting;
    QTimer *T_alerts_Sound_Repeater;
    QTimer *T_internal_DTCs_Checker;
    QTimer *T_alert_Hide_Timer;

    //Current alert GUI data
    int _current_Alert_Priority = 0;
    QString _current_Alert_Code = "";
    QString _current_Alert_Header = "";
    QString _current_Alert_Body = "";
    QString _current_Alert_Style = "";
    QString _current_Alert_Custom_Icon = "";
    bool _current_Alert_Visible = false;
    int _current_Alert_Lifetime = 1000;
};

#endif // VEHICLE_ALERTS_H
