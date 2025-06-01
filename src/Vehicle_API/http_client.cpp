#include "http_client.h"

HTTP_Client::HTTP_Client(QObject *parent) : QObject(parent) {
    _network_Manager = new QNetworkAccessManager(this);
}



QNetworkReply* HTTP_Client::send_Post_Request(QUrl &url, QByteArray &postData) {
    QNetworkRequest request(url);

    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");

    QNetworkReply *reply = _network_Manager->post(request, postData);

    return reply;
}
