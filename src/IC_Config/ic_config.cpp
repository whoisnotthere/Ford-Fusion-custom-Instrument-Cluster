#include "ic_config.h"

IC_Config::IC_Config(QObject *parent) : QObject{parent} {
    _load_Config();
}



QJsonObject IC_Config::_read_Config() {
    QString path = qApp->applicationDirPath();

    path.append("/JSON/config.json");
    QFile json_File(path);
    json_File.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray data = json_File.readAll();
    json_File.close();

    QJsonDocument document = QJsonDocument::fromJson(data);
    if (document.isNull()) {
        qDebug() << "JSON Config Parsing Failed.";
    }
    else {
        qDebug() << "JSON Config Parsing Successful.";
    }

    return document.object();
}



void IC_Config::_load_Config() {
    QJsonObject config_JSON_Object = _read_Config();

    _GTW_IP = config_JSON_Object["GTW_IP"].toString(_GTW_IP);
    _GTW_Port = config_JSON_Object["GTW_PORT"].toInt(_GTW_Port);
}



QString IC_Config::get_GTW_IP() {
    return _GTW_IP;
}

int IC_Config::get_GTW_Port() {
    return _GTW_Port;
}
