import QtQuick 2.7
import FileIO 1.0
import QtQuick.Window 2.2


FooterForm {

    width: parent.width

    property int textStart: 10
    property int textSpeed: 1

    property string scheduleTime

    function readJson() {
        console.log("ClockX")
        console.log(footer_info.mapFromItem(parent, 0, 0, 1, 1))
        var JsonObject = JSON.parse(jsonConfig.read())

        this.visible = JsonObject.footer.enable || false
        this.height  = JsonObject.footer.height || 200

        footer_info.visible = JsonObject.footer.info.enable || false
        footer_info.color = JsonObject.footer.info.background || "#0000FF"

        var footer_content = footer_text
        footer_content.color = JsonObject.footer.info.color || "#FFFFFF"
        footer_content.font.pointSize = JsonObject.footer.info.size || 10


        var newTextSpeed = JsonObject.footer.info.speed || 1
        console.log("speed")
        console.log(newTextSpeed)
        if (newTextSpeed !== textSpeed) {
            textSpeed = newTextSpeed
            numberAnimation.stop()
            numberAnimation.start()
        }

        //Info Content
        var footerContent = ""
        for (var arrayContent in JsonObject.footer.info.content) {
            footerContent += JsonObject.footer.info.content[arrayContent] + new Array(JsonObject.footer.info.spacing).join( " " );
        }

        footerContent += getSchedule(JsonObject)

        footer_info.children[0].text = footerContent


        //Clock Options
        footer_clock.visible = JsonObject.footer.clock.enable || false
        footer_clock.color = JsonObject.footer.clock.background || "#0000FF"
        footer_clock_spacing = JsonObject.footer.clock.spacing || 10

        var clocks = footer_clock.children
        for (var c in clocks) {
            clocks[c].color = JsonObject.footer.clock.color || "#FFFFFF"
            clocks[c].font.pointSize = JsonObject.footer.clock.size || 10
        }
        time_utc = JsonObject.footer.clock.utc || false
        time_offset = JsonObject.footer.clock.offset || 0


        //console.log(footer_text.width)

    }

    Timer {
        id: scheduleTimer
        repeat: true
        interval: 60000
        onTriggered: updateSchedule()
    }

    // TODO : enableAllCategories option
    function getSchedule(JsonObject) {

        var schedule = JsonObject.footer.info.schedule
        if (!schedule) return
        var scheduleEnable = schedule.enable
        if (!scheduleEnable) return
        var scheduleEnableCurrent = schedule.enableCurrent
        var scheduleCurrentText = schedule.currentText
        var scheduleEnableNext = schedule.enableNext
        var scheduleEnableNextTime = schedule.enableNextTime
        var scheduleEnableNextNest = schedule.enableNextNested
        var scheduleNextText = schedule.nextTextAlone
        var scheduleNextTextNested = schedule.nextTextNested
        var scheduleNextTextTime = schedule.nextTextTime
        var scheduleEnableAll = schedule.enableAllCategories
        var scheduleCategory = schedule.category
        var scheduleCategories = schedule.categories

        var scheduleContent = ""
        var scheduleContentNext = ""

        if (!scheduleEnable) {
            return
        }

        if (scheduleEnableAll) {
            for (var c in scheduleCategories) {
                var category = scheduleCategories[c]
                if (category) {
                    parseCategory(c)
                }
            }
        } else {
            var category = scheduleCategories[scheduleCategory]
            if (category) {
                parseCategory(scheduleCategory)
            }
        }

        function parseCategory(category) {
            var currentArtiste = parseArtiste(scheduleCategories[category], false)
            setScheduleTimer(scheduleCategories[category][currentArtiste])
            var nextArtiste
            var nextTime

            nextArtiste = parseArtiste(scheduleCategories[category], true)
            setScheduleTimer(scheduleCategories[category][nextArtiste])
            if (scheduleEnableNext) {
                if (nextArtiste) {
                    nextTime =  scheduleCategories[category][nextArtiste].from
                }
            }
            if (currentArtiste) {
                if (scheduleEnableNext) {
                    if (nextArtiste) {
                        if (scheduleEnableNextNest) {
                            var currentContent = createContent(scheduleCurrentText, category, currentArtiste, nextArtiste, true, scheduleNextTextNested, scheduleNextText, scheduleEnableNextTime, scheduleNextTextTime, nextTime)
                            scheduleContent = addContent(scheduleContent, currentContent)
                        } else {
                            var currentContent = createContent(scheduleCurrentText, category, currentArtiste, nextArtiste, false, scheduleNextTextNested, scheduleNextText, scheduleEnableNextTime, scheduleNextTextTime, nextTime)
                            var nextContent = createNextContent(scheduleNextText, category, nextArtiste, scheduleNextTextTime, nextTime, scheduleEnableNextTime)
                            scheduleContent = addContent(scheduleContent, currentContent)
                            scheduleContentNext = addContent(scheduleContentNext, nextContent)
                        }
                    } else {
                        var currentContent = createContent(scheduleCurrentText, category, currentArtiste, nextArtiste, true, scheduleNextTextNested, scheduleNextText, scheduleEnableNextTime, scheduleNextTextTime, nextTime)
                        scheduleContent = addContent(scheduleContent, currentContent)
                    }
                }
            } else {
                if (scheduleEnableNext) {
                    if (nextArtiste) {
                        var nextContent = createNextContent(scheduleNextText, category, nextArtiste, scheduleNextTextTime, nextTime, scheduleEnableNextTime)
                        scheduleContentNext = addContent(scheduleContentNext, nextContent)
                    }
                }
            }
        }

        function setScheduleTimer(artist) {
            var date = new Date()
            if (!artist) {return}
            var artistFrom = artist.from || date
            var artistTo = artist.to || date
            var scheduleTimeSafe = scheduleTime || date
            var from = Date.fromLocaleString(Qt.locale(), artistFrom, "dd/MM/yyyy hh:mm")
            var to = Date.fromLocaleString(Qt.locale(), artistTo, "dd/MM/yyyy hh:mm")
            var remaining = Date.fromLocaleString(Qt.locale(), scheduleTimeSafe, "dd/MM/yyyy hh:mm")

            if (from > date) {
                if (scheduleTime) {
                    if (from < remaining) {
                        setScheduleTimerInterval(from)
                    }
                } else {
                    setScheduleTimerInterval(from)
                }
            }
            if (to > date) {
                if (scheduleTime) {
                    if (to > remaining) {
                        setScheduleTimerInterval(to)
                    }
                } else {
                    setScheduleTimerInterval(to)
                }
            }
        }
        function setScheduleTimerInterval(time) {
            var date = new Date()
            scheduleTime = Date.toLocaleString(Qt.locale(), time, "dd/MM/yyyy hh:mm")
        }

        function updateSchedule() {
            var date = new Date()
            if (scheduleTime >= date) {
                readJson()
            }
        }

        function parseArtiste(category, lookNext) {
            var date = new Date()
            var now = date
            var previous
            var next
            var currentArtist
            var nextArtist

            for (var a in category) {
                var artiste = category[a]

                var from = artiste.from
                var fromDate = Date.fromLocaleString(Qt.locale(), from, "dd/MM/yyyy hh:mm");
                var to = artiste.to
                var toDate = Date.fromLocaleString(Qt.locale(), to, "dd/MM/yyyy hh:mm");

                if (fromDate < now) {
                    if (previous) {
                        if (fromDate >= previous) {
                            previous = fromDate
                            currentArtist = a
                        }
                    } else {
                        previous = fromDate
                        currentArtist = a
                    }
                }
                if (fromDate > now) {
                    if (next) {
                        if (fromDate <= next) {
                            next = fromDate
                            nextArtist = a
                        }
                    } else {
                        next = fromDate
                        nextArtist = a
                    }
                }
            }
            if (lookNext) {
                return nextArtist
            } else {
                var currentToDate = Date.fromLocaleString(Qt.locale(), category[currentArtist].to, "dd/MM/yyyy hh:mm")
                if (currentToDate > now) {
                    return currentArtist
                }
            }
            return
        }

        function createContent(intro, category, currentArtiste, nextArtiste, nested, nextTextNested, nextTextAlone, timed, nextTextTime, nextTime) {
            var content = ""
            if (currentArtiste) {
                content = intro + " " + category + " : " + currentArtiste
                if (nested) {
                    if (nextArtiste) {
                        content += "   " + nextTextNested + " " + nextArtiste
                        if (timed) {
                            var date = new Date()
                            var nextDateTime = Date.fromLocaleString(Qt.locale(), nextTime, "dd/MM/yyyy hh:mm")
                            var nextHours = nextDateTime.getHours()
                            var nextMinutes = nextDateTime.getMinutes()
                            nextMinutes = nextMinutes.length > 1 ? nextMinutes : "0" + nextMinutes
                            content += " " + nextTextTime + " " + nextHours + "H" + nextMinutes
                        }
                    }
                }
            }
            return content
        }

        function createNextContent(intro, category, nextArtiste, nextTextTime, nextTime, enableNextTime){
            var content

            if (nextArtiste) {
                content = intro + " " + category + " : " + nextArtiste
                if (enableNextTime) {
                    var date = new Date()
                    var nextDateTime = Date.fromLocaleString(Qt.locale(), nextTime, "dd/MM/yyyy hh:mm")
                    var nextHours = nextDateTime.getHours()
                    var nextMinutes = nextDateTime.getMinutes()
                    nextMinutes = nextMinutes.length > 1 ? nextMinutes : "0" + nextMinutes

                    content += " " + nextTextTime + " " + nextHours + "H" + nextMinutes
                }
            }
            return content

        }

        function addContent(base, content) {
            base += content + new Array(JsonObject.footer.info.spacing).join( " " )
            return base
        }

        return scheduleContent + " " + scheduleContentNext
    }

    SequentialAnimation on footer_text.x{
        id: numberAnimation
        loops: Animation.Infinite

        PropertyAnimation {
            from : Screen.width
            to: footer_text.width * -1
            duration: ((footer_text.width + Screen. width) / textSpeed) * 100
        }
    }

    function readTime() {
        var date = new Date
        var h = time_utc ? date.getUTCHours() : date.getHours()
        var m = date.getMinutes()

        h = h + time_offset

        footer_clock_hours.text = h.toString()
        footer_clock_minutes.text = m > 9 ? m.toString() : "0" + m.toString()

        clock_bounding = footer_clock_hours.width
                + footer_clock_minutes.width
                + footer_clock_dots.width
                + footer_clock_spacing
    }

    Timer {
        running: true
        repeat: true
        onTriggered: readTime()
    }

    SequentialAnimation on footer_clock_dots.opacity {
        id: dotsAnimation
        loops: Animation.Infinite
        PropertyAnimation {
            to: 0
            duration: 10000
        }
        PropertyAnimation {
            to: 1
            duration: 10000
        }
    }

    Component.onCompleted: {
        readTime()
    }

    Connections {
        target: jsonConfig
        onDataChanged: {
            readJson()
            readTime()
        }
    }
}

