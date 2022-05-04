import QtQuick 2.12

Item {
    id: root

    signal shuffle

    // property int side_size: Math.min(parent.width, parent.height)

    width: parent.width
    height: parent.width

    onShuffle: cells_list.fill()

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

                function shuffle(list) {
                    for (var i = list.length - 1; i > 0; i--) {
                        var j = Math.floor(Math.random() * (i + 1));
                        var tmp = list[i];
                        list[i] = list[j];
                        list[j] = tmp;
                    }
                    return list
                }

                function fill() {
                    cells_list.clear()
                    let list = shuffle([ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16' ])
                    for(let i = 0; i < 16; i++)
                        cells_list.append({ cell_num: list[i] })
                }

                Component.onCompleted: fill()
            }

            cellWidth: parent.width/4
            cellHeight: parent.width/4

            delegate: Cell {
                text: cell_num
            }

            footer: footerComponent
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

    }
}
