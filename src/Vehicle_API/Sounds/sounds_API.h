#ifndef SOUNDS_API_H
#define SOUNDS_API_H

#include <QObject>
#include <QSoundEffect>

class Sounds_API : public QObject {
    Q_OBJECT

public:
    explicit Sounds_API(QObject *parent = nullptr);

    void play_Overspeed_Chime();
    void play_Alert_Chime();
    void play_TurnSignal_Tick();
    void play_seatBelt_Chime();

signals:

private:
    //Traffic sign recognition system overspeed chime
    QSoundEffect _TSR_Overspeed_Chime;

    //Notifications chime
    QSoundEffect _alert_Chime;

    //Turn signal chime
    QSoundEffect _turnSignal_Tick;

    //Seat belt reminder chime
    QSoundEffect _seatbelt_Chime;

};

#endif // SOUNDS_API_H
