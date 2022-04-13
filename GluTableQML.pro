QT += quick widgets printsupport qml


CONFIG += resources_big app_bundle
PACKAGECONFIG_append = "gif"
#ICON = myapp.icns
QMAKE_INFO_PLIST = myapp.plist

#mySetOfExtraFiles.files = $$PWD/imagesFolder
#mySetOfExtraFiles.path = Contents/Resources
#QMAKE_BUNDLE_DATA += mySetOfExtraFiles

DEFINES += QT_DEPRECATED_WARNINGS
DISTFILES += \
    standart_configuration.gtc

SOURCES += \
        cabinetssettings.cpp \
        homepage.cpp \
        main.cpp \
        mainsettings.cpp \
        printer.cpp \
        qmltranslator.cpp \
        subjectsettings.cpp \
        tablemixer.cpp \
        teachersettings.cpp

RESOURCES += qml.qrc

lupdate_only{
#    SOURCES += main.qml
}

win64 {
    VERSION = 3.0.0
    RC_FILE += icon.rc
    OTHER_FILES += icon.rc
}

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    elements/listItem.qml \
    listViewElement.qml

HEADERS += \
    cabinetssettings.h \
    homepage.h \
    mainsettings.h \
    printer.h \
    qmltranslator.h \
    subjectsettings.h \
    tablemixer.h \
    teachersettings.h

FORMS +=

TRANSLATIONS += QmlLanguage_ru.ts
