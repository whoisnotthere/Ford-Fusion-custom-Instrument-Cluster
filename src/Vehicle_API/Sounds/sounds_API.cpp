#include "sounds_API.h"

Sounds_API::Sounds_API(QObject *parent) : QObject{parent} {
    //Traffic sign recognition system overspeed chime
    _TSR_Overspeed_Chime.setSource(QUrl::fromLocalFile(":/sounds/overspeed.wav"));
    _TSR_Overspeed_Chime.setVolume(1);

    //Notifications chime
    _alert_Chime.setSource(QUrl::fromLocalFile(":/sounds/alert_Chime.wav"));
    _alert_Chime.setVolume(1);

    //Turn signal chime
    _turnSignal_Tick.setSource(QUrl::fromLocalFile(":/sounds/turn_Tick.wav"));
    _turnSignal_Tick.setVolume(1);

    //Seat belt reminder chime
    _seatbelt_Chime.setSource(QUrl::fromLocalFile(":/sounds/seat_Belt.wav"));
    _seatbelt_Chime.setVolume(1);
}



void Sounds_API::play_Overspeed_Chime() {
    _TSR_Overspeed_Chime.play();
}



void Sounds_API::play_Alert_Chime() {
    _alert_Chime.play();
}



void Sounds_API::play_TurnSignal_Tick() {
    _turnSignal_Tick.play();
}



void Sounds_API::play_seatBelt_Chime() {
    _seatbelt_Chime.play();
}
