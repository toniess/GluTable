import QtQuick 2.0

Rectangle{
    id: toolLine
    width:           150
    height:          40
    color:           leftPan.color
    radius:          10
    anchors.margins: 25

    property string subjName: ""
    property int pointSize: 16
    property int slideCan: 0
    property bool canDel: true

    function onHoverChanged(containsMouse){

    }
    function onDel(){

    }
    function onTextChanged(newName){

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
            anchors.margins: 5
            radius: height / 3
            anchors.rightMargin: canDel? 40 : 5
            color: mainpage.color

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

        Image {
            id: can
            scale: parent.height / 75
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: nameRec.right
            anchors.leftMargin: -slideCan + 32
            source: "./images/delete-red.svg"
            MouseArea{
                anchors.fill: parent
                onClicked: onDel()
            }
        }

}
