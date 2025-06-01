#ifndef NOW_PLAYING_H
#define NOW_PLAYING_H

#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QVariant>
#include <QTimer>
#include <QDebug>

class Now_Playing : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString return_Source_Name READ return_Source_Name NOTIFY media_Data_Changed)
    Q_PROPERTY(QString return_Media_Field_1 READ return_Media_Field_1 NOTIFY media_Data_Changed)
    Q_PROPERTY(QString return_Media_Field_2 READ return_Media_Field_2 NOTIFY media_Data_Changed)
    Q_PROPERTY(QString return_Media_Field_3 READ return_Media_Field_3 NOTIFY media_Data_Changed)
    Q_PROPERTY(QString return_Album_Cover_URL READ return_Album_Cover_URL NOTIFY media_Data_Changed)

    Q_PROPERTY(int return_Media_Duration READ return_Media_Duration NOTIFY media_Time_Changed)
    Q_PROPERTY(int return_Media_Progress READ return_Media_Progress NOTIFY media_Time_Changed)

    Q_PROPERTY(bool return_Pause_State READ return_Pause_State NOTIFY pause_State_Changed)

    Q_PROPERTY(int return_Volume READ return_Volume NOTIFY volume_Changed)

    Q_PROPERTY(bool return_Media_Availability READ return_Media_Availability NOTIFY media_Unit_Availability_Changed)

public:
    explicit Now_Playing(QObject *parent = nullptr);
    void process_Data(QJsonObject &data);

    QString return_Source_Name();
    QString return_Media_Field_1();
    QString return_Media_Field_2();
    QString return_Media_Field_3();
    QString return_Album_Cover_URL();

    int return_Media_Duration();
    int return_Media_Progress();

    int return_Volume();

    bool return_Pause_State();

    bool return_Media_Availability();

signals:
    void media_Data_Changed();
    void media_Time_Changed();
    void pause_State_Changed();
    void volume_Changed();
    void media_Unit_Availability_Changed();

private slots:
    void S_data_Is_Rotten();

private: //Private functions
    void _update_Media_Time(QJsonValue &data);
    void _update_Media_State(QJsonValue &data);
    void _update_Media_Volume(QJsonValue &data);

private: //Private variables
    QString _source_Name = "No media data";
    QString _media_Field_1 = "No media data";
    QString _media_Field_2 = "";
    QString _media_Field_3 = "";
    QString _album_Cover_URL = "";

    int _media_Progress = 0;
    int _media_Duration = 0;

    bool _media_Paused = false;

    int _media_Volume = 0;

    //TIMERS
    QTimer *T_freshness_Timer;
    //FLAGS
    bool _media_Available = false;
};

#endif // NOW_PLAYING_H
