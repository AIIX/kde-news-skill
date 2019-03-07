    import QtQuick 2.9
    import QtQuick.Controls 2.2
    import QtQuick.Layouts 1.3
    import org.kde.kirigami 2.5 as Kirigami
    import QtGraphicalEffects 1.0
    import Mycroft 1.0 as Mycroft

    Mycroft.Delegate {
        id: rootItem
        property var kdenewsmodel: sessionData.kdenewsObject.items
        skillBackgroundSource: "https://source.unsplash.com/1920x1080/?+gloomy"
        
        Mycroft.SlideShow {
            id: rootSlideShow
            model: kdenewsmodel
            interval: 5000
            running: true
            focus: true
            anchors.fill: parent
            delegate: Item {
                width: rootItem.width - Kirigami.Units.largeSpacing
                height: rootSlideShow.height
                
                ColumnLayout{
                    id: delegateLayout
                    anchors.fill: parent
                    anchors.margins: Kirigami.Units.largeSpacing
                    
                    Kirigami.Heading {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        level: 3
                        text: qsTr(modelData.title)
                    }
                    
                    Image {
                        Layout.fillWidth: true
                        Layout.preferredHeight: rootItem.height / 4
                        source: modelData.thumbnail
                        fillMode: Image.PreserveAspectCrop
                        Component.onCompleted: {
                            if(source == ""){
                                cardNItem.visible = false
                                cardNItem.height = 0
                                cardNItem.width = 0
                            }
                        }
                    }
                    
                    Label {
                        id: description
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: Text.WordWrap
                        textFormat: Text.PlainText
                        Component.onCompleted: {
                                text = modelData.description.replace(/<(?:.|\n)*?>/gm, '');
                        }
                    }       
                }
            }
        }
    }
