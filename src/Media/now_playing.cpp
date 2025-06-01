#include "now_playing.h"

Now_Playing::Now_Playing(QObject *parent) : QObject(parent) {
    T_freshness_Timer = new QTimer();
    T_freshness_Timer->setInterval(3000);
    connect(T_freshness_Timer, SIGNAL(timeout()), this, SLOT(S_data_Is_Rotten()));
    T_freshness_Timer->start();
}



void Now_Playing::S_data_Is_Rotten() {
    if (_media_Available) {
        _media_Available = false;
        emit media_Unit_Availability_Changed();
    }
    T_freshness_Timer->stop();
}



void Now_Playing::process_Data(QJsonObject &data) {
    QJsonValue playback_Data = data["data"];

    T_freshness_Timer->start();
    if (!_media_Available) {
        _media_Available = true;
        emit media_Unit_Availability_Changed();
    }

    bool metadata_Changed = false;

    QString source_Name = playback_Data["source"].toString();
    if (_source_Name != source_Name) {
        _source_Name = source_Name;
        metadata_Changed = true;
    }

    QString media_Field_1 = playback_Data["field_1"].toString();
    if (_media_Field_1 != media_Field_1) {
        _media_Field_1 = media_Field_1;
        metadata_Changed = true;
    }

    QString media_Field_2 = playback_Data["field_2"].toString();
    if (_media_Field_2 != media_Field_2) {
        _media_Field_2 = media_Field_2;
        metadata_Changed = true;
    }

    QString media_Field_3 = playback_Data["field_3"].toString();
    if (_media_Field_3 != media_Field_3) {
        _media_Field_3 = media_Field_3;
        metadata_Changed = true;
    }

    QString album_Cover_URL = playback_Data["cover_URL"].toString();
    if (_album_Cover_URL != album_Cover_URL) {
        _album_Cover_URL = album_Cover_URL;
        metadata_Changed = true;
    }

    if (metadata_Changed) {
        emit media_Data_Changed();
    }

    _update_Media_Time(playback_Data);
    _update_Media_State(playback_Data);
    _update_Media_Volume(playback_Data);
}



void Now_Playing::_update_Media_Time(QJsonValue &data) {
    bool time_Changed = false;

    int media_Progress = data["progress"].toInt();
    if (_media_Progress != media_Progress) {
        _media_Progress = media_Progress;
        time_Changed = true;
    }

    int media_Duration = data["duration"].toInt();
    if (_media_Duration != media_Duration) {
        _media_Duration = media_Duration;
        time_Changed = true;
    }

    if (time_Changed) {
        emit media_Time_Changed();
    }
}



void Now_Playing::_update_Media_State(QJsonValue &data) {
    bool media_Paused = data["paused"].toBool();
    if (_media_Paused != media_Paused) {
        _media_Paused = media_Paused;
        emit pause_State_Changed();
    }
}



void Now_Playing::_update_Media_Volume(QJsonValue &data) {
    int volume = data["volume"].toInt();
    if (_media_Volume != volume) {
        _media_Volume = volume;
        emit volume_Changed();
    }
}



QString Now_Playing::return_Source_Name() {
    return _source_Name;
}



QString Now_Playing::return_Media_Field_1() {
    return _media_Field_1;
}



QString Now_Playing::return_Media_Field_2() {
    return _media_Field_2;
}



QString Now_Playing::return_Media_Field_3() {
    return _media_Field_3;
}



QString Now_Playing::return_Album_Cover_URL() {
    return _album_Cover_URL;
}



int Now_Playing::return_Media_Duration() {
    return _media_Duration;
}



int Now_Playing::return_Media_Progress() {
    return _media_Progress;
}



int Now_Playing::return_Volume() {
    return _media_Volume;
}



bool Now_Playing::return_Pause_State() {
    return _media_Paused;
}



bool Now_Playing::return_Media_Availability() {
    return _media_Available;
}
