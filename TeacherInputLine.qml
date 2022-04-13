import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15
import QtQuick.Controls 2.5


import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9
Item{
    id: teacherLine
    property string teacherName
    property int pointSize: 16
    property bool isExtraListOpened: false
    property var listInfo: ["ghbdtn", "gjrf"]
    property var list: isExtraListOpened? listInfo : []
    property int lineHeight
    property int lineWidth
    width: 300//contentWidth
    height: mainRec.height + extraList.height
    function onTextChanged(text){}
    TapHandler{
        onTapped: isExtraListOpened = !isExtraListOpened
    }
    Rectangle{
    id: mainRec


        width:           lineWidth
        height:          lineHeight
        color:           leftPan.color
        radius:          height / 3
        Rectangle{
            anchors.fill: parent
            anchors.rightMargin: parent.width / 8
            anchors.leftMargin: anchors.rightMargin
            anchors.margins: 5
            radius: height / 3
            color:  mainpage.color
            MyTextInput{
                id: nameInput
                text: teacherName
                color: textColor
                font.family: poiret.font
                font.pointSize: pointSize
                onTextChanged:  toolLine.onTextChanged(text)
            }
            MouseArea{
                anchors.fill: parent
                onClicked: nameInput.forceActiveFocus()
            }
        }
    }
    ListView{
        id: extraList
        height: contentHeight
        anchors.top: mainRec.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        model: teacherLine.list
        delegate: MyButton{}
    }
}
