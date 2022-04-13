import QtQuick 2.0

Rectangle{
    id: toolLine
    width:           150
    height:          40
    color:           leftPan.color
    radius:          10
    anchors.margins: 25

    property string subjName: ""
    property int subjInfo: 0
    property int pointSize: 16
    property int slideCan: 0

    function onHoverChanged(containsMouse){

    }
    function onDel(){

    }
    function onTextChanged(newName){

    }
    function onInfoChanged(newInfo){

    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: onHoverChanged(containsMouse)
    }
    clip: true
    Row{
        anchors.fill: parent
        spacing: 5
        anchors.leftMargin: 5

        Rectangle{
            id: nameRec
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 5
            radius: height / 3
            width: parent.width - infoRec.width - 10 - 30//slideCan
            color: mainpage.color

            MyTextInput{
                id: nameInput
//                anchors.centerIn: parent


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
            id: infoRec
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: nameRec.right
            anchors.margins: 5
            width: 40
            radius: height / 3
            color: mainpage.color
            TextInput{
                id: infoInput
                anchors.centerIn: parent
                text: subjInfo
                maximumLength: 2
                color: textColor
                font.family: poiret.font
                font.pointSize: pointSize
                onTextChanged:  toolLine.onInfoChanged(text)
                validator: IntValidator{bottom: 1; top: 100;}
            }
            MouseArea{
                anchors.fill: parent
                onClicked: infoInput.forceActiveFocus()
            }
        }

        Image {
            id: can
            scale: parent.height / 75
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: infoRec.right
            anchors.leftMargin: -slideCan + 32
            source: "./images/delete-red.svg"
            MouseArea{
                anchors.fill: parent
                onClicked: onDel()
            }
        }
    }

}
