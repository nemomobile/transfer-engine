TEMPLATE = subdirs
SUBDIRS  = lib src tests
CONFIG += ordered

include(doc/doc.pri)

OTHER_FILES += \
    rpm/*.spec \
    nemo-transfer-engine.conf \
    doc/src/* \
    doc/config/*

