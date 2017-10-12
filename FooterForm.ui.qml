import QtQuick 2.7
import QtQuick.Layouts 1.3
import QtQuick.Window 2.3
import QtQuick.Controls 2.0

Item {
    width: 400
    height: 180
    visible: true

    property alias footer_info: footer_info
    property alias footer_text: footer_text
    property alias footer_clock: footer_clock
    property alias footer_clock_hours: clockHours
    property alias footer_clock_minutes: clockMinutes
    property alias footer_clock_dots: clockDots

    property bool time_utc: false
    property int time_offset: 0

    property int clock_bounding: 100

    property int footer_clock_spacing: 30

    anchors.bottomMargin: 0
    anchors.bottom: parent.bottom

    RowLayout {
        id: footer_layout
        anchors.fill: parent
        spacing: 0
        Rectangle {
            id: footer_info
            color: "#008080"
            scale: 1
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 100
            Text {
                id: footer_text
                text: parent.width + 'x' + parent.height
                transformOrigin: Item.Left
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Rectangle {
            id: footer_clock
            color: 'plum'
            Layout.columnSpan: 1
            Layout.rowSpan: 1
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            visible: true
            transformOrigin: Item.Right
            Layout.fillHeight: true
            Layout.preferredWidth: clock_bounding
            Text {
                id: clockHours
                anchors.verticalCenter: parent.verticalCenter
                text: parent.width
                visible: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                anchors.right: clockDots.left
                anchors.rightMargin: 0
                //transformOrigin: Item.Right
            }
            Text {
                id: clockDots
                anchors.centerIn: parent
                text: " : "
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                id: clockMinutes
                anchors.verticalCenter: parent.verticalCenter
                text: parent.height
                visible: true
                verticalAlignment: Text.AlignVCenter
                anchors.left: clockDots.right
                anchors.leftMargin: 0
                //transformOrigin: Item.Left
            }
        }
    }
    states: [
        State {
            name: "Start"

            PropertyChanges {
                target: footer_text
                anchors.leftMargin: 0
                anchors.rightMargin: 253
            }
        },
        State {
            name: "End"

            PropertyChanges {
                target: footer_text
                anchors.rightMargin: 253
            }
        }
    ]
}
