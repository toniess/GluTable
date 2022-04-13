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

    width: 50
    height: 30
    radius: 10
    color: "darkgreen"

    property string image
    property real imageScale: 1
    property bool isHovered: mouse.containsMouse

    function buttonClicked(){

    }

    Image {
    id: imageButton
    source: image
	anchors.centerIn: parent
    scale: imageScale

    }

    MouseArea{
    id: mouse
	anchors.fill: parent
	hoverEnabled: true
	onEntered: {
	    parent.opacity = 0.9
	}
	onExited: {
	    parent.opacity = 1
	}

	onReleased: {
        //saveButtonText.color = textColor
	}
    onClicked: buttonClicked()
    }

    onIsHoveredChanged:
        NumberAnimation{
        target: button
        property: "scale"
        to: isHovered? 1.05 : 1
        duration: 100
    }
}
