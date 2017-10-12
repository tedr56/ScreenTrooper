import QtQuick 2.4

PlayerForm {
    anchors.fill: parent

    JsonPlaylist {
        id: playlistManager
    }

    function playerSort() {
        var playingFile = playlistManager.url
        var playingFileStr = playingFile.toString()
        var playingFileExtension = playingFileStr.substring(playingFileStr.length - 3).toLowerCase()
        //Sort player depending url
        console.log("Playersort")
        console.log(playingFile)
        console.log(playingFileExtension)
        var imagesExtension = ["jpg", "png"]
        var videoExtension = ["mkv", "mp4", "avi" ]
        console.log(imagesExtension.indexOf(playingFileExtension))
        console.log(videoExtension.indexOf(playingFileExtension))
        if (imagesExtension.indexOf(playingFileExtension) >= 0) {
            if (image1.visible) {
                image2.source = playingFile
                playerStart(image2)
            } else {
                image1.source = playingFile
                playerStart(image1)
            }
        } else if (videoExtension.indexOf(playingFileExtension) >= 0) {
            videoOutput.source = playingFile
            playerStart(videoOutput)
        } else {
            playlistManager.setNext()
        }
    }

    function playerStart(player) {
        //Sort routing depending player
        if (player === videoOutput) {
            image1.visible = false
            image2.visible = false
            videoOutput.visible = true
            videoOutput.seek(0)
            videoOutput.play()
        } else {
            videoOutput.visible = false
            videoOutput.pause()
            if (player === image1) {
                image2.visible = false
                image1.visible = true
            } else {
                image1.visible = false
                image2.visible = true
            }
            playlistManager.timerStart()
        }
    }

    function playerStopped(){
        playlistManager.setNext()
    }

    Connections {
        target: playlistManager
        onTimerEnded: playerStopped()
        onNextItemSet: playerSort()
    }

    Connections {
        target: videoOutput
        onStopped: playerStopped()
    }
    Component.onCompleted: playlistManager.setNext()

    mouseSpace.onPressed: playlistManager.setNext()
}
