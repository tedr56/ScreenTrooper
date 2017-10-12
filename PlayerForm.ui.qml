import QtQuick 2.4
import QtMultimedia 5.8

Item {

    //    property alias mediaPlayer: mediaPlayer
    //    width: 400
    //    height: 400
    property alias image1: image1
    property alias image2: image2
    property alias videoOutput: videoOutput
    property alias mouseSpace: mouseSpace
    property alias playlist: playlist

    //    MediaPlayer {
    //        id: mediaPlayer
    //        source: "file:///mnt/Xtra/Videos/Series - Complete/Legion/Legion - Season 1/Legion.S01E01.PROPER.720p.HDTV.x264-KILLERS[eztv].mkv"
    //        autoPlay: true
    //    }
    Playlist {
        id: playlist
        playbackMode: Playlist.Loop
    }
    MouseArea {
        id: mouseSpace
        anchors.fill: parent

        Rectangle {
            color: "#000000"
            anchors.fill: parent
            Video {
                id: videoOutput
                anchors.fill: parent
                autoPlay: true
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
