import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

Rectangle{
    property int indexFocus: -1
    property bool needToFocus: false
    property string focusedName: "-1"
    property int dropID: -1
    property int draggedID: -1
    property bool canDrop: false
    property string hoveredTeacher: secondPage.hoveredTeacher

    onHoveredTeacherChanged: {
        for(var i = 0; i < tabsTable.count; i++)
            if(tabsTable.get(i)._teacher === hoveredTeacher)
                lightedRows.push(tabsTable.get(i)._row)
    }


    onDropIDChanged:{
        dropAnim.restart()
        canDrop = false
    }

    function setTableItem(cppText, cppWidth, cppHeight, cppBold, cppRow, cppCol, cppTeacher){
        tabsTable.insert(tabsTable.count,{
                         _id: tabsTable.count,
                         _text: cppText,
                         _spanWidth: cppWidth,
                         _spanHeight: cppHeight,
                         _bold: cppBold,
                         _row: cppRow,
                         _col: cppCol,
                         _teacher: cppTeacher
                         })
    }

    function makeupTimeTable(){
        var array = []
        for(var i = 0; i < tabsTable.count; i++){
            if(tabsTable.get(i)._bold !== 1){
                array.push(tabsTable.get(i)._text)
                array.push(tabsTable.get(i)._teacher)
                array.push(tabsTable.get(i)._row)
                array.push(tabsTable.get(i)._col)
            }
        }
        return array
    }

    function makeTimeTable(row){
        var array = []
        for(var i = 0; i < tabsTable.count; i++){
            if(tabsTable.get(i)._bold === 0 && tabsTable.get(i)._row === row){
                array.push(tabsTable.get(i)._teacher)
            }
        }
        return array
    }
    Connections{
        target: tableMixerClass
        onSetTableItem: {
            if(table == 1)
            for(var i = 0;i < tabsTable.count; i++){
                if(tabsTable.get(i)._row == row && tabsTable.get(i)._col == col){
                    tabsTable.setProperty(i,"_text", subject == ""? " " : subject)
                    tabsTable.setProperty(i,"_teacher", teacher)
                    break;
                }
            }
        }
    }

    Connections{
        target: homePageClass
        onClearWorkSpace: tabsTable.clear()
    }
    Connections{
        target: subjectSettingsClass
        onSetTableCollumn:{
            if(table == 2){
                var k = 0;
                for(var i = 0; i < tabsTable.count; i++){
                   if(tabsTable.get(i)._bold == 0 && tabsTable.get(i)._col == collumn){
                       tabsTable.setProperty(i,"_text",subject[k])
                       k++;
                   }
                   if(tabsTable.get(i)._bold == 0 && tabsTable.get(i)._col > collumn)
                       break;
                }
            }
        }
    }


    function saveTable(){
        var omgod = []
        for(var i = 0; i < tabsTable.count; i++ ){
            var text = tabsTable.get(i)._text + "-" + tabsTable.get(i)._spanWidth + "-" + tabsTable.get(i)._spanHeight
                    + "-" + tabsTable.get(i)._bold + "-" + tabsTable.get(i)._row + "-" + tabsTable.get(i)._col + "-" + tabsTable.get(i)._teacher

            omgod.push(text)
        }
        return omgod
    }
    function changeTeacherinTableItem(text){
        if(indexFocus !== -1){
            var a = tabsTable.get(indexFocus)._teacher
            if(a === "Нет преподавателя"){
                distributeTeachers(tabsTable.get(indexFocus)._text, text, 0, 2)
            }
            tabsTable.setProperty(indexFocus, "_teacher", text)
        }
    }
    function setScrollUp(){
        scroll.scrollTo(Qt.Vertical, 0)
    }
    function paste(row, col, subject, teacher){
        for(var i = 0; i < tabsTable.count; i++)
            if(tabsTable.get(i)._col === col && tabsTable.get(i)._row === row){
                tabsTable.setProperty(i,"_text", subject)
            }
    }

    function distributeTeachers(subject, teacher, isPlatoon, col){
        if(isPlatoon === 1){

            for(var i = 0; i < tabsTable.count; i++)
                if(tabsTable.get(i)._col === col && tabsTable.get(i)._text === subject)
                    tabsTable.setProperty(i,"_teacher", teacher)
        }else
            for(i = 0; i < tabsTable.count; i++)
                if(tabsTable.get(i)._text === subject)
                    tabsTable.setProperty(i,"_teacher", teacher)
    }
    PauseAnimation {
        id: dropAnim
        duration: 400
        onStopped: {
            canDrop = true
        }
    }


    ListModel{
        id: tabsTable
    }

    ScrollView2{
        id: scroll
        anchors.fill: parent
        property int movingX : x
        property int movingY : y

        background: Text {
            id: nameanch
            anchors.centerIn: parent
            text: tabsTable.count != 0 ? "" : qsTr("Тут пусто(((( Добавьте таблицу")
            color: "grey"
            font.pointSize: 20
            font.family: "Poiret One"
        }


        GridLayout{
            enabled: !isLoading
            id: grid
            anchors.fill: parent
            columns: 6
            rowSpacing: 0
            columnSpacing: 0
            opacity: isLoading? 0.5 : 1

            Component.onCompleted: {
                dropID == -1
            }

            Repeater{
                id: hello
                model:tabsTable
                delegate: Rectangle{
                    id: tableItem
                    property int itemX
                    property int itemY

                    property bool dragged: false
                    property bool itemCanDrop: canDrop
                    property int absoluteX : scroll.movingX
                    property int absoluteY : scroll.movingY

                    property string teacherName: _teacher
                    property string hoveredTeacher: secondPage.hoveredTeacher
                    property bool isLightedRow: false

                    onHoveredTeacherChanged: {
                        if(_col === 1 && lightedRows.indexOf(_row) !== -1 && hoveredTeacher != "Нет преподавателя")
                            isLightedRow = true
                        else
                            isLightedRow = false
                    }

                    onTeacherNameChanged: {
                        if(!isLoading)
                            tableMixerClass.makeUpWarnings([].concat(secondTab1.makeTimeTable(_row),
                                                                     secondTab2.makeTimeTable(_row),
                                                                     secondTab3.makeTimeTable(_row)), _row);
                    }

                    Layout.columnSpan: _spanWidth
                    Layout.rowSpan: _spanHeight
                    implicitWidth: ~~((grid.width - 2) / grid.columns * _spanWidth) + 1
                    implicitHeight: ~~(implicitWidth / 4 * _spanHeight)
                    color: inputText.cursorVisible? blue.color :
                           inputText.text == focusedName || tableItemMouse.containsMouse || isLightedRow?
                           leftPan.color : mainpage.color
                    border.color: leftPan.color//blue.color
                    border.width: 1
                    Layout.row: _row
                    Layout.column: _col
                    NumberAnimation {
                        id: scaleAnim
                        target: tableItem
                        property: "scale"
                        to: draggedID === _id? canDrop? 0.8 : 0.9 : 1
                        duration: 100
                    }

                    onItemCanDropChanged: {
                        scaleAnim.restart()
                    }

                    onXChanged: {
                        scroll.movingX = x + tableItemMouse.mouseX
                    }
                    onYChanged: {
                        scroll.movingY = y + tableItemMouse.mouseY
                    }

                    onAbsoluteXChanged: {
                        if(scroll.movingX > this.x && scroll.movingX < this.x + this.implicitWidth
                        && scroll.movingY > y && scroll.movingY < this.y + this.implicitHeight){
                            if(_id !== draggedID)
                                dropID  = _id
                        }else if(_id === dropID)
                            dropID = draggedID
                    }
                    onAbsoluteYChanged: {
                        if(scroll.movingX > this.x && scroll.movingX < this.x + this.implicitWidth
                        && scroll.movingY > y && scroll.movingY < this.y + this.implicitHeight){
                            if(_id !== draggedID)
                                dropID  = _id
                        }else if(_id === dropID)
                            dropID = draggedID
                    }

                    NumberAnimation {
                        id: xAnim
                        targets: tableItem
                        properties: "x"
                        to: tableItem.itemX
                        duration: 200
                        onStopped: {
                            canDrop = false
                            dropID = -1
                            draggedID = -1
                        }
                    }
                    NumberAnimation {
                        id: yAnim
                        targets: tableItem
                        properties: "y"
                        to: tableItem.itemY
                        duration: 200
                        onStopped: {
                            canDrop = false
                            dropID = -1
                            draggedID = -1
                        }
                    }
                    Rectangle {
                        id: warningImage
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter

                        Connections{
                            target: tableMixerClass
                            function onSetWarning(comp, platoon, lesson, isWarning){
                                if(comp === 1 && platoon === _col && lesson === _row)
                                    warningImage.visible = isWarning
                            }
                        }

                        visible: false
                        opacity: 0.3
                        height: 10
                        width: height
                        radius: width/2
                        color: "yellow"
                    }

                    MouseArea{
                        id: tableItemMouse
                        hoverEnabled: true
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked:{
                             if(mouse.button & Qt.RightButton && _bold == 0) {
                                 contextMenu.openq(_col, _row, 2, _teacher, _text)
                             }
                        }
                        onPressed: {
                            canDrop = false
                            dropID = -1
                            draggedID = -1
                            if(!xAnim.running && !yAnim.running){
                            tableItem.itemX = tableItem.x
                            tableItem.itemY = tableItem.y

                            }
                            tableItem.z = 1
                            inputText.forceActiveFocus();
                            inputText.cursorPosition = mouseX > width / 2? _text.length : 0
                        }
                        onContainsMouseChanged: {
                            focusedName = containsMouse && _text != ""? _text : "-1"
                            if(containsMouse && !_bold && _teacher != "Нет преподавателя")
                                secondPage.hoveredTeacher = _teacher
                            else
                                secondPage.hoveredTeacher = "-1"
                        }

                        drag{
                            target: tableItem
                            onActiveChanged: {
                                draggedID = _id
                            }
                        }
                        PauseAnimation {
                            id: pause
                            duration: 200
                            onStopped: tableItem.z = 0
                        }

                        onReleased:{
                            pause.restart()
                            if(canDrop)
                                if(tabsTable.get(draggedID)._col === tabsTable.get(dropID)._col){
                                    var _textDrag    = tabsTable.get(draggedID)._text.length == 0? " " : tabsTable.get(draggedID)._text
                                    var _teacherDrag = tabsTable.get(draggedID)._teacher.length == 0? " " : tabsTable.get(draggedID)._teacher

                                    var _textDrop    = tabsTable.get(dropID)._text.length == 0? " " : tabsTable.get(dropID)._text
                                    var _teacherDrop = tabsTable.get(dropID)._teacher.length == 0? " " : tabsTable.get(dropID)._teacher

                                    tabsTable.setProperty(draggedID, "_text", _textDrop)
                                    tabsTable.setProperty(draggedID, "_teacher", _teacherDrop)

                                    tabsTable.setProperty(dropID, "_text", _textDrag)
                                    tabsTable.setProperty(dropID, "_teacher", _teacherDrag)
                                    changeIndex(_teacher)
                                }else{
                                    messageBox.showMessage("Внимание!","Нельзя менять предметы разных взводов")
                                }

                            xAnim.start()
                            yAnim.start()
                            dropID = -1
                            draggedID = -1
                            canDrop = false

                        }
                        TextEdit {

                            id: inputText
                            focus: needToFocus && _id === 0? true : false
                            width:  contentWidth > 0? contentWidth : 40
                            height: contentHeight
                            anchors.centerIn: parent


                            text: _text

                            selectByMouse: true
                            selectionColor: blue.color
                            selectedTextColor: mainpage.color
                            font.family:"HelveticaNeueCyr"
                            font.pointSize: 14
                            color: "white"
                            font.styleName:_bold? "Light" : "Thin"


                            onTextChanged: {
                                if(!window.isTeacherMode)
                                tabsTable.set(_id,{
                                              _id: _id,
                                              _text: text,
                                              _spanWidth: _spanWidth,
                                              _spanHeight: _spanHeight,
                                              _bold: _bold,
                                              _row: _row,
                                              _col: _col
                                              })
                            }

                            onCursorVisibleChanged: {
                                if(cursorVisible){
                                    _teacher.replace('\r', '')
                                    changeIndex(_teacher)
                                    indexFocus = _id
                                }
                            }
                        }
                    }
                }
            }
        }
        ContextMenu {
            id: contextMenu
            visible: false
        }
        SecondContextMenu{
            id: contextMenu2
            visible: false
        }
        ThirdContextMenu{
            id: contextMenu3
        }
    }
}
