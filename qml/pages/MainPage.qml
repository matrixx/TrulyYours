import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../Data.js" as Data;
import "Components"

Page {
    id: mainPage
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: header.height + Theme.paddingLarge + tagCloud.height
        Component.onCompleted: {
            tagMgr.tagsAvailable.connect(setTags);
            tagCloud.tagClicked.connect(openFilteredAmbienceList);
            Data.fetchAmbiences(tagMgr);
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("Show all ambiences")
                onClicked: flickable.openFilteredAmbienceList("");
            }
        }

        ScrollDecorator { flickable: flickable }

        PageHeader {
            id: header
            title: qsTr("Tags")
            height: 80
            width: mainPage.width
            anchors.left: parent.left
            anchors.top: parent.top
        }


        QuickTagCloud {
            id: tagCloud
            width: parent.width
            height: childrenRect.height
            anchors.top: header.bottom
            anchors.topMargin: Theme.paddingLarge
        }

        function setTags()
        {
            tagCloud.maxTagCount = Data.getTagMaxCount();
            tagCloud.tags = tagMgr.getTags();
            tagCloud.tagAmounts = tagMgr.getTagAmounts();
        }

        function openFilteredAmbienceList(filter)
        {
            pageStack.push(Qt.resolvedUrl("BrowseAmbienceListPage.qml"), { filter: filter } )
        }
    }
}
