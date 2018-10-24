import QtQuick 2.11
import QtMultimedia 5.9

Item {

    //    property alias mediaPlayer: mediaPlayer
    //    width: 400
    //    height: 400
    property alias image1: image1
    property alias image2: image2
    property alias videoOutput: videoOutput
    property alias mouseSpace: mouseSpace

    //    property alias playlist: playlist


    MouseArea {
        id: mouseSpace
        anchors.fill: parent

        Rectangle {
            color: "#000000"
            anchors.fill: parent

//            Loader {
//                id: videoLoader
//                source: "VideoPlayerForm.ui.qml"
//            }

//            Connections {
//                target: videoLoader.item
//                onStopped: videoLoader.source = ""
//            }


            Video {
                id: videoOutput
                visible: false
                anchors.fill: parent
                autoPlay: false
                fillMode: VideoOutput.PreserveAspectFit
            }
            Image {
                id: image1
                visible: false
                anchors.fill: parent
            }
            Image {
                id: image2
                visible: false
                anchors.fill: parent
            }
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
