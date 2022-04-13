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
    id: teachersPage
    signal unMark()
    signal unMarkSubjInfoLine()

    property int currentIndex: -1
    property var pro: []

    onCurrentIndexChanged: {
        teacherConfigInfo.clear()
    }

    function delLine(index){
        teacherSettingsClass.delTeacher(teacherModel.get(index)._name)
        teacherModel.remove(index)
    }
    function delProfileLine(index){
        teacherConfigInfo.remove(index)
    }

    function dataChanged(){
        var arr = ""
        for(var i = 0; i < teacherConfigInfo.count; i++){
            arr+=teacherConfigInfo.get(i)._text + (i == teacherConfigInfo.count - 1? "" : '\n')
        }
        teacherSettingsClass.saveTeacherProfile(teacherModel.get(currentIndex)._name, arr)
    }

    color: mainpage.color

    ListModel{
        id: teacherConfigInfo

    }
    Connections{
        target: teacherSettingsClass
        function onAddTeacherProfileLine(subject){teacherConfigInfo.append({"_text": "" + subject})}
    }

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "Преподаватели"
        font.family: helThin.font
        font.pointSize: 40
        color: textColor
    }

    ListView{
        id: list2
        anchors.top: title.bottom
        anchors.topMargin: title.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: teachersPage.width/4
        ScrollBar.vertical: MyScrollBar{}

        width: teachersPage.width / 3 + 12
        anchors.bottom: parent.bottom
        model: teacherConfigInfo
        spacing: 5
        opacity: 0

        clip: true

        delegate: TeacherProfileInput{
            id: listComponent2

            property int indexOfThisDelegate: index
            width: teachersPage.width/3
            height: width/8
            subjName: _text
            function onTextChanged(newName){teacherConfigInfo.setProperty(indexOfThisDelegate, "_text", newName); dataChanged()}
            function  onHoverChanged(containsMouse){ unMarkSubjInfoLine(); slideAnimCan.start(containsMouse)}
            function onDel(){delProfileLine(indexOfThisDelegate); dataChanged()}

            Connections{
                target: teachersPage
                function onUnMarkSubjInfoLine(){
                    slideAnimCan.start(false)
                }
            }

            NumberAnimation {
                id: slideAnimCan
                property int aim: 0
                target: listComponent2
                property: "slideCan"
                to: aim
                duration: 200
                alwaysRunToEnd: false
                function start(isTrue){
                    running = false
                    aim = isTrue? 40 : 0
                    if(isTrue)
                        pause.start()
                    else
                        running = true
                }
            }
            PauseAnimation {
                id: pause
                duration: 0//500
                onStopped: {slideAnimCan.running = true}
            }
        }

        header: Rectangle{
            z:2
            width: teachersPage.width/3
            height: width / 8 + width / 16
            color: "transparent"
                MyButton{
                    id: addButton2
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    width: teachersPage.width/3
                    height: width / 8
                    buttonText: "Добавить"
                    function onButtonClicked(){
                        teacherConfigInfo.insert(0,{"_text": "Предмет"})
                        dataChanged()
                    }
                }
        }
        NumberAnimation{
            id: slideAnim2
            target: list2
            property: "opacity"
            from: 0
            to: 1
            duration: 200

            onStarted: NumberAnimation{
                target: list2
                property: "scale"
                from: slideAnim2.from
                to: slideAnim2.to
                duration: 200
            }
        }
        NumberAnimation{
            id: slideAnim2Reversed
            target: list2
            property: "opacity"
            from: 1
            to: 0
            duration: 200

            onStarted: NumberAnimation{
                target: list2
                property: "scale"
                from: 1
                to: 0
                duration: 200
            }
        }
    }

    ListView{
        id: list
        ScrollBar.vertical: MyScrollBar{}

        model: teacherModel
        anchors.top: title.bottom
        anchors.topMargin: title.height
        anchors.horizontalCenter: parent.horizontalCenter

        width: teachersPage.width/3 + teachersPage.width/35
        anchors.bottomMargin: 5
        anchors.bottom: parent.bottom
        spacing: 5

        clip: true

        header: Rectangle{
            z:2
            anchors.horizontalCenter: parent.horizontalCenter
            width: teachersPage.width/3
            height: width / 8 + width / 16
            color: "transparent"
                MyButton{
                    id: addButton
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    width: teachersPage.width/3
                    height: width / 8
                    buttonText: "Добавить"

                    function onButtonClicked(){
                        teacherSettingsClass.addTeacher()
                    }
                }
        }

        delegate: MyButton{
            id: listComponent
            property int indexOfThisDelegate: index
            anchors.horizontalCenter: parent.horizontalCenter
            width: teachersPage.width/3
            height: width/8
            buttonText: _name
            clip: true
            onIsHoveredChanged: {subjectPackCanAnim.start(isHovered)}
            function onButtonPressedAndHold(){ readOnly = false}

            function onTextChanged(){
                if(teacherSettingsClass.renameTeacher(teacherModel.get(indexOfThisDelegate)._name, buttonText))
                    teacherModel.setProperty(indexOfThisDelegate, "_name", buttonText)
            }

            Image {
                id: subjectPackCan
                anchors.left: parent.right
                scale: parent.height / 75
                anchors.verticalCenter: parent.verticalCenter
                source: "./images/delete-red.svg"
                MouseArea{anchors.fill: parent; onClicked: delLine(listComponent.indexOfThisDelegate)}
                NumberAnimation {
                    id: subjectPackCanAnim
                    property bool aim: true
                    target: subjectPackCan
                    property: "anchors.leftMargin"
                    to: aim? -45 : 0
                    duration: 150
                    alwaysRunToEnd: false
                    function start(isTrue){
                        running = false
                        aim = isTrue
                        running = true
                    }
                }
                NumberAnimation {
                    target: listComponent
                    property: "scale"
                    to: subjectPackCanAnim.aim? 1.05 : 1
                    duration: 200
                    alwaysRunToEnd: false
                    running: subjectPackCanAnim.running
                }
            }

            function onButtonClicked(){
                if(index === currentIndex){
                    slideAnimReversed.start()
                    slideAnim2Reversed.start()
                    listComponent.marked = false
                    currentIndex = -1
                    return
                }
                currentIndex = indexOfThisDelegate
                teacherConfigInfo.clear()
                teacherSettingsClass.showTeacherProfile(buttonText)
                slideAnim.start()
                slideAnim2.start()
                unMark()
                listComponent.marked = true
            }
            Connections{
                target: teachersPage
                function onUnMark(){
                    listComponent.marked = false
                    listComponent.readOnly = true
                }
            }
        }

        NumberAnimation{
            id: slideAnim
            target: list
            property: "anchors.horizontalCenterOffset"
            to: -teachersPage.width/4
            duration: 200
        }
        NumberAnimation{
            id: slideAnimReversed
            target: list
            property: "anchors.horizontalCenterOffset"
            to: 0
            duration: 200
        }
    }
}
