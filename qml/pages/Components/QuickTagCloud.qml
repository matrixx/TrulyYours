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
            if (count >= (tagCloud.maxTagCount / 4 * 3))
            {
                return Theme.fontSizeExtraLarge;
            }
            else if (count >= (tagCloud.maxTagCount / 4 * 2))
            {
                return Theme.fontSizeLarge;
            }
            else if (count >= (tagCloud.maxTagCount / 4))
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
