import QtQuick 2.0

ListModel {
    id: root

    signal winGame

    property var blank_pos

    /*!
    *\brief Computes number of inversions in the list ([ 1, 2, 4, 3 ] - inversion is 4, 3)
    */
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

    /*!
    *\brief Returns in what row from the bottom is a blank cell
    */
    function findBlank () {
        return 4 - Math.floor(blank_pos / 4)
    }

    /*!
    *\brief Checks can this order of cells be solved in the game of fifteen
    */
    function isSolvable(list) {
        let invCount = getInvertionsCount(list);

        if (findBlank() & 1)
            return !(invCount & 1);
        else
            return invCount & 1;
    }

    /*!
    *\brief Shuffles list
    */
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

    /*!
    *\brief Fills the game field with shuffled cells
    */
    function fill() {
        cells_list.clear()
        let list = shuffle([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16 ])
        for(let i = 0; i < 16; i++) {
            if(list[i] === 16) blank_pos = i
            cells_list.append({"ind" : i, "cell_num" : list[i] })
        }
    }

    /*!
    *\brief Checks if cells are in the right order
    */
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

    /*!
    *\brief Sets indexes of swapped cells
    */
    function syncProperties(diff, index){
        setProperty(index, "ind", index)
        setProperty(blank_pos, "ind", blank_pos)
        blank_pos -= diff
    }


    /*!
    *\brief Swaps cell by index with a blank if it's possible
    */
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
