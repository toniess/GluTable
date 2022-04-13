import QtQuick 2.0

Rectangle{
    id: toolLine
    width:           150
    height:          40
    color:           mainColor
    radius:          10
    anchors.margins: 25

    property string subjName: ""
    property int pointSize: 16

    function onHoverChanged(containsMouse){

    }
    function onDel(){

    }
    function onTextChanged(newName){

    }
    function buttonClicked(){

    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: onHoverChanged(containsMouse)
    }
    clip: true

        Rectangle{
            id: nameRec
            anchors.fill: parent
            radius: height / 3
            anchors.margins: 5
            anchors.rightMargin: 40
            color: secColor

            MyTextInput{
                id: nameInput
                text: subjName
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
        Rectangle{
            id: button
            anchors.left: nameRec.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5
            height: nameRec.height
            width: 30
            radius: nameRec.radius
            color: secColor
        }

}
