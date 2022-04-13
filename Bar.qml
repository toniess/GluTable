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


TabBar{
    id: bar
    anchors.top: parent.top
    anchors.topMargin: 5
    anchors.left: plusButton.right
    anchors.leftMargin: 5
    currentIndex: 0

    background:{
        color: mainpage.color
    }

    TabBarContextMenu{
	id: menu
    }

    contentItem: Row{
	spacing: 5
	Repeater{
	    model: tabsmodel
	    delegate: Rectangle{
		id: tab
		width: (control.x - plusButton.x - plusButton.width  - 5) / (tabsmodel.count) - 5
		height: 30
		radius: 8
		color:  _pos == bar.currentIndex? blue.color : leftPan.color
        clip: true
        Rectangle{
            visible: false
            anchors.fill: parent
            radius: parent.radius
            color: "red"
            opacity: 0.2
        }

		Text{
		    id: name
		    anchors.centerIn: parent
		    text: tabsmodel.count < 8? _text + " Рота" : _text
		    color: !tab.down ? textColor : "black"
            font.family: helThin.font
		    font.styleName: "Light"
		    font.pointSize: 15
		}

		MouseArea{
            id: mouse
		    anchors.fill: parent
		    hoverEnabled: true
		    acceptedButtons: Qt.LeftButton | Qt.RightButton

		    onClicked: {
			if(mouse.button & Qt.RightButton) {
			    menu.openq(_pos)
			}else
			    bar.currentIndex = _pos
		    }
		}
	    }
	}
    }

    Repeater{
	model: tabsmodel
	delegate: TabButton{

	}
    }
}
