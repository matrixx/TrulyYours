TEMPLATE = app
TARGET = harbour-trulyyours
CONFIG += sailfishapp

QT += dbus

system(qdbusxml2cpp -p src/ambienced.h:src/ambienced.cpp src/ambienced.xml)

HEADERS += \
    src/ambiencemanager.h \
    src/tagmanager.h \
    src/ambienced.h \
    src/preferences.h \
    src/authkey.h

SOURCES += src/harbour-trulyyours.cpp \
    src/ambiencemanager.cpp \
    src/tagmanager.cpp \
    src/ambienced.cpp \
    src/preferences.cpp

OTHER_FILES += rpm/$${TARGET}.spec \
    rpm/$${TARGET}.yaml \
    $${TARGET}.desktop \
    translations/*.ts \
    qml/harbour-trulyyours.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AmbienceDetailPage.qml \
    qml/pages/BrowseAmbienceListPage.qml \
    qml/pages/Data.js \
    qml/pages/MainPage.qml \
    qml/pages/Components/QuickTagCloud.qml \
    qml/pages/CommentsPage.qml

js.path = /usr/share/$${TARGET}/qml/pages
js.files = Data.js
INSTALLS += js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += \
    translations/$${TARGET}-fi.ts \
    translations/$${TARGET}-ru.ts \
    translations/$${TARGET}-de.ts \
    translations/$${TARGET}-en.ts \
    translations/$${TARGET}-es.ts \
    translations/$${TARGET}-nl.ts

