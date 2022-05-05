import QtQuick 2.12

Item {
    id: root

    signal shuffle
    signal moveCell(var from)


    // property int side_size: Math.min(parent.width, parent.height)

    width: parent.width
    height: parent.width

    onShuffle: cells_list.fill()
    onMoveCell: function(from) { cells_list.moveCell(from) }

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

                property var blank_pos

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
                    for(let i = 0; i < 16; i++) {
                        if(list[i] === '16') blank_pos = i
                        cells_list.append({"ind" : i, "cell_num": list[i] })
                    }
                }

                function moveCell(index) {
                    if(Math.abs(blank_pos - index) === 1 ||
                            Math.abs(blank_pos - index) === 4) {
                        insert(blank_pos, get(index))
                        setProperty(blank_pos, "ind", blank_pos)
                        remove(blank_pos+1)
                        setProperty(index, "cell_num", "16")
                        blank_pos = index
                    }
                }

                Component.onCompleted: fill()
            }

            cellWidth: parent.width/4
            cellHeight: parent.width/4

            delegate: Cell {
                text: cell_num
                index: ind

                onClick: function(index) { root.moveCell(index) }
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
