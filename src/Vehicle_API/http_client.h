#ifndef HTTP_CLIENT_H
#define HTTP_CLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QUrl>
#include <QDebug>

class HTTP_Client : public QObject {
    Q_OBJECT

public:
    explicit HTTP_Client(QObject *parent = nullptr);

    QNetworkReply *send_Post_Request(QUrl &url, QByteArray &postData);

private:
    QNetworkAccessManager *_network_Manager;

};

#endif // HTTP_CLIENT_H
