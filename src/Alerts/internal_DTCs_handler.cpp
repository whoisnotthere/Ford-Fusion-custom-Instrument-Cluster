#include "internal_DTCs_handler.h"

Internal_DTCs_Handler::Internal_DTCs_Handler(Vehicle_Data *vehicleData, Safety *safety, QObject *parent) : QObject{parent},
    _VEHICLE_DATA(vehicleData),
    _SAFETY(safety) {
}



QList<QString> Internal_DTCs_Handler::return_Internal_DTCs() {
    QList<QString> internal_DTCs = QList<QString>();

    QList<QString> main_Vehicle_DTCs = _VEHICLE_DATA->return_Internal_DTCs();
    for (int i = 0; i < main_Vehicle_DTCs.count(); ++i) { //Insert Main Vehicle Data DTCs to main list
        internal_DTCs.append(main_Vehicle_DTCs.at(i));
    }

    QList<QString> safety_DTCs = _SAFETY->return_Internal_DTCs();
    for (int i = 0; i < safety_DTCs.count(); ++i) { //Insert Safety DTCs to main list
        internal_DTCs.append(safety_DTCs.at(i));
    }

    return internal_DTCs;
}
