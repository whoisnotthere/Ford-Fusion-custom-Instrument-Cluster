#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>



#include "src/IC_Config/ic_config.h"
#include "src/IC_Server/ic_server.h"
#include "src/IC_Preferences/ic_preferences.h"

#include "src/Vehicle_Data/vehicle_data.h"
#include "src/Vehicle_Data/Data_Units/data_units.h"
#include "src/Vehicle_Data/Powertrain/powertrain.h"
#include "src/Vehicle_Data/Powertrain/Fuel/fuel.h"
#include "src/Vehicle_Data/Vehicle_States/vehicle_states.h"
#include "src/Vehicle_Data/Instrument_Cluster_Lights/instrument_cluster_lights.h"
#include "src/Vehicle_Data/Instrument_Cluster_Lights/turn_signals.h"
#include "src/Vehicle_Data/Body/body.h"

#include "src/Vehicle_Features/vehicle_features.h"

#include "src/Appearance/appearance.h"

#include "src/Vehicle_Controls/steering_wheel_buttons.h"

#include "src/Alerts/vehicle_alerts.h"
#include "src/Alerts/internal_DTCs_handler.h"

#include "src/ADAS/ADAS.h"
#include "src/ADAS/pre-AP/pre_AP.h"

#include "src/HVAC/HVAC.h"

#include "src/TPMS/TPMS.h"

#include "src/Trips/trips.h"

#include "src/Media/now_playing.h"

#include "src/Vehicle_API/http_client.h"
#include "src/Vehicle_API/Sounds/sounds_API.h"
#include "src/Vehicle_API/HVAC/HVAC_API.h"



int main(int argc, char *argv[]) {
    qputenv("QT_ENABLE_HIGHDPI_SCALING", "0"); //Disabling high-DPI scaling (remove in production)

    QApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");

    QQmlApplicationEngine engine;
    QQmlContext *root_Context = engine.rootContext();



    IC_Config IC_CONFIG;

    IC_Preferences IC_PREFERENCES;

    HTTP_Client HTTP_CLIENT;
    Sounds_API SOUNDS_API;
    Hvac_API HVAC_API(&IC_CONFIG, &HTTP_CLIENT);

    Data_Units DATA_UNITS;
    Vehicle_States VEHICLE_STATES;
    Fuel FUEL(&DATA_UNITS);
    Powertrain POWERTRAIN(&DATA_UNITS, &FUEL);
    Turn_Signals TURN_SIGNALS(&SOUNDS_API);
    Instrument_Cluster_Lights INSTRUMENT_CLUSTER_LIGHTS(&VEHICLE_STATES, &TURN_SIGNALS);
    Safety SAFETY(&VEHICLE_STATES, &POWERTRAIN, &INSTRUMENT_CLUSTER_LIGHTS, &SOUNDS_API);
    Body BODY;
    Vehicle_Data VEHICLE_DATA(&DATA_UNITS, &INSTRUMENT_CLUSTER_LIGHTS, &POWERTRAIN, &VEHICLE_STATES, &SAFETY, &BODY);

    Vehicle_Features VEHICLE_FEATURES;

    Appearance APPEARANCE;

    Steering_Wheel_Buttons STEERING_WHEEL_BUTTONS;

    Internal_DTCs_Handler INTERNAL_DTCS_HANDLER(&VEHICLE_DATA, &SAFETY);
    Vehicle_Alerts VEHICLE_ALERTS(&VEHICLE_STATES, &INTERNAL_DTCS_HANDLER, &SOUNDS_API);

    Pre_AP PRE_AP(&POWERTRAIN, &SOUNDS_API);
    Adas ADAS(&PRE_AP);

    Hvac HVAC(&DATA_UNITS, &HVAC_API);

    Tpms TPMS(&DATA_UNITS);

    Trips TRIPS(&DATA_UNITS);

    Now_Playing NOW_PLAYING;

    IC_Server IC_SERVER(&VEHICLE_DATA, &VEHICLE_FEATURES, &APPEARANCE, &STEERING_WHEEL_BUTTONS, &ADAS, &HVAC, &TPMS, &TRIPS, &VEHICLE_ALERTS, &NOW_PLAYING);

    root_Context->setContextProperty("IC_PREFERENCES", &IC_PREFERENCES);
    root_Context->setContextProperty("VEHICLE_STATES", &VEHICLE_STATES);
    root_Context->setContextProperty("FUEL", &FUEL);
    root_Context->setContextProperty("POWERTRAIN", &POWERTRAIN);
    root_Context->setContextProperty("TURN_SIGNALS", &TURN_SIGNALS);
    root_Context->setContextProperty("INSTRUMENT_CLUSTER_LIGHTS", &INSTRUMENT_CLUSTER_LIGHTS);
    root_Context->setContextProperty("BODY", &BODY);
    root_Context->setContextProperty("VEHICLE_DATA", &VEHICLE_DATA);
    root_Context->setContextProperty("VEHICLE_FEATURES", &VEHICLE_FEATURES);
    root_Context->setContextProperty("APPEARANCE", &APPEARANCE);
    root_Context->setContextProperty("STEERING_WHEEL_BUTTONS", &STEERING_WHEEL_BUTTONS);
    root_Context->setContextProperty("VEHICLE_ALERTS", &VEHICLE_ALERTS);
    root_Context->setContextProperty("PRE_AP", &PRE_AP);
    root_Context->setContextProperty("HVAC", &HVAC);
    root_Context->setContextProperty("TPMS", &TPMS);
    root_Context->setContextProperty("TRIPS", &TRIPS);
    root_Context->setContextProperty("NOW_PLAYING", &NOW_PLAYING);



    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
