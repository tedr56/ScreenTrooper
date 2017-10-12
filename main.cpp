#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "fileio.h"
#include "QSimpleRestServer/src/restserver.h"
#include "qjsonrest.h"

#include <qqmlengine.h>
#include <qqmlcontext.h>
#include <qqml.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    app.setOrganizationName("ARocherVJ");
    app.setOrganizationDomain("arochervj.com");
    app.setApplicationName("SyncScreen");

    QQmlApplicationEngine engine;

    RESTServer restServer;
    QJsonRest *jsonRest = new QJsonRest();
    restServer.addRequestListener(jsonRest);
    restServer.listen(8080);

    qmlRegisterType<FileIO, 1>("FileIO", 1, 0, "FileIO");
    qmlRegisterType<QJsonRest, 1>("QJsonRest", 1, 0, "QJsonRest");

    engine.rootContext()->setContextProperty("jsonRest", jsonRest);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;


    return app.exec();
}
