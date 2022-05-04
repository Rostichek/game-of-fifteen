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

                function getInvertionsCount(list) {
                    let counter = 0
                    for (let i = 0; i < 15; i++) {
                        for (let j = i + 1; j < 16; j++) {
                            if (list[j] && list[i] && list[i] > list[j])
                                counter++
                        }
                    }
                    return counter;
                }

                function findBlank (list) {
                    for (let i = 0; i < list.length; i++)
                        if (list[i] == '16') {
                            return 4 - Math.floor(i/4)
                        }
                }

                function isSolvable(list) {
                    let invCount = getInvertionsCount(list);

                    let pos = findBlank(list);
                    if (pos & 1)
                        return !(invCount & 1);
                    else
                        return invCount & 1;
                }

                function shuffle(list) {
                    do {
                        for (var i = list.length - 1; i > 0; i--) {
                            var j = Math.floor(Math.random() * (i + 1));
                            var tmp = list[i];
                            list[i] = list[j];
                            list[j] = tmp;
                        }
                    } while (!isSolvable(list))
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
