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
    id: cabinetsPage
    signal unMark()
    signal unMarkSubjInfoLine()

    property int currentIndex: -1

    onCurrentIndexChanged: {
        cabinetsConfigInfo.clear()
    }
    Row{
        anchors.top: parent.top
        anchors.right: parent.right
        spacing: viewSwitch.width / 3
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "По кабинетам"
            font.family: poiret.font
            font.pointSize: 14
            color: textColor
        }
        MySwitch{
            id: viewSwitch
            anchors.verticalCenter: parent.verticalCenter
            checked: false
            reversedColor: true
            function posChanged(){
                currentIndex = -1
                unMark()
                cabinetsConfigList.clear()
                cabinetsConfigInfo.clear()
                slideAnimReversed.start()
                slideAnim2Reversed.start()
                cabinetSettingsClass.changeView(viewSwitch.checked)
            }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "По профилям"
            font.family: poiret.font
            font.pointSize: 14
            color: textColor
        }
    }

    function delLine(index){
        cabinetSettingsClass.delSetting(viewSwitch.checked, cabinetsConfigList.get(index)._name)
        cabinetsConfigList.remove(index)
        if(currentIndex === index){
            slideAnim2Reversed.start()
            slideAnimReversed.start()
            currentIndex = -1
        }
    }
    function delProfileLine(index){
        cabinetsConfigInfo.remove(index)
    }

    function dataChanged(){
        var name = cabinetsConfigList.get(currentIndex)._name
        var dataArr = []
        for(var i = 0; i < cabinetsConfigInfo.count; i++){
            dataArr.push(cabinetsConfigInfo.get(i)._text)
        }
        cabinetSettingsClass.updateData(viewSwitch.checked, name, dataArr)
    }

    color: mainpage.color

    ListModel{
        id: cabinetsConfigInfo

    }
    Connections{
        target: cabinetSettingsClass
        function onSetDataList(data){
            cabinetsConfigInfo.append({"_text": data})
        }
    }

    Text {
        id: title
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "Кабинеты"
        font.family: poiret.font
        font.pointSize: 40
        color: textColor
    }

    ListView{
        id: list2
        anchors.top: title.bottom
        anchors.topMargin: title.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: cabinetsPage.width/4
        ScrollBar.vertical: MyScrollBar{}

        width: cabinetsPage.width / 3 + 12
        anchors.bottom: parent.bottom
        model: cabinetsConfigInfo
        spacing: 5
        opacity: 0

        clip: true

        delegate: TeacherProfileInput{
            id: listComponent2

            property int indexOfThisDelegate: index
            width: cabinetsPage.width/3
            height: width/8
            subjName: _text
            function onTextChanged(newName){cabinetsConfigInfo.setProperty(indexOfThisDelegate, "_text", newName); dataChanged()}
            function  onHoverChanged(containsMouse){ unMarkSubjInfoLine(); slideAnimCan.start(containsMouse)}
            function onDel(){delProfileLine(indexOfThisDelegate); dataChanged()}

            Connections{
                target: cabinetsPage
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
            width: cabinetsPage.width/3
            height: width / 8 + width / 16
            color: "transparent"
                MyButton{
                    id: addButton2
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    width: cabinetsPage.width/3
                    height: width / 8
                    buttonText: "Добавить"
                    function onButtonClicked(){
                        var recText = viewSwitch.checked? "Кабинет" : "Предмет"
                        var it = 1;
                        var name = recText + " " + it;
                        while(hasState(name)){
                            it++;
                            name = recText + " " + it;
                        }
                        cabinetsConfigInfo.insert(0, {"_text": name})
                        dataChanged()
                    }
                    function hasState(name){
                        for(var i = 0; i < cabinetsConfigInfo.count; i++)
                            if(cabinetsConfigInfo.get(i)._text === name)
                                return true
                        return false
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
            to: 0
            duration: 200

            onStarted: NumberAnimation{
                target: list2
                property: "scale"
                to: 0
                duration: 200
            }
        }
    }

    ListView{
        id: list
        ScrollBar.vertical: MyScrollBar{}

        model: cabinetsConfigList
        anchors.top: title.bottom
        anchors.topMargin: title.height
        anchors.horizontalCenter: parent.horizontalCenter

        width: cabinetsPage.width/3 + cabinetsPage.width/35
        anchors.bottomMargin: 5
        anchors.bottom: parent.bottom
        spacing: 5

        clip: true

        header: Rectangle{
            z:2
            anchors.horizontalCenter: parent.horizontalCenter
            width: cabinetsPage.width/3
            height: width / 8 + width / 16
            color: "transparent"
            MyButton{
                id: addButton
                anchors.top: parent.top
                anchors.topMargin: 0
                width: cabinetsPage.width/3
                height: width / 8
                buttonText: "Добавить"

                function onButtonClicked(){
                    cabinetSettingsClass.addSetting(viewSwitch.checked)
                }
            }
        }

        delegate: MyButton{
            id: listComponent
            property int indexOfThisDelegate: index
            anchors.horizontalCenter: parent.horizontalCenter
            width: cabinetsPage.width/3
            height: width/8
            buttonText: _name
            clip: true
            onIsHoveredChanged: {subjectPackCanAnim.start(isHovered)}
            function onButtonPressedAndHold(){ readOnly = false}

            function onTextChanged(){
                if(cabinetSettingsClass.renameData(viewSwitch.checked, cabinetsConfigList.get(indexOfThisDelegate)._name, buttonText))
                    cabinetsConfigList.setProperty(indexOfThisDelegate, "_name", buttonText)
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
                cabinetsConfigInfo.clear()
                cabinetSettingsClass.showProfileSubjects(viewSwitch.checked, buttonText)
                slideAnim.start()
                slideAnim2.start()
                unMark()
                listComponent.marked = true
            }
            Connections{
                target: cabinetsPage
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
            to: -cabinetsPage.width/4
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
