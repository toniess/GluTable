import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15

import QtQuick.Layouts 1.15

import QtQuick 2.9


Rectangle{

    id: configurationPage
    property string currentSubject: ""

    anchors.fill: parent
    color: mainpage.color
    clip: true

    signal unMark()
    signal unMarkSubjInfoLine()

    function subjectConfigInfoChanged(){
        var arr = ""
        for(var i = 0; i < subjectConfigInfo.count; i++){
            var item = subjectConfigInfo.get(i), enter = i === subjectConfigInfo.count - 1? '' : '\n'
            arr+=(item._subjName + "-" + item._subjInfo + enter)
        }
        subjectSettingsClass.saveSubjectSettings(currentSubject, arr)
    }
    function delSubjectPack(index){
        var subjName = subjectConfigList.get(index)._name
        subjectSettingsClass.deleteSubjectSet(subjName)
        if(currentSubject === subjName){
            slideAnim2Reversed.start()
            slideAnimReversed.start()
        }

        subjectConfigList.remove(index)
    }

    function setSwipeViewIndex(index, pageName){
        swipeView.currentIndex = index
        subjectList.currentPageName = pageName
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        id: title
        text: qsTr("Предметы")
        color: textColor
        font.family: helThin.font
        font.pointSize: 40
    }

    ListModel{
        id: subjectConfigInfo
    }

    Connections{
        target: subjectSettingsClass
        function onAddSubjectSetting(subjName, subjInfo){
            subjectConfigInfo.append({
                                     "_subjName": subjName,
                                     "_subjInfo": subjInfo
                                     })
        }
    }

    ListView{
        id: list2
        anchors.top: title.bottom
        anchors.topMargin: title.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: configurationPage.width/4
        ScrollBar.vertical: MyScrollBar{}

        width: configurationPage.width / 3 + 12
        anchors.bottom: parent.bottom
        model: subjectConfigInfo
        spacing: 5
        opacity: 0

        flickableDirection: Flickable.AutoFlickDirection

        clip: true

        delegate: ToolLine{
            id: listComponent2

            property int indexOfThisDelegate: index
            width: configurationPage.width/3
            height: width/8

            subjName: _subjName
            subjInfo: _subjInfo

            function  onHoverChanged(containsMouse){ unMarkSubjInfoLine(); slideAnimCan.start(containsMouse)}
            function onDel(){subjectConfigInfo.remove(indexOfThisDelegate); subjectConfigInfoChanged()}
            function onTextChanged(newName){
                subjectConfigInfo.setProperty(indexOfThisDelegate, "_subjName", newName)
                subjectConfigInfoChanged()
            }
            function onInfoChanged(newInfo){
                subjectConfigInfo.setProperty(indexOfThisDelegate, "_subjInfo", newInfo)
                subjectConfigInfoChanged()
            }
            Connections{
                target: configurationPage
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
            width: configurationPage.width/3
            height: width / 8 + width / 16
            color: "transparent"
                MyButton{
                    id: addButton2
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    width: configurationPage.width/3
                    height: width / 8
                    buttonText: "Добавить"
                    function onButtonClicked(){
                        subjectConfigInfo.insert(0,{
                                                 "_subjName": "Предмет",
                                                 "_subjInfo": 0
                                                 })
                        subjectInfoList.scrollTo(Qt.Vertical, -0.1)
                        subjectConfigInfoChanged()
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
                from: 0
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
                to: 0.8
                duration: 200
            }
        }
    }

        ListView{
            id: list
            ScrollBar.vertical: MyScrollBar{}

            model: subjectConfigList
            anchors.top: title.bottom
            anchors.topMargin: title.height
            anchors.horizontalCenter: parent.horizontalCenter

            width: configurationPage.width/3 + 12
            anchors.bottomMargin: 5
            anchors.bottom: parent.bottom
            spacing: 5


//            clip: true
            header: Rectangle{
                z:2
                width: configurationPage.width/3
                height: width / 8 + width / 16
                color: "transparent"
                    MyButton{
                        id: addButton
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        width: configurationPage.width/3
                        height: width / 8
                        buttonText: "Добавить"

                        function onButtonClicked(){
                            subjectSettingsClass.addNewSubjectSet()
                        }
                    }
            }


            delegate: MyButton{
                id: listComponent
                property int indexOfThisDelegate: index
                width: configurationPage.width/3
                height: width/8
                buttonText: modelData
                clip: true
                markColor: blue.color
                onIsHoveredChanged: {subjectPackCanAnim.start(isHovered)}
                function onButtonPressedAndHold(){ readOnly = false}
                function onTextChanged(){
                    if(subjectSettingsClass.renameSubjectSet(subjectConfigList.get(indexOfThisDelegate)._name, buttonText))
                        subjectConfigList.setProperty(indexOfThisDelegate, "_name", buttonText)
                    else
                        buttonText = subjectConfigList.get(indexOfThisDelegate)._name
                }
                Image {
                    id: subjectPackCan
                    anchors.left: parent.right
                    scale: parent.height / 75
                    anchors.verticalCenter: parent.verticalCenter
                    source: "./images/delete-red.svg"
                    MouseArea{anchors.fill: parent; onClicked: delSubjectPack(listComponent.indexOfThisDelegate)}
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
                    if(buttonText === currentSubject){
                        slideAnimReversed.start()
                        slideAnim2Reversed.start()
                        listComponent.marked = false
                        currentSubject = ""
                        return
                    }

                    subjectConfigInfo.clear()

                    subjectSettingsClass.showSubjects(buttonText)
                    slideAnim.start()
                    slideAnim2.start()
                    unMark()
                    currentSubject = modelData
                    listComponent.marked = true
//                    listComponent.color = blue.color
                }
                Connections{
                    target: configurationPage
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
                to: -configurationPage.width/4
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
