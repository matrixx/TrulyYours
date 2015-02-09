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


Page {
    id: page
    property string url: ""
    property string name: ""
    property string mediaId: ""
    property bool savingInProgress: false
    Component.onCompleted: {
        ambienceMgr.saveFullImageSucceeded.connect(page.setSource)
        ambienceMgr.saveImageToGallerySucceeded.connect(page.stopBusyIndicator)
        ambienceMgr.saveFullImage(url, name);

    }
    SilicaFlickable {
        id: ambienceDetailed
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: fullImage.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Show comments")
                visible: fullImage.source != "" && !savingInProgress
                onClicked: {
                    pageStack.push("CommentsPage.qml", { "mediaId" : mediaId })
                }
            }
            MenuItem {
                text: qsTr("Save and create ambience")
                visible: fullImage.source != "" && !savingInProgress
                onClicked: {
                    savingInProgress = true;
                    ambienceMgr.saveImageToGalleryAndApplyAmbience(name)
                }
            }
            MenuItem {
                text: qsTr("Save to gallery")
                visible: fullImage.source != "" && !savingInProgress
                onClicked: {
                    savingInProgress = true;
                    ambienceMgr.saveImageToGallery(name)
                }
            }
        }

        VerticalScrollDecorator {}

        Image {
            id: fullImage
            height: 1600
            width: 540
            source: ""
            sourceSize.height: height
            sourceSize.width: width
        }
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: fullImage.source == "" || savingInProgress
    }

    function setSource(url)
    {
        fullImage.source = url;
    }

    function stopBusyIndicator()
    {
        savingInProgress = false
    }
}





