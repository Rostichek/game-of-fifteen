import QtQuick 2.0

Rectangle {
    id: root

    height: parent.height/3
    width: parent.width

    anchors.centerIn: parent

    color: "lightblue"

    visible: false

    Text {
        id: label
        anchors.centerIn: parent
        text: "You are Win\nPress MIX to shuffle"
    }

}
