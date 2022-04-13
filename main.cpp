#include <QGuiApplication>
#include <QQmlApplicationEngine>
//#include <QApplication>
//#include <QTextCodec>
#include <QtQuick>
#include <QStandardPaths>
#include <QAction>
#include <QVariant>
#include <QUrl>
#include <QMenuBar>
#include <QMenu>

#include "qmltranslator.h"

#include "cabinetssettings.h"
#include "subjectsettings.h"
#include "teachersettings.h"
#include "mainsettings.h"
#include "tablemixer.h"
#include "homepage.h"
#include "printer.h"

#include <QPrinter>

int main(int argc, char *argv[])
{            

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QFontDatabase::addApplicationFont("qrc:/fonts/Poiret One.ttf");
    QFontDatabase::addApplicationFont("qrc:/fonts/helveticaneuecyr-thin.ttf");
    QFontDatabase::addApplicationFont("qrc:/fonts/helveticaneuecyr-light.ttf");
    QFontDatabase::addApplicationFont("qrc:/fonts/helveticaneuecyr-roman.ttf");

    //QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    app.setWindowIcon(QIcon("myapp.icns"));
    app.setApplicationName("GluTable");

    QmlTranslator *translator         = new QmlTranslator();
    Printer *printer                  = new Printer();

    CabinetsSettings *cabinetSettings = new CabinetsSettings();
    TeacherSettings *teacherSettings  = new TeacherSettings();
    SubjectSettings *subjectSettings  = new SubjectSettings();
    MainSettings *mainSettings        = new MainSettings();
    TableMixer *tableMixer            = new TableMixer();
    HomePage *homePage                = new HomePage();

    QQmlContext *context = engine.rootContext();

    context->setContextProperty("qmlTranslator", translator);
    context->setContextProperty("printer", printer);

    context->setContextProperty("subjectSettingsClass", subjectSettings);
    context->setContextProperty("cabinetSettingsClass", cabinetSettings);
    context->setContextProperty("teacherSettingsClass", teacherSettings);
    context->setContextProperty("mainSettingsClass", mainSettings);
    context->setContextProperty("tableMixerClass", tableMixer);
    context->setContextProperty("homePageClass", homePage);

    cabinetSettings->fillFromFolder();
    teacherSettings->fillFromFolder();
    subjectSettings->fillFromFolder();
    mainSettings->fillFromFolder();
    homePage->fillFromFolder();

    app.exec();


    return 0;

}
