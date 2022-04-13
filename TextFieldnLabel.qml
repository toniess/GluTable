import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9
import QtQml 2.3
import QtQuick.Controls.Universal 2.3

Item {
    property string labelText: ""
    property color fieldColor: mainpage.color
    property string text: txtinpt.text

    function clear(){
        txtinpt.text = ""
    }

    Text {
        anchors.right: field.left
        anchors.rightMargin: 20
        anchors.verticalCenter: field.verticalCenter
        text: labelText
        color: textColor
        font.family:  helThin.font
        font.styleName: "Thin"
        font.pointSize: parent.height / 1.6
    }

    Rectangle{
        property bool isHovered: false
        id: field
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: fieldColor
        border.width: isHovered? 1 : 0
        border.color: blue.color

        radius: 5

        HoverHandler{
           onHoveredChanged: parent.isHovered = hovered
        }

        TextInput{
            id: txtinpt
            color: textColor
            font.family:  helThin.font
            font.styleName: "Light"
            font.pointSize: parent.height / 1.6
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 5
            anchors.verticalCenterOffset: 4
            width: parent.width
            height: parent.height
        }
    }
}
