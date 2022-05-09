#include "field.h"
#include <random>
#include <algorithm>
#include <QtDebug>

Field::Field(QObject *parent)
    : QAbstractListModel(parent), cells(field_size * field_size), field_size(4)
{
    addCells();
    shuffle();
}

int Field::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    return cells.size();
}

QVariant Field::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if(index.row() < cells.size())
        return cells.at(index.row());

    return QVariant();
}

void Field::shuffle() {
    beginResetModel();
    do {
        std::random_device rd;
        std::mt19937 g(rd());
        std::shuffle(cells.begin(), cells.end(), g);
    } while (!isSolvable());
    endResetModel();

    auto it = std::find(cells.cbegin(), cells.cend(), 16);
    blank_pos = it - cells.cbegin();

    closeWinMsg();
}

void Field::move(const int index) {
    auto swapRows = [&]() {
        std::swap(cells[index], cells[blank_pos]);
        endMoveRows();
        blank_pos = index;
    };

    int diff = blank_pos - index;

    if ((1 == diff) && ((index + 1) % field_size)) {
        beginMoveRows(QModelIndex(), index, index, QModelIndex(), blank_pos+1);
        swapRows();
    }
    else if (-1 == diff && (index % field_size)) {
        beginMoveRows(QModelIndex(), index, index, QModelIndex(), blank_pos);
        swapRows();
    }
    else if (-field_size == diff) {
        beginMoveRows(QModelIndex(), index, index, QModelIndex(), index-4);
        endMoveRows();
        beginMoveRows(QModelIndex(), blank_pos + 1, blank_pos + 1, QModelIndex(), index + 1);
        swapRows();
    }
    else if (field_size == diff) {
        beginMoveRows(QModelIndex(), index, index, QModelIndex(), blank_pos + 1);
        endMoveRows();
        beginMoveRows(QModelIndex(), blank_pos - 1, blank_pos - 1, QModelIndex(), index);
        swapRows();
    }

    isSolved();
}

bool Field::isSolved() const {
    bool is_win { true };
    for (size_t i = 0; i < cells.size() - 2; i++)
        if (cells.at(i) > cells.at(i+1))
            is_win = false;

    if(is_win && cells.back() == cells.size()) {
        showWinMsg();
        return true;
    }
    return false;
}

void Field::addCells() {
    size_t i { 1 };

    for(auto& cell : cells)
        cell = i++;
}

bool Field::isSolvable() const {
    size_t invCount = getInvertionsCount();

    if (findBlankRow() & 1)
        return !(invCount & 1);
    else
        return invCount & 1;
}


size_t Field::getInvertionsCount() const {
    size_t counter { 0 };

    for (size_t i = 0; i < cells.size() - 1; i++) {
        for (size_t j = i + 1; j < cells.size(); j++) {
            if (cells.at(j) && cells.at(i) && cells.at(i) > cells.at(j))
                counter++;
        }
    }

    return counter;
}

size_t Field::findBlankRow () const {
    return field_size - blank_pos / field_size;
}


