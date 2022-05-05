import QtQuick 2.0

ListModel {
    id: root

    signal winGame

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
            if (list[i] === 16) {
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
        let list = shuffle([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ])
        for(let i = 0; i < 16; i++) {
            if(list[i] === 16) blank_pos = i
            cells_list.append({"ind" : i, "cell_num" : list[i] })
        }
    }

    function isWin() {
        var win = true
        for(let i = 0; i < 14; i++) {
            if(parseInt(get(i).cell_num) > parseInt(get(i+1).cell_num))
                win = false
        }
        if(win && get(15).cell_num === 16)
            return true
        return false
    }

    function syncProperties(diff, index){
        setProperty(index, "ind", index)
        setProperty(blank_pos, "ind", blank_pos)
        blank_pos -= diff
    }

    function moveCell(index) {
        var diff = blank_pos - index
        if((1 === diff) && ((index + 1) % 4)){
            move(index, blank_pos, 1)
            syncProperties(diff, index)
        }
        else if(-1 === diff && (index % 4)){
            move(index, index - 1, 1)
            syncProperties(diff, index)
        }
        else if(-4 === diff){
            move(index, index - 4, 1)
            move(blank_pos + 1, index, 1)
            syncProperties(diff, index)
        }
        else if(4 === diff) {
            move(blank_pos, index, 1)
            move(index + 1, blank_pos, 1)
            syncProperties(diff, index)
        }
        if(isWin()) {
            winGame()
        }
    }

    Component.onCompleted: fill()
}
