/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../../Data.js" as Data;

Page {
    id: page
    Component.onCompleted: {
        Data.getAmbiences(ambienceView.ambiences);
    }

    SilicaFlickable {
        id: flickable
        property int lastActivated: -1
        property int currentIndex: -1;
        property int preloadAmount: 10
        property int loadMoreThreshold: 10
        anchors.fill: parent
        contentWidth: ambienceView.width
        contentHeight: parent.height
        /*
        PullDownMenu {
            MenuItem {
                text: qsTr("Browse Tags")
                onClicked: pageStack.push(Qt.resolvedUrl("TagCloudPage.qml"))
            }
        }
        */

        ScrollDecorator { flickable: flickable }

        PageHeader {
            id: header
            title: qsTr("All ambiences")
            height: 80
            width: page.width
            anchors.left: parent.left
            anchors.top: parent.top
        }

        Row {
            id: ambienceView
            property var ambiences: ListModel {}
            height: parent.height - header.height - Theme.paddingLarge
            anchors.top: header.bottom
            anchors.topMargin: Theme.paddingLarge
            anchors.left: parent.left
            spacing: Theme.paddingMedium

            Repeater {
                model: ambienceView.ambiences
                delegate: Item {
                    id: ambienceItem
                    property bool loading: true
                    property bool active: ambienceView.ambiences.get(index).activated
                    property string fileName: ambienceView.ambiences.get(index).fileName
                    Component.onCompleted: {
                        if (index >= 0 && index < flickable.preloadAmount)
                        {
                            ambienceView.ambiences.get(index).activated = true;
                        }
                    }

                    onActiveChanged:
                    {
                        if (active)
                        {
                            if (ambienceMgr.hasThumbnail(fileName))
                            {
                                previewImage.source = ambienceMgr.thumbnail(fileName);
                            }
                            else
                            {
                                ambienceMgr.saveThumbnailSucceeded.connect(thumbnailReceived);
                                ambienceMgr.saveThumbnail(ambienceView.ambiences.get(index).fullUri, fileName);
                            }
                        }
                    }

                    function thumbnailReceived(name)
                    {
                        if (fileName === name)
                        {
                            console.debug("got successfully thumbnail for: " + name);
                            ambienceMgr.saveThumbnailSucceeded.disconnect(thumbnailReceived);
                            previewImage.source = ambienceMgr.thumbnail(name);
                        }
                    }

                    width: 250
                    height: 740
                    BusyIndicator {
                        anchors.centerIn: parent
                        running: previewImage.source == ""
                    }
                    Image {
                        id: previewImage
                        width: 250
                        height: 740
                        source: ""
                        sourceSize.width: width
                        sourceSize.height: height
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            pageStack.push("AmbienceDetailPage.qml", { "url" : ambienceView.ambiences.get(index).fullUri, "name" : fileName })
                        }
                    }
                }
            }
        }

        onContentXChanged: {
            var curIndex = fromPixelsToIndex(contentX);
            if (curIndex <= currentIndex)
            {
                return;
            }
            currentIndex = curIndex;
            var nextToActivate = curIndex + loadMoreThreshold;
            if (ambienceView.ambiences.length <= nextToActivate)
            {
                nextToActivate = ambienceView.ambiences.length - 1;
            }
            for (var i = lastActivated + 1; i <= nextToActivate; i++)
            {
                ambienceView.ambiences.get(i).activated = true;
            }
            lastActivated = nextToActivate;
        }

        function fromPixelsToIndex(pixels)
        {
            return Math.floor(pixels / (250 + Theme.paddingMedium));
        }
    }
}


