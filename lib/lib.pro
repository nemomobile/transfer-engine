TEMPLATE = lib
equals(QT_MAJOR_VERSION, 4): TARGET = nemotransferengine
equals(QT_MAJOR_VERSION, 5): TARGET = nemotransferengine-qt5
DEPENDPATH += .
INCLUDEPATH += .
CONFIG += shared link_pkgconfig
QT += dbus
equals(QT_MAJOR_VERSION, 4): PKGCONFIG += quillmetadata
equals(QT_MAJOR_VERSION, 5): PKGCONFIG += quillmetadata-qt5

system(qdbusxml2cpp -v -c TransferEngineInterface -p transferengineinterface.h:transferengineinterface.cpp -i metatypedeclarations.h ../dbus/org.nemo.transferengine.xml)

HEADERS += \
    transferdbrecord.h \
    metatypedeclarations.h \
    transfertypes.h \
    mediatransferinterface.h \
    transferplugininterface.h \
    mediaitem.h \
    transfermethodinfo.h \
    transferplugininfo.h \
    transferengineclient.h \
    imageoperation.h \
    content.h

SOURCES += \
    transferdbrecord.cpp \
    mediatransferinterface.cpp \
    mediaitem.cpp \
    transfermethodinfo.cpp \
    transferengineclient.cpp \
    imageoperation.cpp \
    content.cpp

# generated files
HEADERS += \
    transferengineinterface.h


SOURCES += \
   transferengineinterface.cpp

equals(QT_MAJOR_VERSION, 4): OTHER_FILES += nemotransfernegine.pc nemotransferengine-plugin.prf
equals(QT_MAJOR_VERSION, 5): OTHER_FILES += nemotransfernegine-qt5.pc nemotransferengine-plugin-qt5.prf

headers.files = $$HEADERS
equals(QT_MAJOR_VERSION, 4): headers.path = /usr/include/TransferEngine
equals(QT_MAJOR_VERSION, 5): headers.path = /usr/include/TransferEngine-qt5

target.path = /usr/lib

pkgconfigpc.path = /usr/lib/pkgconfig/
equals(QT_MAJOR_VERSION, 4): pkgconfigpc.files = nemotransferengine.pc
equals(QT_MAJOR_VERSION, 5): pkgconfigpc.files = nemotransferengine-qt5.pc

prf.path = $$[QT_INSTALL_DATA]/mkspecs/features
equals(QT_MAJOR_VERSION, 4): prf.files = nemotransferengine-plugin.prf
equals(QT_MAJOR_VERSION, 5): prf.files = nemotransferengine-plugin-qt5.prf


INSTALLS += target headers prf pkgconfigpc
