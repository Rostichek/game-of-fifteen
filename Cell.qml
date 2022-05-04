import QtQuick 2.12

Item {
    id: root
    property alias text: number.text

    width: view.cellHeight
    height: view.cellHeight

    Rectangle {
        id: cell

        radius: root.width / 10

        anchors.fill: parent
        anchors.margins: 5
        color: (text === "16") ? "blue" : "#DF863D"

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
    }
}

