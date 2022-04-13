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
    property int lastRow
    property int lastCol
    property int lastTable
    property string lastTeacher
    property string lastSubject
    property string cutTeacher
    property string cutSubject

    function action(actionName){

    }

    function openq(col, row, table, teacher, subject){
        contextMenu.popup()
        lastRow = row
        lastCol = col
        lastTable = table
        lastTeacher = teacher
        lastSubject = subject === undefined? "" : subject
    }

    background: Rectangle{
        radius: 10
        color: leftPan.color
    }

    id: contextMenu
    width: 200
    height: 155

       contentItem:ListView{
            interactive: false
            anchors.fill: parent
            model: ["Копировать", "Вырезать", "Вставить", "Заполнить", "Распределить"]
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
                        text: modelData
                        color: textColor
                        font.family: helThin.font
                        font.styleName: "Thin"
                        font.pointSize: 14
                    }

                    Rectangle{
                        visible: modelData == "Заполнить" || modelData == "Распределить"? true: false
                        width: 10
                        height: 10
                        radius: 5
                        color: blue.color
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        opacity: 0.6
                    }

                    HoverHandler{
                        onHoveredChanged: {
                            if(hovered){
                                parent.color = blue.color
                                if(modelData == "Заполнить"){
                                    contextMenu2.openq(contextMenu.x,contextMenu.y, lastCol, lastTable);
                                    contextMenu3.close()
                                }else
                                    if(modelData == "Распределить"){
                                        contextMenu3.openq(contextMenu.x,contextMenu.y, lastCol, lastTable, lastTeacher, lastSubject);
                                        contextMenu2.close()
                                    }else{
                                        contextMenu2.close()
                                        contextMenu3.close()
                                    }
                            }else{
                                parent.color = leftPan.color
                            }
                        }
                    }

                    MouseArea{
                        id: mouse
                        anchors.fill: parent
                        onClicked: {
                            action(modelData)
                            contextMenu.close()
                        }
                    }
                }
    }
}
