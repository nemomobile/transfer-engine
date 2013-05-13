TEMPLATE = app
TARGET = nemo-transfer-engine
DEPENDPATH += .
INCLUDEPATH += . ../lib

QT += dbus sql

equals(QT_MAJOR_VERSION, 4): LIBS += -L../lib -lnemotransferengine
equals(QT_MAJOR_VERSION, 5): LIBS += -L../lib -lnemotransferengine-qt5

# generate adaptor code
system(qdbusxml2cpp -c TransferEngineAdaptor -a transferengineadaptor.h:transferengineadaptor.cpp -i metatypedeclarations.h ../dbus/org.nemo.transferengine.xml)

CONFIG += link_pkgconfig
equals(QT_MAJOR_VERSION, 4): PKGCONFIG += mlite accounts-qt
equals(QT_MAJOR_VERSION, 5): PKGCONFIG += mlite5 accounts-qt5

# translations
TS_FILE = $$OUT_PWD/nemo-transfer-engine.ts
EE_QM = $$OUT_PWD/nemo-transfer-engine_eng_en.qm

ts.commands += lupdate $$PWD -ts $$TS_FILE
ts.CONFIG += no_check_exist
ts.output = $$TS_FILE
ts.input = .

ts_install.files = $$TS_FILE
ts_install.path = /usr/share/translations/source
ts_install.CONFIG += no_check_exist

# should add -markuntranslated "-" when proper translations are in place (or for testing)
engineering_english.commands += lrelease -idbased $$TS_FILE -qm $$EE_QM
engineering_english.CONFIG += no_check_exist
engineering_english.depends = ts
engineering_english.input = $$TS_FILE
engineering_english.output = $$EE_QM

engineering_english_install.path = /usr/share/translations
engineering_english_install.files = $$EE_QM
engineering_english_install.CONFIG += no_check_exist

QMAKE_EXTRA_TARGETS += ts engineering_english

PRE_TARGETDEPS += ts engineering_english

# Input
SOURCES += main.cpp \
    transferengineadaptor.cpp \
    dbmanager.cpp \
    transferengine.cpp

HEADERS += \
    transferengineadaptor.h \
    dbmanager.h \
    transferengine.h \
    transferengine_p.h

SERVICE_FILE += ../dbus/org.nemo.transferengine.service
OTHER_FILES +=  $$SERVICE_FILE \
                ../dbus/org.nemo.transferengine.xml


service.files = $$SERVICE_FILE
service.path  = /usr/share/dbus-1/services/
target.path = /usr/bin

INSTALLS += service target  ts_install engineering_english_install


