#ifndef ADAS_H
#define ADAS_H

#include <QObject>
#include <QJsonObject>
#include <QDebug>

#include "src/ADAS/pre-AP/pre_AP.h"

class Adas : public QObject {
    Q_OBJECT
public:
    explicit Adas(Pre_AP *pre_AP, QObject *parent = nullptr);

    void process_Data(QJsonObject &data);

signals:

private:
    Pre_AP *_PRE_AP;

};

#endif // ADAS_H
