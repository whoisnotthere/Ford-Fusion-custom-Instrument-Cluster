#ifndef INTERNAL_DTCS_HANDLER_H
#define INTERNAL_DTCS_HANDLER_H

#include <QObject>
#include <QDebug>
#include "src/Vehicle_Data/vehicle_data.h"
#include "src/Vehicle_Data/Safety/safety.h"

class Internal_DTCs_Handler : public QObject {
    Q_OBJECT
public:
    explicit Internal_DTCs_Handler(Vehicle_Data *vehicleData, Safety *safety, QObject *parent = nullptr);

    QList<QString> return_Internal_DTCs();

signals:

private: //Private functions

private: //Private variables
    Vehicle_Data *_VEHICLE_DATA;
    Safety *_SAFETY;

};

#endif // INTERNAL_DTCS_HANDLER_H
