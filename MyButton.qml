import QtQuick.Window 2.12
import QtQuick 2.9
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3

Rectangle{
    id: button
    property string buttonText: ""
    property int hCOffset
    property int pointSize: 16
    property bool isHovered: false
    property bool readOnly: true
    property bool marked: false

    property bool inverted: false

    property color markColor: blue.color

    property color mainCol: inverted? mainpage.color : leftPan.color
    property color secCol: !inverted? mainpage.color : leftPan.color

    onReadOnlyChanged: {if(!readOnly) textInput.forceActiveFocus()}

    function onButtonClicked(){}
    function onButtonPressedAndHold(){}
    function onTextChanged(){}

    width:           150
    height:          40
    color:           marked? markColor : mainCol
    radius:          10
    anchors.margins: 25

    border.color: blue.color
    border.width: isHovered? 1 : 0
    Rectangle{
        anchors.fill: parent
        anchors.margins: parent.height / 7
        color: readOnly? parent.color : secCol
        radius: height / 4
        TextInput {
            id: textInput
            onFocusChanged: if(!focus) button.readOnly = true
            readOnly: button.readOnly
            Keys.onPressed: { if (event.key === Qt.Key_Return) button.readOnly = true; }
            text: buttonText
            color: textColor
            anchors.centerIn: parent
            font.family: poiret.font
            font.pointSize: pointSize
            onTextChanged: {buttonText = text; button.onTextChanged()}
        }
    }

    MouseArea{
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: hCOffset
        width: parent.width
        height: parent.height
        hoverEnabled: true
        onClicked: onButtonClicked()
        onPressAndHold: onButtonPressedAndHold()
        onContainsMouseChanged: isHovered = containsMouse
    }
}
