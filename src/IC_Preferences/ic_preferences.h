#ifndef IC_PREFERENCES_H
#define IC_PREFERENCES_H

#include <QObject>
#include <QCoreApplication>
#include <QFile>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

class IC_Preferences : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString get_Card_Left READ get_Card_Left WRITE set_Card_Left NOTIFY card_Changed)
    Q_PROPERTY(QString get_Card_Right READ get_Card_Right WRITE set_Card_Right NOTIFY card_Changed)
    Q_PROPERTY(QString get_Quick_Access READ get_Quick_Access WRITE set_Quick_Access NOTIFY quick_Access_Changed)

public:
    explicit IC_Preferences(QObject *parent = nullptr);

    Q_INVOKABLE void set_Card_Left(QString new_Value);
    Q_INVOKABLE void set_Card_Right(QString new_Value);

    Q_INVOKABLE void set_Quick_Access(QString new_Value);

    QString get_Card_Left();
    QString get_Card_Right();

    QString get_Quick_Access();

signals:
    void card_Changed();
    void quick_Access_Changed();

private: //Private functions
    QJsonObject _read_Preferences();
    void _write_Preferences(QJsonObject object_To_Save);

    void _save_Preferences();
    void _load_Preferences();

private: //Private variables
    QString _card_Left = "empty";
    QString _card_Right = "empty";

    QString _quick_Access = "HVAC_Temperature";

    QString _system_Language = "ENG";
};

#endif // IC_PREFERENCES_H
