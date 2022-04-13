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

import QtQuick.Window 2.2

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

//import QtGraphicalEffects 1.0



Rectangle{
    id: messageBox

    property var messageText: ""
    property var headerText: "Внимание!"
    function showMessage(header ,text){
        messageText = text
        if(header !== "")
            headerText = header

    }

    Connections{
       target: tableMixerClass
       function onShowMessage(header, message){
           messageBox.showMessage(header, message)
       }
    }
    Connections{
       target: homePageClass
       function onShowMessage(header, message){
           messageBox.showMessage(header, message)
       }
    }
    width: 140
    height: text.height + headText.height

    radius: 20
    color: mainpage.color
    clip: true

    Text {
        id: headText
        text: headerText
        color: textColor
        font.family: helThin.font
        font.styleName: "Light"
        font.pointSize: 14
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
    }

    TextArea {
        id: text
        anchors.top: headText.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        text: messageText
        font.styleName: "Thin"
        readOnly: true
        color: textColor
        font.family: helThin.font
        font.pointSize: 14
        horizontalAlignment: "AlignHCenter"
        wrapMode: Text.WordWrap
        width: parent.width
    }
    MouseArea{
        anchors.fill: parent
        onClicked:{
            toDisappear.start()

        }
    }

    NumberAnimation {
        id: toAppear
        target: messageBox
        property: "x"
        to: 7
        duration: 300
        onStopped:     PauseAnimation {
            duration: 3000
            onStopped: toDisappear.start()
        }
    }
    NumberAnimation {
        id: toDisappear
        target: messageBox
        property: "x"
        to: -200
        duration: 300
        onStopped: {
            messageText = ""
            headerText  = "Внимание!"
        }
    }
}
