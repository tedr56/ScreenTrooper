import QtQuick 2.11

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
        var videoExtension = ["mkv", "mp4", "avi", "m4v", "mov"]
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
            console.log(videoOutput.availability)
            videoOutput.autoLoad = true
            videoOutput.visible = false
            videoOutput.pause()
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

    function imageStopped(){
        console.log("Image Stopped")
        playlistManager.setNext()
    }

    function videoStopped(){
        console.log("Video Stopped")
        playlistManager.setNext()
    }

    Connections {
        target: playlistManager
        onTimerEnded: imageStopped()
        onNextItemSet: playerSort()
    }

    Connections {
        target: videoOutput
        onStopped: videoStopped()
    }

    Component.onCompleted: playlistManager.setNext()
    mouseSpace.onPressed: playlistManager.setNext()

}
