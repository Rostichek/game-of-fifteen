#ifndef FIELD_H
#define FIELD_H

#include <QAbstractListModel>
#include <vector>

class Field : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit Field(QObject *parent = nullptr);

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void shuffle();
    Q_INVOKABLE void move(const int index);

Q_SIGNALS:
        void showWinMsg() const;
        void closeWinMsg() const;

public:
    using Cell = int;

private:
    const size_t field_size;
    size_t blank_pos { 0 };
    std::vector<Cell> cells;

private:
    void addCells();

    bool isSolvable() const;
    bool isSolved() const;
    size_t getInvertionsCount() const;
    size_t findBlankRow() const;

};

#endif // FIELD_H
