import QtQuick.Controls.Universal 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15
import QtQuick.Window 2.12
import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9
import QtQml 2.3

Rectangle{
    id: minipage

    color: mainColor//"#252c37"
    property int indexFocus: -1
    property string hoveredTeacher: ""
    property bool ctrlPressed: false
    property bool shiftPressed: false


    Keys.onPressed: { if (event.key === Qt.Key_Alt) ctrlPressed = true}
    Keys.onReleased: {if (event.key === Qt.Key_Alt) ctrlPressed = false}


    signal activeFocus

    function getDataForMixing(){
        var dataArr = []
        for(var i = 0; i < tabsTable.count; i++){
            var item = tabsTable.get(i)
            if(!item._bold){
                dataArr.push(item._text)
                dataArr.push(item._teacher)
                dataArr.push(item._row)
                dataArr.push(item._col)
            }
        }

        tableMixerClass.setCompanyData(tableId, dataArr)
    }


    function getDataForPrinter(){
        var dataArr = []
        for(var i = 0; i < tabsTable.count; i++){
            var item = tabsTable.get(i)
            if(!item._bold){
                dataArr.push(item._text)
                dataArr.push(item._teacher)
            }
        }
        printer.setData(dataArr)
    }

    Connections{
        target: homePageClass
        function onAddTableItem(tableIndex ,subject, widthSpan, heightSpan, isBold, row, collumn, teacherName){
            if(tableId === tableIndex){
                tabsTable.append({
                                 _text: subject.indexOf(undefined) !== -1? "" : subject,
                                 _spanWidth: widthSpan,
                                 _spanHeight: heightSpan,
                                 _bold: isBold,
                                 _row: row,
                                 _col: collumn,
                                 _teacher: teacherName
                                 })
            }
        }
    }

    Connections{
        target: window
        onNeedToSaveTable:{
            saveTable()
        }
    }

    Connections{
        target: tableMixerClass
        onSetTableItem: {
            if(tableId != table)
                return
            for(var i = 0;i < tabsTable.count; i++){
                if(tabsTable.get(i)._row == row && tabsTable.get(i)._col == col){
                    tabsTable.setProperty(i,"_text", subject == ""? " " : subject)
                    tabsTable.setProperty(i,"_teacher", teacher)
                    break;
                }
            }
            if(thatsAll){
                slidePanel.opened = false
                isLoading = false
            }
        }
    }

    Connections{
        target: subjectSettingsClass
        function onSetTableCollumn(table, collumn, subject){
            if(table === tableId){
                var k = 0;
                var shortList = false;
                if(subject.length < 36)
                    shortList = true
                for(var i = 0; i < tabsTable.count; i++){
                   if(tabsTable.get(i)._bold === 0 && tabsTable.get(i)._col === collumn){
                       if(shortList && k === 5){
                            shortList = false
                       }else{
                            tabsTable.setProperty(i,"_text",subject[k])
                            k++;
                       }
                   }
                   if(tabsTable.get(i)._bold === 0 && tabsTable.get(i)._col > collumn)
                       break;
                }
            }
        }
    }

    function saveTable(){
        var data = []
        for(var i = 0; i < tabsTable.count; i++ ){
            var subj = tabsTable.get(i)._text
            var text = subj + "-" + tabsTable.get(i)._spanWidth + "-" + tabsTable.get(i)._spanHeight
                    + "-" + tabsTable.get(i)._bold + "-" + tabsTable.get(i)._row + "-" + tabsTable.get(i)._col + "-" + tabsTable.get(i)._teacher
            data.push(text)
        }
        homePageClass.saveTable(tableId, data)
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

    function distributeTeachers(subject, teacher, isPlatoon, col){
            if(subject !== "" && subject !== undefined){
                if(isPlatoon === 1){
                    for(var i = 0; i < tabsTable.count; i++)
                        if(tabsTable.get(i)._col === col && tabsTable.get(i)._text === subject)
                            tabsTable.setProperty(i,"_teacher", teacher)
                }else{
                for(i = 0; i < tabsTable.count; i++)
                        if(tabsTable.get(i)._text === subject)
                            tabsTable.setProperty(i,"_teacher", teacher)
                }
            }
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
        anchors.fill: parent
        id: scroll
        property int movingX : x
        property int movingY : y
        function scrolled(){scroll.smooth = 1}
        GridLayout{
            id: grid
            enabled: !(isLoading || isPanelOpened)
            anchors.fill: parent
            columns: 6
            rowSpacing: 0
            columnSpacing: 0
            height: contentHeight
            opacity: isLoading || isPanelOpened? 0.5 : 1

            Repeater{
                model:tabsTable

                delegate: Rectangle{
                    id: tableItem
                    property int _id: index
                    property bool thisTeacherIsHovered: hoveredTeacher === _teacher
                    property bool dragged: false
                    property int aimX
                    property int aimY

                    Layout.columnSpan: _spanWidth
                    Layout.rowSpan: _spanHeight
                    implicitWidth: ~~((grid.width - 2) / grid.columns * _spanWidth) + 1
                    implicitHeight: ~~(implicitWidth / 4 * _spanHeight)
                    color: inputText.cursorVisible || indexFocus == _id? blue.color:
                        tableItemMouse.containsMouse || (thisTeacherIsHovered && !_bold)?
                                leftPan.color : mainpage.color

                    border.color: leftPan.color
                    border.width: 1
                    Layout.row: _row
                    Layout.column: _col
                    radius: 2
                    NumberAnimation {
                        id: makeSwapAnim
                        target: tableItem
                        property: "x"
                        to: tableItem.aimX
                        duration: 150
                        onStarted: NumberAnimation {
                            target: tableItem
                            property: "y"
                            to: tableItem.aimY
                            duration: 150
                            onStopped: tableItem.z = 0
                        }
                    }

                    MouseArea {
                        id: tableItemMouse
                        enabled: !slidePanel.opened
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        drag{
                            target: parent
                            onActiveChanged: {
                                dragged = !dragged
                                if(dragged){
                                    tableItem.aimX = tableItem.x
                                    tableItem.aimY = tableItem.y
                                  inputText.forceActiveFocus()
                                    tableItem.z = 1

                                }else{
                                    makeSwapAnim.start()
                                }
                            }
                        }


                        onReleased: {
                            indexFocus = index
                            if(mouse.button & Qt.RightButton){
                                contextMenu.openq(_col, _row, tableId, _teacher, _text)
                            }

                            inputText.forceActiveFocus()
                        }

                        onContainsMouseChanged: {if(containsMouse && _teacher !== "Нет преподавателя") hoveredTeacher = _teacher
                        if(_teacher == "Нет преподавателя") hoveredTeacher = ""}


                        MyTextInput {
                            id: inputText
                            width:  contentWidth
                            height: contentHeight
                            font.family:helThin.font
                            font.pointSize: 14
                            text: ctrlPressed && !_bold? _teacher : _text
                            readOnly: ctrlPressed
                            selectByMouse: true
                            selectionColor: secColor
                            selectedTextColor: textColor

                            Connections{
                                target: minipage
                                function onActiveFocus(){if(index === indexFocus) inputText.forceActiveFocus()}
                            }

                            color: textColor
                            font.styleName: _bold || tableItem.color == blue.color? "Light" : "Thin"

                            onFocusChanged: {
                                if(focus){
                                    indexFocus = index
                                    currentItemText = _text
                                }
                                else if(indexFocus === index){
                                    indexFocus = -1
                                    currentItemText = ""
                                }
                            }

                            onTextChanged: {
                                if(!window.isTeacherMode && !ctrlPressed)
                                    tabsTable.set(_id,{
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
            visible: false
        }
    }

}
