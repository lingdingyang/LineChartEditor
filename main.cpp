#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include<QQmlContext>
#include<QApplication>
#include"controller.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/line_chart_editor/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
    []() {
        QCoreApplication::exit(-1);
    },
    Qt::QueuedConnection);
    engine.load(url);
    QQmlContext* context = engine.rootContext();
    Controller controller;
    context->setContextProperty("controller", &controller);
    return app.exec();
}
