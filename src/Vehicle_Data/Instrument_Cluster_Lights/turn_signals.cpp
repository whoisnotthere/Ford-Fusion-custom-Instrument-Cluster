#include "turn_signals.h"

Turn_Signals::Turn_Signals(Sounds_API *soundsApi, QObject *parent) : QObject(parent), _SOUNDS_API(soundsApi) {
}



void Turn_Signals::process_Data(QJsonObject &data) {
    bool blinker_Sound = false;

    if (_left_Blinker_State != data["left_Turn_Signal"].toString()) {
        _left_Blinker_State = data["left_Turn_Signal"].toString();

        emit left_Blinker_Changed(_left_Blinker_State);

        if (_left_Blinker_State == "on_Blink") {
            blinker_Sound = true; //Sound only when blinker is ON
        }
    }

    if (_right_Blinker_State != data["right_Turn_Signal"].toString()) {
        _right_Blinker_State = data["right_Turn_Signal"].toString();

        emit right_Blinker_Changed(_right_Blinker_State);

        if (_right_Blinker_State == "on_Blink") {
            blinker_Sound = true; //Sound only when blinker is ON
        }
    }

    if (blinker_Sound) {
        _SOUNDS_API->play_TurnSignal_Tick();
    }
}



QString Turn_Signals::get_Left_Blinker_State() {
    return _left_Blinker_State;
}



QString Turn_Signals::get_Right_Blinker_State() {
    return _right_Blinker_State;
}
