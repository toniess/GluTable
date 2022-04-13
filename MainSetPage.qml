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

Rectangle{
    color: mainpage.color

    Connections{
        target: mainSettingsClass
        onAddMainSetting: mainSetList.append({
                          _id: mainSetList.count,
                          _nameText: settingName,
                          _textLine: settingValue
                         })
    }
    ListModel{
        id: mainSetList
    }
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "Основные"
        font.family: poiret.font
        font.pointSize: 40
        color: textColor
    }

    ListView{
        anchors.fill: parent
        anchors.topMargin: 200
        clip: true
        model: mainSetList
        spacing: 10
        delegate: Item{
            anchors.horizontalCenter: parent.horizontalCenter
            height: 50
            width: parent.width
            TeacherProfileInput{
                id: input
                canDel: false
                subjName: _textLine
                width: parent.width / 3
                anchors.horizontalCenter: parent.horizontalCenter
                function onTextChanged(newName){
                    mainSetList.setProperty(_id, "_textLine", newName)
                    var arr = ""
                    for(var i = 0; i < mainSetList.count; i++)
                        arr += (mainSetList.get(i)._nameText + "-" + mainSetList.get(i)._textLine + '\n')
                    mainSettingsClass.saveSettings(arr, "settings/main.gts")
                }
            }
            Text {
                anchors.right: input.left
                anchors.rightMargin: 20
                anchors.verticalCenter: input.verticalCenter
                text: _nameText
                font.family: poiret.font
                font.pointSize: 15
                color: textColor
            }
        }
    }
}
