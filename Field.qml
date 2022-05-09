import QtQuick 2.0

ListModel {
    id: root

    signal winGame

    property var blank_pos
    property int field_size: 4


    /*!
    *\brief Computes number of inversions in the list ([ 1, 2, 4, 3 ] - inversion is 4, 3)
    */
    function getInvertionsCount(list) {
        let counter = 0
        for (var i = 0; i < list.length - 1; i++) {
            for (var j = i + 1; j < list.length; j++) {
                if (list[j] && list[i] && list[i] > list[j])
                    counter++
            }
        }
        return counter
    }


    /*!
    *\brief Returns in what row from the bottom is a blank cell
    */
    function findBlank() {
        return field_size - Math.floor(blank_pos / field_size)
    }


    /*!
    *\brief Checks can this order of cells be solved in the game of fifteen
    */
    function isSolvable(list) {
        let invCount = getInvertionsCount(list)

        if (findBlank() & 1)
            return !(invCount & 1)
        else
            return invCount & 1
    }


    /*!
    *\brief Shuffles list
    */
    function shuffle(list) {
        do {
            for (var i = list.length - 1; i > 0; i--) {
                var j = Math.floor(Math.random() * (i + 1))
                var tmp = list[i]
                list[i] = list[j]
                list[j] = tmp
            }
        } while (!isSolvable(list))
        return list
    }


    /*!
    *\brief Fills the game field with shuffled cells
    */
    function fill() {
        cells_list.clear()
        let list = []
        list.length = field_size * field_size
        for (var i = 0; i < list.length; i++)
            list[i] = i + 1
        list = shuffle(list)

        for (var i = 0; i < list.length; i++) {
            if (list[i] === field_size * field_size)
                blank_pos = i
            cells_list.append({
                                  "ind": i,
                                  "cell_num": list[i]
                              })
        }
    }


    /*!
    *\brief Checks if cells are in the right order
    */
    function isWin() {
        var win = true
        for (var i = 0; i < field_size * field_size - 2; i++) {
            if (get(i).cell_num > get(i + 1).cell_num)
                win = false
        }
        if (win && get(field_size - 1).cell_num === field_size * field_size)
            return true
        return false
    }


    /*!
    *\brief Sets indexes of swapped cells
    */
    function syncProperties(diff, index) {
        setProperty(index, "ind", index)
        setProperty(blank_pos, "ind", blank_pos)
        blank_pos -= diff
    }


    /*!
    *\brief Swaps cell by index with a blank if it's possible
    */
    function moveCell(index) {
        var diff = blank_pos - index
        if ((1 === diff) && ((index + 1) % field_size)) {
            move(index, blank_pos, 1)
            syncProperties(diff, index)
        } else if (-1 === diff && (index % field_size)) {
            move(index, index - 1, 1)
            syncProperties(diff, index)
        } else if (-field_size === diff) {
            move(index, index - field_size, 1)
            move(blank_pos + 1, index, 1)
            syncProperties(diff, index)
        } else if (field_size === diff) {
            move(blank_pos, index, 1)
            move(index + 1, blank_pos, 1)
            syncProperties(diff, index)
        }
        if (isWin()) {
            winGame()
        }
    }

    Component.onCompleted: fill()
}
