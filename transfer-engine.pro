TEMPLATE = subdirs
SUBDIRS  = lib src tests
CONFIG += ordered

include(doc/doc.pri)

OTHER_FILES += \
    rpm/transfer-engine.spec \
    nemo-transfer-engine.conf \
    doc/src/* \
    doc/config/*


config.files = nemo-transfer-engine.conf
config.path = /home/nemo/.config/nemomobile

INSTALLS += config
