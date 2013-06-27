equals(QT_MAJOR_VERSION, 4): QDOC = qdoc3
equals(QT_MAJOR_VERSION, 5): QDOC = qdoc
QHELPGENERATOR = qhelpgenerator
equals(QT_MAJOR_VERSION, 4): QDOCCONF = doc/config/transfer-engine-project.qdocconf
equals(QT_MAJOR_VERSION, 5): QDOCCONF = transfer-engine-project.qdocconf
QHELPFILE = doc/html/transferengine.qhp
QCHFILE = doc/html/transferengine.qch

equals(QT_MAJOR_VERSION, 4): docs.commands = ($$QDOC $$QDOCCONF) && \
                ($$QHELPGENERATOR $$QHELPFILE -o $$QCHFILE)
equals(QT_MAJOR_VERSION, 5): docs.commands = (cd doc/config; $$QDOC $$QDOCCONF; cd ../..) && \
                ($$QHELPGENERATOR $$QHELPFILE -o $$QCHFILE)

QMAKE_EXTRA_TARGETS += docs

