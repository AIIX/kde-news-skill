import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.5 as Kirigami
import QtGraphicalEffects 1.0
import Mycroft 1.0 as Mycroft

Mycroft.ScrollableDelegate {
    id: root
    property var kdenewsmodel: sessionData.kdenewsObject.items
    skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+gloomy"
    
    Timer {
        id: slideShowTimer
        interval: 5000
        running: false
        repeat: true
        onTriggered: {
            var getCount = newsSwipeView.count
            if(newsSwipeView.currentIndex !== getCount){
                newsSwipeView.currentIndex = newsSwipeView.currentIndex+1;
            }
            else{
                newsSwipeView.currentIndex = 0
            }
        }
    }
 
    
    ListView {
        id: newsSwipeView
        model: kdenewsmodel
        anchors.top:  parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        layoutDirection: Qt.LeftToRight
        orientation: ListView.Horizontal
        snapMode: ListView.SnapOneItem;
        flickDeceleration: 500
        focus: true
        flickableDirection: Flickable.AutoFlickDirection
        highlightRangeMode: ListView.StrictlyEnforceRange
        highlightFollowsCurrentItem: true
        spacing: Kirigami.Units.largeSpacing
        delegate: Kirigami.AbstractCard{
            id: cardNItem
            showClickFeedback: true
            width: newsSwipeView.width
            height: newsSwipeView.height
            contentItem: ColumnLayout {
                anchors.fill: parent
                anchors.margins: Kirigami.Units.largeSpacing
                Item {
                    height: root.height > Kirigami.Units.gridUnit * 20 ? Kirigami.Units.gridUnit * 0 : Kirigami.Units.gridUnit * 2
                }
                Kirigami.Heading {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    level: 3
                    text: qsTr(modelData.title)
                }
                Image {
                    Layout.fillWidth: true
                    Layout.preferredHeight: root.height / 4
                    source: modelData.thumbnail
                    fillMode: Image.PreserveAspectCrop
                    Component.onCompleted: {
                        slideShowTimer.start()
                        if(source == ""){
                            cardNItem.visible = false
                            cardNItem.height = 0
                            cardNItem.width = 0
                        }
                    }
                }
                Label {
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    Component.onCompleted: {
                        if(modelData.description == ""){
                            cardNItem.visible = false
                            cardNItem.height = 0
                            cardNItem.width = 0
                        }
                        else {
                            text = modelData.description.substr(0, modelData.description.lastIndexOf("["));
                        }
                    }
                }
            }
            onClicked: console.log("Card clicked")
        }

        Keys.onLeftPressed: {
            if (currentIndex > 0 )
                currentIndex = currentIndex-1
            slideShowTimer.restart()
        }

        Keys.onRightPressed: {
            if (currentIndex < count)
                currentIndex = currentIndex+1
            slideShowTimer.restart()
        }

        onFlickEnded: {
            slideShowTimer.restart()
        }
    }
}
