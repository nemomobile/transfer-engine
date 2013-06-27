TEMPLATE = subdirs
SUBDIRS  = lib src tests

tests.depends = lib

include(doc/doc.pri)

OTHER_FILES += \
    rpm/transfer-engine.spec \
    nemo-transfer-engine.conf \
    doc/src/* \
    doc/config/*

