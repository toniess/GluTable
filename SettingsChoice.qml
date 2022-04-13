import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtQuick.Controls 1.1
import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

//import QtQuick.Controls.Styles 1.4

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

//import QtGraphicalEffects 1.0

Page{
    Rectangle{
        anchors.fill: parent
        color: mainpage.color
        ListView {

            ScrollBar.vertical: ScrollBar{
                active: true
            }
            
            id: settingsList
            anchors.fill: parent
            clip: true
            model: settingsModel
            spacing: 10
            delegate: Rectangle{
                id: rect
                border.color: blue.color
                border.width: 0
                radius: 20
                height: 100
                color:  _id == -1 ? "transparent" : leftPan.color
                width:  parent.width
                Text {
                    anchors.centerIn: parent
                    text:          _text
                    color:         textColor
                    font.family:    _id == -1 ? poiret.font : helThin.font
                    font.pointSize: _id == -1 ? 40 : 20
                    font.styleName: _id == -1 ?  "Light" : "Thin"
                }
                MouseArea{
                    enabled: _id == -1 ? false : true
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        rect.border.width = 2
                    }
                    onExited: {
                        rect.border.width = 0
                    }
                    
                    onClicked: {
                        settingsPage.setIndex(1);
                        settings.setIndex(_id)
                    }
                }
            }
        }
    }
}
