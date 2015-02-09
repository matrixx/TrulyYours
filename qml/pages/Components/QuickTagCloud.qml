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

Flow {
    id: tagCloud

    property var tags: ({})
    property var tagAmounts: ({})
    property int maxTagCount: 0
    signal tagClicked(string tagName)

    Repeater {
        id: repeater
        model: tagCloud.tags
        delegate: BackgroundItem {
            width: tag.width + Theme.paddingLarge * 2.5
            height: 90
            Label {
                id: tag
                text: tagCloud.tags[index]
                font.pixelSize: repeater.fontSize(index);
                anchors.centerIn: parent
            }
            onClicked: {
                tagClicked(tagCloud.tags[index])
            }
        }

        function fontSize(index)
        {
            var count = tagCloud.tagAmounts[index];
            if (count >= (tagCloud.maxTagCount / 3 * 2))
            {
                return Theme.fontSizeExtraLarge;
            }
            else if (count >= (tagCloud.maxTagCount / 3))
            {
                return Theme.fontSizeLarge;
            }
            else if (count >= (tagCloud.maxTagCount / 6))
            {
                return Theme.fontSizeMedium;
            }
            else
            {
                return Theme.fontSizeSmall;
            }
        }
    }
}
