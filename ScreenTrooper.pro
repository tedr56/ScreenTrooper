QT += qml quick

CONFIG += c++11

SOURCES += main.cpp \
    fileio.cpp \
    qjsonrest.cpp \
    QSimpleRestServer/src/restrequest.cpp \
    QSimpleRestServer/src/restrequestlistener.cpp \
    QSimpleRestServer/src/restresult.cpp \
    QSimpleRestServer/src/restserver.cpp \
    QSimpleRestServer/src/http/qhttpconnection.cpp \
    QSimpleRestServer/src/http/qhttprequest.cpp \
    QSimpleRestServer/src/http/qhttpresponse.cpp \
    QSimpleRestServer/src/http/qhttpserver.cpp \
    QSimpleRestServer/src/http/http_parser.c \
    folderio.cpp

RESOURCES += qml.qrc \
    icons.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    ../config.json \
    QSimpleRestServer/REST.pri \
    QSimpleRestServer/src/http/README.md \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

HEADERS += \
    fileio.h \
    qjsonrest.h \
    QSimpleRestServer/src/restrequest.h \
    QSimpleRestServer/src/restrequestlistener.h \
    QSimpleRestServer/src/restresult.h \
    QSimpleRestServer/src/restserver.h \
    QSimpleRestServer/src/http/http_parser.h \
    QSimpleRestServer/src/http/qhttpconnection.h \
    QSimpleRestServer/src/http/qhttprequest.h \
    QSimpleRestServer/src/http/qhttpresponse.h \
    QSimpleRestServer/src/http/qhttpserver.h \
    QSimpleRestServer/src/http/qhttpserverapi.h \
    QSimpleRestServer/src/http/qhttpserverfwd.h \
    folderio.h
