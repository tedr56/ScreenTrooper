import QtQuick 2.0
import FolderIO 1.0

Item {
    id: jsonPlaylistRoot

    signal next(url source, int time)
    signal endOfPlaylist()

    signal timerEnded()
    signal nextItemSet()

    property int playlistIndex: 0
    property int playlistItemIndex: -1
    property int playlistFileItemIndex: -1

    property url url: ""
    property int timer: 0

    property url directory: ""


    FolderIO {
        id: folderC
    }

    Timer {
        id: imageTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: timerEnded()
    }

    function timerStart() {
        imageTimer.start()
    }

    function parseNext() {
        if (!jsonConfig.source) {
            return
        }

        var JsonObject = JSON.parse(jsonConfig.read())

        directory = JsonObject.default_directory
        timer = JsonObject.default_timer

        //Reset Playlist index and item if Playlist at end or not found
        if (!JsonObject.playlist[playlistIndex]) {
            playlistIndex = 0
            playlistItemIndex = 0
        }

        //get Playlist name
        var playlist = JsonObject.playlist[playlistIndex]

        //send Error if no Playlist found
        if (!playlist) {
            return //TODO Display Error - No Playlist
        }

        //console.log(playlist.playlist)

        if (getScheduleExcluded(playlist.from, playlist.to)) {
            setNextPlaylist()
            return
        }

        //Test if playlist is Playlist Ref or files list
        if (playlist.playlist) {
            if (JsonObject.playlists.hasOwnProperty(playlist.playlist)) {
                parsePlaylist(JsonObject.playlists[playlist.playlist])
            } else {
                return //Todo Linked Playlist not found
            }
        } else if (playlist.files) {
            parsePlaylistFiles(playlist.files)
        } else if (playlist.folder) {
            parsePlaylistFolder(playlist)
        }
    }

    function getScheduleExcluded(from, to){
        //console.log(from)

        var exclude  = false

        var date = new Date()

        //console.log("Schedule")

        if (from) {
            var fromDate = Date.fromLocaleString(Qt.locale(), from, "dd/MM/yyyy hh:mm");
            console.log("from " + fromDate)
            if (date < fromDate) {
                exclude = true
            }
        }

        if (to) {
            var toDate = Date.fromLocaleString(Qt.locale(), to, "dd/MM/yyyy hh:mm");
            console.log("to " + toDate)
            if (date > toDate) {
                exclude = true
            }
        }

        //console.log(date)

        return exclude
    }

    function parsePlaylist(playlistObject) {

        //get Playlist SubDirectory
        var subDirectory = playlistObject.directory || "/."
        if (subDirectory[0] !== "/" ) {
            subDirectory = "/" + subDirectory
        }
        var absDirectory = directory + subDirectory

        if (playlistObject.include_all) {
            parsePlaylistFolder(playlistObject)
            return
        }

        //Todo : Parse include_all

        //Parse Playlist Files to playlistItemIndex
        var fileParser = 0
        var fileValid = -1
        var file
        var tempFile
        do {
            //get Playlist File
            tempFile = jsonConfig.getFile(fileParser , absDirectory)
            if (!tempFile) {
                endOfPlaylist()
                return
            }

            //Test file for Valid
            var exclude = false

            var jFile = playlistObject.files[tempFile]

            if (jFile) {
            //Test for Json Excluded
                exclude = jFile.exclude || false
            //Test for Schedule Excluded
                if (!exclude) {
                    exclude = getScheduleExcluded(jFile.from, jFile.to)
                }
            }
            if (exclude === false) {
                fileValid++
            }
            fileParser++
        } while (fileValid < playlistItemIndex)

        file = tempFile

        if (file) {
            parseFile(file, absDirectory, playlistObject.files[file], playlistObject)
        }
    }

    //Parse directory for right indexed file excluding json's
    function parsePlaylistFiles(filesObject){
        var absDirectory = directory

        console.log(filesObject[1])

        var fileObject = filesObject[playlistFileItemIndex]
        if (!fileObject) {
            endOfPlaylist()
            return
        }

        var filePath = absDirectory + "/" + fileObject.file

        if (jsonConfig.exists(filePath)) {
            var time = fileObject.time || timer
            imageTimer.interval = time * 1000
            url = filePath
            nextItemSet()
        } else {
            endOfPlaylist()
        }
    }

    function parseFile(file, path, fileObject, playlistObject){
        var time = timer
        if (playlistObject) {
            time = playlistObject.time || time
        }
        if (fileObject) {
            time = fileObject.time || time
        }
        imageTimer.interval = time * 1000
        url = path + "/" + file
        nextItemSet()
    }

    function parsePlaylistFolder(playlist) {
        var folder = playlist.directory
        folder = directory + "/" + folder
        var time = timer
        time = playlist.time || time

        var last_added = playlist.last_added
        var fileResult
        if (last_added) {
            fileResult = folderC.getFile(folder, last_added)
        } else {
            fileResult = folderC.getFile(folder)
        }
        if (fileResult) {
            url = folder + "/" + fileResult
            imageTimer.interval = time * 1000
            //console.log("Timer set to " + time * 1000)
            //console.log("Timer set to " + imageTimer.interval)
            nextItemSet()

        } else {
            endOfPlaylist()
        }
    }


    function setNext() {
        imageTimer.stop()
        playlistItemIndex++
        playlistFileItemIndex++
        parseNext()
    }

    function setNextPlaylist() {
        playlistIndex++
        playlistItemIndex = 0
        playlistFileItemIndex = 0
        parseNext()
    }

    onEndOfPlaylist: setNextPlaylist()
}
