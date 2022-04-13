import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3


import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9


Menu{
    property int lastCol
    property int lastTable

    id: contextMenu2

    function openq(_x, _y, col, table){
        contextMenu2.popup()
        contextMenu2.x = _x + 400 > mainpage.x + mainpage.width - 200 ? _x - 200 : _x + 200
        contextMenu2.y = _y + 93
        contextMenu2.visible = true
        lastCol = col
        lastTable = table
    }
    function action(subjectName){
        subjectSettingsClass.fillTableCollumn(subjectName, lastTable, lastCol)
    }

    background: Rectangle{
        radius: 10
        color: leftPan.color
    }


    width: 200
    height: 31 * subjectConfigList.count > 155 ? 155 : 31 * subjectConfigList.count

       contentItem:ListView{
           ScrollBar.vertical: MyScrollBar {width: 5;}

           interactive: true
           anchors.fill: parent
           model: subjectConfigList
           clip: true
           spacing: 1
           delegate: Rectangle{
                   height: 30
                   width: 190
                   radius: 10
                   color: leftPan.color
                   anchors.horizontalCenter: parent.horizontalCenter

                   Text {
                       anchors.verticalCenter: parent.verticalCenter
                       anchors.left: parent.left
                       anchors.leftMargin: 12
                       text: _name
                       color: textColor
                       font.family: helThin.font
                       font.styleName: "Thin"
                       font.pointSize: 14
                   }

                   HoverHandler{
                       onHoveredChanged: {
                           if(hovered){
                               parent.color = blue.color
                           }else{
                               parent.color = leftPan.color
                           }
                       }
                   }

                   MouseArea{
                       id: mouse
                       anchors.fill: parent
                       onClicked: {
                           parent.color = leftPan.color
                           contextMenu2.close()
                           contextMenu.close()
                           action(_name)
                       }
                   }
               }
   }
}
