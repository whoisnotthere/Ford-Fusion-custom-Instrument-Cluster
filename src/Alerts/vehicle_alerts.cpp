#include "vehicle_alerts.h"

Vehicle_Alerts::Vehicle_Alerts(Vehicle_States *vehicleStates, Internal_DTCs_Handler *internalDTCsHandler, Sounds_API *soundsApi, QObject *parent) : QObject{parent},
    _VEHICLE_STATES(vehicleStates),
    _INTERNAL_DTCS_HANDLER(internalDTCsHandler),
    _SOUNDS_API(soundsApi) {
    //Timer for sending alerts to GUI
    T_alerts_Updater = new QTimer();
    T_alerts_Updater->setInterval(5000);
    connect(T_alerts_Updater, SIGNAL(timeout()), this, SLOT(S_send_Alert()));

    //Timer for starting sorting DTCs
    T_alerts_Sorting = new QTimer();
    T_alerts_Sorting->setInterval(100);
    T_alerts_Sorting->setSingleShot(true);
    connect(T_alerts_Sorting, SIGNAL(timeout()), this, SLOT(S_sort_DTCs()));

    //Timer for repeating alert sound
    T_alerts_Sound_Repeater = new QTimer();
    T_alerts_Sound_Repeater->setInterval(1650);
    connect(T_alerts_Sound_Repeater, SIGNAL(timeout()), this, SLOT(S_play_Alert_Sound()));

    //Timer for checking internal IC DTCs
    T_internal_DTCs_Checker = new QTimer();
    T_internal_DTCs_Checker->setInterval(100);
    connect(T_internal_DTCs_Checker, SIGNAL(timeout()), this, SLOT(S_process_DTCs_List()));
    T_internal_DTCs_Checker->start();

    //Timer to hide alert on GUI
    T_alert_Hide_Timer = new QTimer();
    T_alert_Hide_Timer->setInterval(250);
    T_alert_Hide_Timer->setSingleShot(true);
    connect(T_alert_Hide_Timer, SIGNAL(timeout()), this, SLOT(S_hide_Alert()));

    load_Alerts();
}



void Vehicle_Alerts::load_Alerts() {
    QString path = qApp->applicationDirPath();

    path.append("/JSON/ENG/alerts.json");
    QFile json_File(path);
    json_File.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray data = json_File.readAll();
    json_File.close();

    QJsonDocument document = QJsonDocument::fromJson(data);
    if (document.isNull()) {
        qDebug() << "JSON Alerts Parsing Failed.";
    }
    else {
        qDebug() << "JSON Alerts Parsing Successful.";
    }

    _alerts_JSON_Object = document.object();
}



void Vehicle_Alerts::process_Data(QJsonObject &data) {
    _DTC_List = data["DTC_Codes"].toArray();
}



void Vehicle_Alerts::S_process_DTCs_List() {
    QJsonArray alerts_List = _DTC_List;
    QList<QString> internal_DTCs_List = _INTERNAL_DTCS_HANDLER->return_Internal_DTCs();

    foreach (const QString &key, _current_Alerts_JSON.keys()) { //Remove outdated alerts
        if (!alerts_List.contains(key) && !internal_DTCs_List.contains(key)) {
            _current_Alerts_JSON.remove(key);
            _current_Alerts_Sorted.removeOne(key);
            _control_Alerts_Sending();

            if (_current_Alert_Code == key) {
                S_send_Alert(); //Send next alert if current displayed alert is not actual
            }
        }
    }

    foreach (const QString &key, _triggered_Alerts) {
        if (!alerts_List.contains(key) && !internal_DTCs_List.contains(key)) {
            _triggered_Alerts.removeOne(key);
        }
    }

    for (int i = 0; i < internal_DTCs_List.count(); ++i) { //Insert internal DTC to main DTC list
        if (!alerts_List.contains(internal_DTCs_List.at(i))) {
            alerts_List.append(internal_DTCs_List.at(i));
        }
    }

    for (int i = 0; i < alerts_List.size(); i++) {
        QString DTC_Code = alerts_List[i].toString();

        if (_alerts_JSON_Object.contains(DTC_Code)) { //If json localization file contains DTC message

            if (!_current_Alerts_JSON.contains(DTC_Code)) { //If current alerts NOT contains DTC
                QJsonValue alert_Data = _alerts_JSON_Object.value(DTC_Code);
                int alert_Priority = alert_Data["priority"].toInt();

                QJsonObject alert;
                alert.insert("priority", alert_Priority);

                _current_Alerts_JSON.insert(DTC_Code, alert);

                T_alerts_Sorting->start();

                if (alert_Priority >= _current_Alert_Priority) { //If new alert have more priority than current priority - display it
                    _emit_Alert(DTC_Code);
                }
            }
        }
    }
}



void Vehicle_Alerts::S_sort_DTCs() {
    _current_Alerts_Sorted.clear();

    for (const QString &key : _current_Alerts_JSON.keys()) {
        int priority = _current_Alerts_JSON.value(key).toObject().value("priority").toInt();
        int insertIndex = 0;

        while (insertIndex < _current_Alerts_Sorted.size() && priority >= _current_Alerts_JSON.value(_current_Alerts_Sorted.at(insertIndex)).toObject().value("priority").toInt()) {
            insertIndex++;
        }

        _current_Alerts_Sorted.insert(insertIndex, key);
    }

    std::reverse(_current_Alerts_Sorted.begin(), _current_Alerts_Sorted.end());

    _control_Alerts_Sending();
}



void Vehicle_Alerts::S_hide_Alert() {
    emit hide_Alert();
}



void Vehicle_Alerts::_control_Alerts_Sending() {
    if (_current_Alerts_Sorted.size() == 0) { //Stop timer if no alerts in DTC list
        T_alerts_Updater->stop();
        T_alerts_Sound_Repeater->stop();
        T_alert_Hide_Timer->start();
    }
    else {
        T_alert_Hide_Timer->stop(); //Stop alert hide timer if active

        if (!T_alerts_Updater->isActive()) { //If alerts call timer not active, starting timer
            T_alerts_Updater->start();
            S_send_Alert();
        }
    }
}



void Vehicle_Alerts::S_send_Alert() {
    if (_VEHICLE_STATES->get_WakeUp_State()) { //Send alerts to GUI only when IC in wake up state
        if (_current_Alerts_Sorted.size() == 0) {
            return;
        }

        if (_current_DTC_Index >= _current_Alerts_Sorted.size()) {
            _current_DTC_Index = 0;
        }

        QString current_DTC_Key = _current_Alerts_Sorted.at(_current_DTC_Index);
        _emit_Alert(current_DTC_Key);

        _current_DTC_Index += 1;
    }
}



void Vehicle_Alerts::_emit_Alert(QString dtc_Code) {
    if (_VEHICLE_STATES->get_WakeUp_State()) { //Send alerts to GUI only when IC in wake up state
        QJsonValue current_DTC = _alerts_JSON_Object.value(dtc_Code);
        _current_Alert_Priority = current_DTC["priority"].toInt();
        _current_Alert_Code = dtc_Code;
        _current_Alert_Header = current_DTC["header"].toString();
        _current_Alert_Body = current_DTC["body"].toString();
        _current_Alert_Style = current_DTC["style"].toString();
        _current_Alert_Custom_Icon = current_DTC["custom_Icon"].toString();
        _current_Alert_Visible = current_DTC["customer_Visible"].toBool();
        _current_Alert_Lifetime = 5000;

        T_alerts_Updater->setInterval(_current_Alert_Lifetime); //Update alerts timer interval and restart it
        T_alerts_Updater->start();

        bool repeat_Alert_Sound = current_DTC["repeat_Sound"].toBool();
        bool alert_Sound = current_DTC["sound"].toBool();
        if (!_triggered_Alerts.contains(dtc_Code)) {
            _triggered_Alerts.append(dtc_Code);

            if (alert_Sound) {
                S_play_Alert_Sound();
            }
        }

        if (repeat_Alert_Sound) {
            T_alerts_Sound_Repeater->start();
        }
        else {
            T_alerts_Sound_Repeater->stop();
        }

        emit new_Alert();
    }
}



void Vehicle_Alerts::S_play_Alert_Sound() {
    _SOUNDS_API->play_Alert_Chime();
}



int Vehicle_Alerts::return_Alert_Priority() {
    return _current_Alert_Priority;
}



QString Vehicle_Alerts::return_Alert_Code() {
    return _current_Alert_Code;
}



QString Vehicle_Alerts::return_Alert_Header() {
    return _current_Alert_Header;
}



QString Vehicle_Alerts::return_Alert_Body() {
    return _current_Alert_Body;
}



QString Vehicle_Alerts::return_Alert_Style() {
    return _current_Alert_Style;
}



QString Vehicle_Alerts::return_Alert_Custom_Icon() {
    return _current_Alert_Custom_Icon;
}



bool Vehicle_Alerts::return_Alert_Visible() {
    return _current_Alert_Visible;
}



int Vehicle_Alerts::return_Alert_Lifetime() {
    return _current_Alert_Lifetime;
}
