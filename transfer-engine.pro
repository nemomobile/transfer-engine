TEMPLATE = subdirs
SUBDIRS  = lib src declarative tests

src.depends = lib
tests.depends = lib

# no daemon for Qt 4
equals(QT_MAJOR_VERSION, 4): SUBDIRS -= src

# docs only for Qt 5
equals(QT_MAJOR_VERSION, 5): include(doc/doc.pri)

OTHER_FILES += \
    rpm/*.spec \
    nemo-transfer-engine.conf \
    doc/src/* \
    doc/config/*

