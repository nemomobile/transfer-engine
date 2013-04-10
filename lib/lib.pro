TEMPLATE = lib
TARGET = nemotransferengine
DEPENDPATH += .
INCLUDEPATH += .
CONFIG += shared link_pkgconfig
QT += dbus
CONFIG += quillmetadata

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
headers.path = /usr/include/TransferEngine

target.path = /usr/lib

pkgconfigpc.path = /usr/lib/pkgconfig/
pkgconfigpc.files = nemotransferengine.pc

prf.path = $$[QT_INSTALL_DATA]/mkspecs/features
prf.files = nemotransferengine-plugin.prf


INSTALLS += target headers prf pkgconfigpc
