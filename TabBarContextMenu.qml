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
    property int pos: -1
    function action(){
        secondPage.delTab(pos)
    }

    function openq(pos){
        contextMenu.popup()
        this.pos = pos
    }

    background: Rectangle{
        radius: 10
        color: leftPan.color
    }

    id: contextMenu
    width: 75
    height: contentHeight

       contentItem:ListView{
            interactive: false
            anchors.fill: parent
            model: ["Удалить"]
            spacing: 1
            delegate: Rectangle{
                    height: 30
                    width: parent.width
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
                            action(modelData)
                            contextMenu.close()
                        }
                    }
                }
    }
}
