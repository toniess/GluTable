import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtQuick.Controls.Private 1.0

//import QtQuick.Controls.Styles 1.4

//import QtQuick.Controls 1.1
import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

Rectangle{
    id: button
    property string buttonText: ""
    property bool popedUp: false


    width: parent.width
    height: miniButton.height + content.height
    color: "transparent"
    function buttonClicked(){
        popedUp = !popedUp
    }
    onPopedUpChanged: {
        heightAnim.start(popedUp? 100 : 0)
        scaleContentAnim.start(popedUp? 1 : 0.5)
        opacityAnim.start(popedUp? 1 : 0)
    }
    Rectangle{
        id: miniButton
        anchors.top: parent.top
        width: parent.width
        height: width/6
        radius: height/4
        color: mainColor//"transparent"
        MouseArea{anchors.fill: parent
            onClicked: buttonClicked();
            hoverEnabled: true
            onContainsMouseChanged: {scaleAnim.start(containsMouse? 1.05 : 1)}
            onPressed: scaleAnim.start(0.9)
            onReleased: if(miniButton.scale !== 1) scaleAnim.start(1.05)
        }
        NumberAnimation {
            id: scaleAnim
            target: miniButton
            property: "scale"
            to: 1
            duration: 100
            function start(aim){
                running = false; to = aim; running = true;
            }
        }
        Text {
            anchors.centerIn: parent
            anchors.verticalCenter: parent.verticalCenter
            id: text
            color: textColor
            font.family: helThin.font
            font.pointSize: height
            font.styleName: "Thin"
            text: buttonText
        }
    }
    Rectangle{
            id: content
            anchors.top: miniButton.bottom
            width: parent.width
            scale: 0.5
            opacity: 0
            color: "transparent"
            radius: width / 10

            FilePathInput{visible: ~~parent.scale; width: parent.width * 0.9; height: width/6}
        }

    NumberAnimation {
        id: heightAnim
        target: content
        property: "height"
        to: 100
        duration: 100
        function start(aim){
            running = false; to = aim; running = true
        }
    }
    NumberAnimation {
        id: scaleContentAnim
        target: content
        property: "scale"
        to: 1
        duration: 100
        function start(aim){
            running = false; to = aim; running = true
        }
    }
    NumberAnimation {
        id: opacityAnim
        target: content
        property: "opacity"
        to: 1
        duration: 200
        function start(aim){
            running = false; to = aim; running = true
        }
    }

}
