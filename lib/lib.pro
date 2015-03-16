TEMPLATE = lib
TARGET = nemotransferengine-qt5
DEPENDPATH += .
INCLUDEPATH += .
CONFIG += shared link_pkgconfig
QT += dbus
PKGCONFIG += quillmetadata-qt5

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

OTHER_FILES += nemotransfernegine-qt5.pc nemotransferengine-plugin-qt5.prf

headers.files = $$HEADERS
headers.path = /usr/include/TransferEngine-qt5

target.path = /usr/lib

pkgconfigpc.path = /usr/lib/pkgconfig/
pkgconfigpc.files = nemotransferengine-qt5.pc

prf.path = $$[QT_INSTALL_DATA]/mkspecs/features
prf.files = nemotransferengine-plugin-qt5.prf


INSTALLS += target headers prf pkgconfigpc
