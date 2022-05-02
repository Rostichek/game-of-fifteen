import QtQuick 2.12

Rectangle {
    id: root

    property alias text: label.text
    signal clicked

    width: view.cellHeight * 1.5

    height: view.cellHeight / 2
    radius: root.width / 2

    anchors.centerIn: parent

    color: "#DF863D"
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
        onClicked: {
            root.clicked()
        }
    }
}
