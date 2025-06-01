QT += quick quickcontrols2 network widgets multimedia

CONFIG += c++20

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    src/ADAS/ADAS.cpp \
    src/ADAS/pre-AP/pre_AP.cpp \
    src/Alerts/internal_DTCs_handler.cpp \
    src/Alerts/vehicle_alerts.cpp \
    src/Appearance/appearance.cpp \
    src/HVAC/HVAC.cpp \
    src/IC_Config/ic_config.cpp \
    src/IC_Preferences/ic_preferences.cpp \
    src/IC_Server/ic_server.cpp \
    src/TPMS/TPMS.cpp \
    src/Trips/trips.cpp \
    src/Vehicle_API/HVAC/HVAC_API.cpp \
    src/Vehicle_API/Sounds/sounds_API.cpp \
    src/Vehicle_API/http_client.cpp \
    src/Vehicle_Data/Body/body.cpp \
    src/Vehicle_Data/Data_Units/data_units.cpp \
    src/Vehicle_Data/Instrument_Cluster_Lights/instrument_cluster_lights.cpp \
    src/Vehicle_Data/Instrument_Cluster_Lights/turn_signals.cpp \
    src/Vehicle_Data/Powertrain/Fuel/fuel.cpp \
    src/Vehicle_Data/Powertrain/powertrain.cpp \
    src/Vehicle_Data/Safety/safety.cpp \
    src/Vehicle_Data/Vehicle_States/vehicle_states.cpp \
    src/Vehicle_Data/vehicle_data.cpp \
    src/Media/now_playing.cpp \
    src/Vehicle_Controls/steering_wheel_buttons.cpp \
    src/Vehicle_Features/vehicle_features.cpp \

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    src/ADAS/ADAS.h \
    src/ADAS/pre-AP/pre_AP.h \
    src/Alerts/internal_DTCs_handler.h \
    src/Alerts/vehicle_alerts.h \
    src/Appearance/appearance.h \
    src/HVAC/HVAC.h \
    src/IC_Config/ic_config.h \
    src/IC_Preferences/ic_preferences.h \
    src/IC_Server/ic_server.h \
    src/TPMS/TPMS.h \
    src/Trips/trips.h \
    src/Vehicle_API/HVAC/HVAC_API.h \
    src/Vehicle_API/Sounds/sounds_API.h \
    src/Vehicle_API/http_client.h \
    src/Vehicle_Data/Body/body.h \
    src/Vehicle_Data/Data_Units/data_units.h \
    src/Vehicle_Data/Instrument_Cluster_Lights/instrument_cluster_lights.h \
    src/Vehicle_Data/Instrument_Cluster_Lights/turn_signals.h \
    src/Vehicle_Data/Powertrain/Fuel/fuel.h \
    src/Vehicle_Data/Powertrain/powertrain.h \
    src/Vehicle_Data/Safety/safety.h \
    src/Vehicle_Data/Vehicle_States/vehicle_states.h \
    src/Vehicle_Data/vehicle_data.h \
    src/Media/now_playing.h \
    src/Vehicle_Controls/steering_wheel_buttons.h \
    src/Vehicle_Features/vehicle_features.h \

DISTFILES +=
