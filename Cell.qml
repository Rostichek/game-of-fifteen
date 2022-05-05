import QtQuick 2.12

Item {
    id: root
    property alias text: number.text
    property var index

    signal click(var index)

    width: view.cellHeight
    height: view.cellHeight

    visible: (text === "16") ? false : true

    Rectangle {
        id: cell

        radius: root.width / 10

        anchors.fill: parent
        anchors.margins: 5
        color: "#DF863D"

        Text {
            id: number

            color: "black"

            anchors.centerIn: parent

            font {
                family: "Roboto"
                weight: "Medium"
                pixelSize: root.width / 4
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: click(index)
            onEntered: cell.state = "ENTERED"
            onExited: cell.state = "EXITED"
        }

        states: [
                State {
                    name: "ENTERED"
                    PropertyChanges { target: cell; color: "#E79959"}
                },
                State {
                    name: "EXITED"
                    PropertyChanges { target: cell; color: "#DF863D"}
                }
            ]
    }
}

