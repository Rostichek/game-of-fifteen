import QtQuick 2.12

Item {
    id: root

    // property int side_size: Math.min(parent.width, parent.height)

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

            model: ListModel {
                id: cells_list

                function fill() {
                    for(let i = 1; i <= 16; i++)
                        cells_list.append({ cell_num: i })
                }

                Component.onCompleted: fill()

            }

            cellWidth: parent.width/4
            cellHeight: parent.width/4

            delegate: Cell {
                text: index + 1
            }

            footer: footerComponent
        }


        Component {
            id: footerComponent
            Item{
                width: board.width
                height: root.height/4
                Button{
                    text: "MIX"
                }
            }

        }

    }
}
