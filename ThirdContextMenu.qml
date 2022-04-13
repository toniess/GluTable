import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtQuick.Controls 1.1
import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9


Menu{
    property int lastCol
    property int lastTable
    property string lastTeacher
    property string lastSubject

    function action(actionName){
//        if(actionName === "Взвод"){
//            if(lastTable == 1)
//                secondTab1.distributeTeachers(lastSubject, lastTeacher, 1, lastCol)
//            if(lastTable == 2)
//                secondTab2.distributeTeachers(lastSubject, lastTeacher, 1, lastCol)
//            if(lastTable == 3)
//                secondTab3.distributeTeachers(lastSubject, lastTeacher, 1, lastCol)
//        }
//        if(actionName === "Рота"){
//            if(lastTable == 1)
//                secondTab1.distributeTeachers(lastSubject, lastTeacher, 0, lastCol)
//            if(lastTable == 2)
//                secondTab2.distributeTeachers(lastSubject, lastTeacher, 0, lastCol)
//            if(lastTable == 3)
//                secondTab3.distributeTeachers(lastSubject, lastTeacher, 0, lastCol)
//        }
//        if(actionName === "Корпус"){
//                secondTab1.distributeTeachers(lastSubject, lastTeacher, 0, lastCol)
//                secondTab2.distributeTeachers(lastSubject, lastTeacher, 0, lastCol)
//                secondTab3.distributeTeachers(lastSubject, lastTeacher, 0, lastCol)
//        }
    }

    function openq(_x, _y, col, table, teacher, subject){
        contextMenu3.popup()
        contextMenu3.x = _x + 400 > mainpage.x + mainpage.width - 200 ? _x - 200 : _x + 200
        contextMenu3.y = _y + 124
        contextMenu3.visible = true
        lastCol = col
        lastTable = table
        lastTeacher = teacher
        lastSubject = subject
    }

    background: Rectangle{
        radius: 10
        color: leftPan.color
    }
    id: contextMenu3
    width: 200
    height: 93

       contentItem:ListView{
           ScrollBar.vertical: ScrollBar {width: 5}
           interactive: true
           anchors.fill: parent
           model: ["Взвод", "Рота", "Корпус"]
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
                       anchors.leftMargin: 15
                       text: modelData
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
                           contextMenu3.close()
                           contextMenu.close()
                           action(modelData)
                       }
                   }
               }
   }
}
