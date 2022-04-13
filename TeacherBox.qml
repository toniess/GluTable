import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

ComboBox {
    property bool itWasProgramm: true
    id: control
    anchors.right: buttonSave.left
    anchors.top: secpage.top
    anchors.topMargin: -1
    anchors.rightMargin: 10
    onCountChanged: {currentIndex = 0}

    signal unMark(var index)

    function setDisplayText(text){
        displayText = text
    }

    width: 245
    height: 42

    model: teacherBoxModel
    background: Rectangle{
        id: mainLine
        radius: 10
        color: leftPan.color
        border.color: blue.color
        border.width: 0
    }
    
    delegate: ItemDelegate {
        id: popupDelegate
        property int indexOfThisDelegate: index
        width: control.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        contentItem: Text{
                text: modelData
                color: textColor
                font.family: helThin.font
                x: 10
                font.pointSize: 14

                font.styleName: "Thin"
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
        }

        background: Rectangle{
            id: bg
            color: "transparent"
            radius: 10
            HoverHandler{onHoveredChanged: if(hovered) {parent.color = blue.color; unMark(popupDelegate.indexOfThisDelegate)}}
            Connections{
                target: control
                function onUnMark(index){
                    if(index !== popupDelegate.indexOfThisDelegate)
                        bg.color = leftPan.color
                }
            }
        } 
        MouseArea{
            anchors.fill: parent
            onClicked:{
                displayText = modelData
                control.popup.close()
                changeTeacherinTableItem(modelData)
            }
        }
        highlighted: control.highlightedIndex === index
    }
    
    contentItem: Text {
        text: control.displayText
        font.family: helThin.font
        color: textColor
        font.styleName: "Light"
        font.pointSize: 14
        verticalAlignment: Text.AlignVCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    
    popup: Popup {
        y: 45
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1
        contentItem: ListView {
            anchors.fill: parent
            anchors.topMargin: 5
            clip: true
            implicitHeight: contentHeight < 200 ? contentHeight : 200
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            spacing: 0
            ScrollBar.vertical: MyScrollBar{width: 4; stepSize: 42/*anchors.rightMargin: 10*/}
        }
        
        background: Rectangle {
            color: leftPan.color //"transparent"
            radius: 20
        }
        onOpened: {
            teacherModel.copyToBoxModel()
            if(currentItemText !== "" && currentItemText.indexOf(undefined) != 0)
                teacherBoxModel.sort(currentItemText)
        }
    }
    
    indicator: Rectangle {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        color: blue.color
        width: 10
        height: 10
        radius: 5
        opacity: 0.6
    }
    
}
