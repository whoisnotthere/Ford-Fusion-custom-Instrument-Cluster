#ifndef IC_CONFIG_H
#define IC_CONFIG_H

#include <QObject>
#include <QCoreApplication>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QDebug>

class IC_Config : public QObject {
    Q_OBJECT

public:
    explicit IC_Config(QObject *parent = nullptr);

    QString get_GTW_IP();
    int get_GTW_Port();

signals:

private: //Private functions
    QJsonObject _read_Config();

    void _load_Config();

private: //Private variables
    QString _GTW_IP = "127.0.0.1";
    int _GTW_Port = 8000;

};

#endif // IC_CONFIG_H
