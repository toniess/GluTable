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

import QtQuick.Window 2.2

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0


Rectangle {
    property bool checked
    property bool canTap: true
    property bool reversedColor: false

    function posChanged(){}

    onCheckedChanged: {
        slideAnim.start()
        posChanged()
    }

    MouseArea{
        anchors.fill: parent
        enabled: canTap
        onClicked: if(canTap){
                       canTap = false
                       checked = !checked
                   }
    }

    id: control
    implicitWidth: 48
    implicitHeight: 26
    x: control.leftPadding
    y: parent.height / 2 - height / 2
    radius: implicitHeight / 2
    color: dayTheme? reversedColor? secColor : mainColor : blue.color

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.implicitHeight / 1.2
        property int aimX: control.checked?
                           round.parent.width - width - round.parent.implicitHeight / 1.1:
                           round.parent.implicitHeight / 1.1
        id: round
        height: width
        radius: control.radius
        color: reversedColor? mainColor : secColor
        Component.onCompleted: x = round.parent.width - width
                               - round.parent.implicitHeight / 1.1

        NumberAnimation{
            id: slideAnim
            target: round
            property: "x"
            to: round.aimX
            duration: 100
            onStopped: canTap = true
        }
    }
}

