import QtQuick 2.0
import QtQuick.Controls 2.4

ScrollBar {
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    interactive: true
    orientation: Qt.Vertical

    visible: size === 1? false : true
    width: 8
    contentItem: Rectangle{
	property bool moving: parent.active
	id: rect
	color: leftPan.color
	radius: width/2
	onMovingChanged: moving? anim.restart() : anim2.restart()
	ColorAnimation {
	    id: anim
	    target: rect
	    property: "color"
	    to: blue.color
	    duration: 200
	}
	ColorAnimation {
	    id: anim2
	    target: rect
	    property: "color"
	    to: leftPan.color
	    duration: 200
	}
    }
}
