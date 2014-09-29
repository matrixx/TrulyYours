/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 matrixx
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "Data.js" as Data;
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
