import QtQuick 2.12

Item {
    id: root

    property var animDuration: 300

    signal shuffle
    signal moveCell(var from)
    signal win

    onShuffle: {
        win_msg.visible = false
        cells_list.fill()
    }

    onMoveCell: function(from) { cells_list.moveCell(from) }
    onWin: win_msg.visible = true

    width: parent.width
    height: parent.width

    Rectangle {
        id: board

        anchors.fill: parent
        anchors.margins: 10

        color: "#FFEDD8"

        GridView {
            id: view

            anchors.fill: parent

            interactive: false

            cellWidth: parent.width/4
            cellHeight: parent.width/4

            model: Field {
                id: cells_list

                onWinGame: win_msg.visible = true
            }

            delegate: Cell {
                text: cell_num
                index: ind

                onClick: function(index) { root.moveCell(index) }
            }

            footer: footerComponent

            move: cellsTransition
        }

        WinMsg {
            id: win_msg
        }
    }

    Component {
        id: footerComponent

        Item{
            width: board.width
            height: root.height/4
            Button{
                onClicked: root.shuffle()
                text: "MIX"
            }
        }
    }

    Transition {
        id: cellsTransition

        NumberAnimation {
            properties: "x, y"
            duration: animDuration
        }
    }
}
