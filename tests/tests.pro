TEMPLATE = app
TARGET = ut_nemo-transfer-engine
DEPENDPATH += .
INCLUDEPATH += . ../src ../lib


# Test files
HEADERS += \
    ut_imageoperation.h \
    ut_mediatransferinterface.h

SOURCES += \
    main.cpp \
    ut_imageoperation.cpp \
    ut_mediatransferinterface.cpp


# Import filess from the actual project
HEADERS += \
    ../lib/imageoperation.h \
    ../lib/mediatransferinterface.h \
    ../lib/mediaitem.h

SOURCES += \
    ../lib/imageoperation.cpp \
    ../lib/mediatransferinterface.cpp \
    ../lib/mediaitem.cpp


LIBS += -lquillmetadata
QT += testlib

PATH = /opt/tests/nemo-transfer-engine

test_def.files = tests.xml
test_def.path = $$PATH
resources.files = images/testimage.jpg
resources.path = $$PATH/images
target.path = $$PATH

INSTALLS += target resources test_def
