import QtQuick 2.12

Rectangle {
    id: root

    property alias text: label.text
    signal clicked

    state: "RELEASED"

    width: view.cellHeight * 1.5
    height: view.cellHeight / 2
    radius: root.width / 2

    anchors.centerIn: parent

    border {
        color: "#B66C2D"
        width: 2
    }

    Text {
        id: label
        anchors.centerIn: parent
        text: "Text"
    }

    MouseArea {
        anchors.fill: parent
        onPressed: root.state = "PRESSED"
        onReleased: root.state = "RELEASED"
        onClicked: root.clicked()
    }

    states: [
            State {
                name: "PRESSED"
                PropertyChanges { target: root; color: "#E79959"}
            },
            State {
                name: "RELEASED"
                PropertyChanges { target: root; color: "#DF863D"}
            }
        ]
}
