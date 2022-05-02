import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 480
    height: 640
    visible: true
    title: qsTr("QML only game of fifteen")

    color: "#E7BD87"

    GameBoard {}
}
