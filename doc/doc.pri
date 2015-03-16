QDOC = qdoc
QHELPGENERATOR = qhelpgenerator
QDOCCONF = transfer-engine-project.qdocconf
QHELPFILE = doc/html/transferengine.qhp
QCHFILE = doc/html/transferengine.qch

docs.commands = (cd doc/config; $$QDOC $$QDOCCONF; cd ../..) && \
                ($$QHELPGENERATOR $$QHELPFILE -o $$QCHFILE)

QMAKE_EXTRA_TARGETS += docs

