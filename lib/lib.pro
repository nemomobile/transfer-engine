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
    imageoperation.h

SOURCES += \
    transferdbrecord.cpp \
    mediatransferinterface.cpp \
    mediaitem.cpp \
    transfermethodinfo.cpp \
    transferengineclient.cpp \
    imageoperation.cpp

# generated files
HEADERS += \
    transferengineinterface.h


SOURCES += \
   transferengineinterface.cpp

OTHER_FILES += nemotransfernegine.pc nemotransferengine-plugin.prf

headers.files = $$HEADERS
equals(QT_MAJOR_VERSION, 4): headers.path = /usr/include/TransferEngine
equals(QT_MAJOR_VERSION, 5): headers.path = /usr/include/TransferEngine-qt5

target.path = /usr/lib

pkgconfigpc.path = /usr/lib/pkgconfig/
equals(QT_MAJOR_VERSION, 4): pkgconfigpc.files = nemotransferengine.pc
equals(QT_MAJOR_VERSION, 5): pkgconfigpc.files = nemotransferengine-qt5.pc

prf.path = $$[QT_INSTALL_DATA]/mkspecs/features
prf.files = nemotransferengine-plugin.prf


INSTALLS += target headers prf pkgconfigpc
