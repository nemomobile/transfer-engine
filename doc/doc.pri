QDOC = qdoc3
QHELPGENERATOR = qhelpgenerator
QDOCCONF = doc/config/transfer-engine-project.qdocconf
QHELPFILE = doc/html/transferengine.qhp
QCHFILE = doc/html/transferengine.qch

docs.commands = ($$QDOC $$QDOCCONF) && \
                ($$QHELPGENERATOR $$QHELPFILE -o $$QCHFILE)

QMAKE_EXTRA_TARGETS += docs

doc.files = doc/html/*
doc.path = /usr/share/doc/nemo-transfer-engine
INSTALLS += doc

