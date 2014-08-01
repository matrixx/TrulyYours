# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-trulyyours

CONFIG += sailfishapp

SOURCES += src/harbour-trulyyours.cpp \
    ambiencemanager.cpp

OTHER_FILES += qml/harbour-trulyyours.qml \
    qml/cover/CoverPage.qml \
    rpm/$${TARGET}.spec \
    rpm/$${TARGET}.yaml \
    translations/*.ts \
    $${TARGET}.desktop \
    qml/pages/AmbienceDetailPage.qml \
    qml/pages/BrowseAmbienceListPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
#TRANSLATIONS += translations/$${TARGET}-de.ts

HEADERS += \
    ambiencemanager.h

