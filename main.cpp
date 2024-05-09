#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "tcpclient.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    //添加C++类,直接使用其方法
    TcpClient client;
    engine.rootContext()->setContextObject(&client);
    /* 加载属性：缓存地址 */
    engine.rootContext()->setContextProperty("cache_Path", "file:///"+client.cache_Path);
    const QUrl url(u"qrc:/Client/Main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
