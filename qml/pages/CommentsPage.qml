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

Page {
    id: page
    property string mediaId: ""
    property var comments: ListModel {}
    property bool loading: false

    Component.onCompleted: {
        Data.fetchComments(comments, mediaId, loading);
    }
    SilicaListView {
        id: ambienceComments
        anchors.fill: parent
        contentWidth: parent.width

        header: PageHeader {
            title: qsTr("Comments")
        }

        VerticalScrollDecorator {}

        delegate: BackgroundItem {
            width: parent.width
            height: comment.contentHeight + 2 * Theme.paddingLarge
            Label {
                id: comment
                width: parent.width - 2 * Theme.paddingLarge
                anchors.centerIn: parent
                wrapMode: Text.WordWrap
                text: comments.get(index).comment
            }
        }
        model: comments

        ViewPlaceholder {
            enabled: ambienceComments.count == 0
            text: if (loading) { qsTr("Loading") } else { qsTr("This ambience has no comments") }
        }
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: loading
    }
}
