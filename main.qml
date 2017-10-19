import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import FileIO 1.0
import FolderIO 1.0
import QJsonRest 1.0
import Qt.labs.settings 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2


// TODO : Add REST Json Api
// TODO : Add authentication & Permissions
// TODO : Add Time Restrictions

ApplicationWindow {
    id: applicationWindow

    visible: true

    visibility: "FullScreen"

    width: 640
    height: 480
    title: qsTr("SyncScreen")




    Settings {
        id: settings
        property string jsonfile: ""
    }

    Connections {
        target: jsonRest
        onDataChanged: {
            console.log("DataChanged")
            console.log(path)
            console.log(value)
            var jsonItem = JSON.parse(jsonConfig.read())
            var jsonPath = path.split('/')
            console.log(jsonPath)
            for (var i=0; i++; i < jsonPath.length()) {
                console.log(jsonPath[i])
                jsonItem = jsonItem.jsonPath[i]
            }
            console.log(jsonItem)
            console.log("DataChanged End")
            // TODO : Envoyé valeur/erreur par jsonRest Signal
            //jsonRest.DataChanged()
        }
    }

    // TODO FilePicker Class for background
    FilePicker {
        id: jsonFileDialog
        anchors.fill: parent
        z: 1
        visible: false
        nameFilters: "*.json"
        onFileSelected: {
            settings.jsonfile = currentFolder() + "/" + fileName
            jsonConfig.setSource(settings.jsonfile)
            this.visible = false
            //console.log(jsonConfig.source)
            console.log("Set Json")
            console.log(currentFolder())
            console.log(fileName)
            console.log(settings.jsonfile)
        }
    }

    function getJsonFile() {
        //settings.jsonfile = ""
        console.log("Start")
        console.log(settings.jsonfile)
        if (settings.jsonfile.length == 0) {
            console.log("JsonFileDialog")
            jsonFileDialog.visible = true
        }
    }



    FileIO {
        id: jsonConfig
        source: settings.jsonfile
        onError: console.log(msg)
    }

    Player {
    }

    Footer {
        id: footer
    }

    Connections {
        target: jsonConfig
        onDataChanged: {
            Footer.readJson
            Player.playerSort
        }
    }

    Component.onCompleted: {
//        showFullScreen()
        getJsonFile()
        console.log("StartX")
//        var screen = new Screen
        var startx = Screen.width
        console.log(startx)
        footer.textStart = startx
        console.log(footer.textStart)
    }
}
