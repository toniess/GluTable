import QtQuick 2.0

TextInput{
    id: tI
//    anchors.fill: parent
    anchors.centerIn: parent
    anchors.leftMargin: 10
    horizontalAlignment:/* cursorVisible? TextInput.AlignLeft :*/ TextInput.AlignHCenter
    verticalAlignment:   TextInput.AlignVCenter
    selectionColor: blue.color
    onHorizontalAlignmentChanged:{tI.selectAll()}

    property var db: subjectSettingsClass.getSubjectDb()

    onCursorVisibleChanged: helpText.text = text

    onTextChanged: {
        if(tI.text !== "" && tI.cursorVisible)
        for(var i = 0; i < db.length; i++){
            var string = db[i]
            if(string.indexOf(text) === 0){
                helpText.text = string
                return
            }
        }
        helpText.text = text
    }
    readOnly: !focus

    Keys.onPressed: { if(event.key === Qt.Key_Return){ text = helpText.text; tI.focus = false}}
    Text{
        id: helpText
        visible: false
        height: parent.height
        font.pointSize: parent.font.pointSize
        font.styleName: parent.font.styleName
        color: parent.selectedText.length > 0? parent.selectedTextColor : parent.color
        text: ""

        anchors.fill: parent
        horizontalAlignment: tI.horizontalAlignment
        verticalAlignment: tI.verticalAlignment
        opacity: 0.8
        font.family: parent.font.family
    }
}
