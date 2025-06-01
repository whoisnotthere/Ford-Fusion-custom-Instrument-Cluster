#include "ic_preferences.h"
#include <QDebug>

IC_Preferences::IC_Preferences(QObject *parent) : QObject(parent) {
    _load_Preferences();
}



QJsonObject IC_Preferences::_read_Preferences() {
    QString path = qApp->applicationDirPath();

    path.append("/JSON/preferences.json");
    QFile json_File(path);
    json_File.open(QIODevice::ReadOnly | QIODevice::Text);
    QByteArray data = json_File.readAll();
    json_File.close();

    QJsonDocument document = QJsonDocument::fromJson(data);
    if (document.isNull()) {
        qDebug() << "JSON Preferences Parsing Failed.";
    }
    else {
        qDebug() << "JSON Preferences Parsing Successful.";
    }

    return document.object();
}



void IC_Preferences::_write_Preferences(QJsonObject object_To_Save) {
    QString path = qApp->applicationDirPath();

    path.append("/JSON/preferences.json");
    QFile json_File(path);
    QJsonDocument document;
    document.setObject(object_To_Save);
    json_File.open(QIODevice::WriteOnly | QIODevice::Text);
    qint64 writed_Bytes = json_File.write(document.toJson(QJsonDocument::Indented));

    if (writed_Bytes > 0) {
        qDebug() << "JSON Preferences Saving Successful. Writed:" << writed_Bytes << "Bytes.";
    }
    else {
        qDebug() << "JSON Preferences Saving Failed.";
    }
}



void IC_Preferences::_save_Preferences() {
    QJsonObject preferences_JSON_Object;

    QJsonObject info_Cards_Preferences;
    info_Cards_Preferences.insert("left_Card", _card_Left);
    info_Cards_Preferences.insert("right_Card", _card_Right);
    preferences_JSON_Object.insert("info_Cards_Preferences", info_Cards_Preferences);

    preferences_JSON_Object.insert("quick_Access", _quick_Access);

    preferences_JSON_Object.insert("system_Language", _system_Language);

    _write_Preferences(preferences_JSON_Object);
}



void IC_Preferences::_load_Preferences() {
    QJsonObject preferences_JSON_Object = _read_Preferences();

    QJsonValue info_Cards_Preferences = preferences_JSON_Object["info_Cards_Preferences"];

    _card_Left = info_Cards_Preferences["left_Card"].toString(_card_Left);
    _card_Right = info_Cards_Preferences["right_Card"].toString(_card_Right);

    _quick_Access = preferences_JSON_Object["quick_Access"].toString(_quick_Access);

    _system_Language = preferences_JSON_Object["system_Language"].toString(_system_Language);
}



QString IC_Preferences::get_Card_Left() {
    return _card_Left;
}



QString IC_Preferences::get_Card_Right() {
    return _card_Right;
}



QString IC_Preferences::get_Quick_Access() {
    return _quick_Access;
}



void IC_Preferences::set_Card_Left(QString new_Card_Value) {
    _card_Left = new_Card_Value;
    _save_Preferences();
}



void IC_Preferences::set_Card_Right(QString new_Card_Value) {
    _card_Right = new_Card_Value;
    _save_Preferences();
}



void IC_Preferences::set_Quick_Access(QString new_Value) {
    _quick_Access = new_Value;
    _save_Preferences();
}
