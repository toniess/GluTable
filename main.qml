import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtQuick.Controls 1.1
import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

import QtQuick.Window 2.2

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    property bool dayTheme: themeSwitch.checked
    property color mainColor
    property color secColor  /*"#c9afad"*/
    property color textColor

    Component.onCompleted: {
        mainColor = dayTheme? "#eddbda" : "#252c37"
        secColor  = dayTheme? "#ccbaba"/*"#c4b3b3"*/ : "#343d4d"/*"#2d3543"*/  /*"#c9afad"*/
        textColor = dayTheme? "black"   : "white"
    }

    onDayThemeChanged: {
        mainColorThemeAnim.start()
        secColorThemeAnim.start()
        textColorThemeAnim.start()
    }

    ColorAnimation on mainColor{
        id: mainColorThemeAnim
        to: !dayTheme? "#eddbda" : "#252c37"
        duration: 200
        running: false
    }
    ColorAnimation on secColor{
        id: secColorThemeAnim
        to: !dayTheme? "#c4b3b3" : "#2d3543"
        duration: 200
        running: false
    }
    ColorAnimation on textColor{
        id: textColorThemeAnim
        to: !dayTheme? "black"   : "white"
        duration: 200
        running: false
    }

    function setText(text){
        messageBoxModel.append({"_messageText": text})
    }
    function videoPlay(isPlaying){
        isVideoPlaying = isPlaying
    }
    function delListElements(){
        secondPage.delListElements()
    }
    function addListElement(text){
        secondPage.addListElement(text)
    }
    function changeIndex(text){
        secondPage.changeIndex(text)
    }
    function changeTeacherinTableItem(text){
        secondPage.changeTeacherinTableItem(text)
    }
    function quitRequire(){
        appearQuit.start()
    }
    function delHomeConfigModel(){
        homePage.delHomeConfigModel()
    }
    function addHomeConfigModelLine(text){
        homePage.addHomeConfigModelLine(text)
    }

    signal needToSaveTable()
    property bool isVideoPlaying: false
    property bool isTeacherMode: false

    Connections{
        target: homePageClass
        onOpenEditPage:{
            listView.currentIndex = 1
            swipeView.currentIndex = 1
        }
    }

    onWidthChanged: selectRecAnim.start(listView.currentIndex)
    onHeightChanged: selectRecAnim.start(listView.currentIndex)

    id: window
    objectName: "window1"
    visible: true
    title: qsTr("GluTable")

    width: Screen.width / 1.31
    height: Screen.height / 1.31

    x: Screen.width / 2 - width / 2
    y: Screen.height / 2 - height / 2

    flags: Qt.FramelessWindowHint | Qt.Window

    color: window.width === Screen.width? mainpage.color : "transparent"

//    FontLoader{ id: helUlLight; source: "qrc:/fonts/helveticaneuecyr-ultralight.ttf"}
//    FontLoader{ id: helThin; source: "qrc:/fonts/Mulish-Light.ttf"}
//    FontLoader{ id: helLight; source: "qrc:/fonts/helveticaneuecyr-light.ttf"}

    FontLoader{ id: helThin; source: "qrc:/fonts/Mulish-Light.ttf"}
//    FontLoader{ id: poiret; source: "qrc:/fonts/Mulish-ExtraLight.ttf"}

//    FontLoader{ id: helThin; source: "qrc:/fonts/helveticaneuecyr-thin.ttf"; }
    FontLoader{ id: poiret; source: "qrc:/fonts/Mulish-Light.ttf"}
    FontLoader{ id: homePageGridFont; source: "qrc:/fonts/helveticaneuecyr-thin.ttf"}

    Rectangle{
        id: mainpage
        anchors.fill: parent
        color: mainColor
        radius: 10
        clip: true

        Rectangle{
            id:leftPan
            anchors.margins: parent.left-20
            color: secColor
            width: window.width / 6.76
            height: parent.height
            radius: 10
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    disAppearQuit.start()
                }
            }

            MessageBox{
                id: messageBox
                anchors.top: listView.top
                anchors.topMargin: listView.contentHeight
                x: -200
            }

            Rectangle{
                id: helpPan
                anchors.right: parent.right
                color: "#252c37"
                width: parent.radius
                height: parent.height
            }
            Rectangle{
                id: lineUnderText
                width: parent.width - parent.radius
                height: 1
                color: "grey"
                y: window.height / 12
            }
            Text {
                id: gluTable
                anchors.horizontalCenter: parent.horizontalCenter
                y: window.height / 35
                text: qsTr("GluTable")
                color: textColor
                font.family: poiret.font
                font.letterSpacing: window.width / 250
                font.pointSize:     window.width / 58
            }
            ListModel{
                id: listModel
                ListElement{
                    _id: 0
                    isClcked: 0
                    source:  "./images/homePage.svg"
                    sourceF: "./images/homePage-F.svg"
                    text: qsTr("Главная")
                }
                ListElement{
                    _id: 1
                    isClicked: 0
                    source:  "./images/filePage.svg"
                    sourceF: "./images/filePage-F.svg"
                    text: qsTr("Редактор")
                }
                ListElement{
                    _id: 2
                    isClicked: 0
                    source:  "./images/settings.svg"
                    sourceF: "./images/settings-F.svg"
                    text: qsTr("Настройки")
                }
                ListElement{
                    _id: 3
                    source:  "./images/infoPage.svg"
                    sourceF: "./images/infoPage-F.svg"
                    text: qsTr("О нас")
                }
            }
            Rectangle{
                id:blue
                color: "#839ff2"//"#3498DB"
                width: 0
                height: 0
            }
            Rectangle{
                id: selectRec
                anchors.top: listView.top
                anchors.left: parent.left
                anchors.leftMargin: 5
                width: parent.width - mainpage.radius - 10
                height: window.height / 12.5
                color: mainpage.color
                radius: height / 5

                NumberAnimation {
                    id: selectRecAnim
                    target: selectRec
                    property int aim: 0
                    property: "anchors.topMargin"
                    to: aim
                    duration: 200
                    alwaysRunToEnd: false
                    function start(index){
                        running = false
                        aim = window.height / 12.5 * index
                        running = true
                    }
                    onStarted:
                        NumberAnimation {
                        target: selectRec
                        property: "height"
                        to: window.height / 12.5 * 1.4
                        duration: 100
                        onStopped: NumberAnimation {
                            target: selectRec
                            property: "height"
                            to: window.height / 12.5
                            duration: 100
                        }
                    }
                }
            }
            ListView{
                id: listView
                anchors.top: lineUnderText.bottom
                anchors.topMargin: window.width / 200
                width: parent.width
//                anchors.bottom: parent.bottom
                height: contentHeight
                anchors.left: parent.left
                interactive: false
                onCurrentIndexChanged: selectRecAnim.start(currentIndex)
                model: listModel

                delegate: Rectangle{
                    property int i: index
                    property bool isHovered: false
                    id: list
                    width: parent.width - mainpage.radius
                    height: window.height / 12.5

                    color: "transparent"
                    function delay(delayTime) {
                        timer = new Timer();
                        timer.interval = delayTime;
                        timer.repeat = false;
                        timer.start();
                    }

                    Timer {
                            id: timer
                        }

                    MouseArea {
                        id: listMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onContainsMouseChanged: isHovered = containsMouse? true : false
                        onClicked: {
                            if(i == listView.currentIndex && i == 2)
                                settingsPage.setIndex(0)
                            function delay(delayTime, cb) {
                                timer.interval = delayTime;
                                timer.repeat = false;
                                timer.triggered.connect(cb);
                                timer.start();
                            }
                            if(!isVideoPlaying){
                                            swipeView.currentIndex = i
                                listView.currentIndex = i
                                list.opacity = 1
                            }
                        }
                        onEntered: {
                            list.opacity = listView.currentIndex == i ? 1 : 0.7
                        }
                        onExited: {
                            list.opacity = 1
                        }
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        id: text
                        x: window.width / 21
                        color: textColor
                        font.family: helThin.font
                        font.pointSize: window.width / 64
                        font.styleName: "Thin"
                        text: model.text
                    }
                    Image {
                        id: ima
                        x: window.width / -57
                        anchors.verticalCenter: text.verticalCenter
                        source: listView.currentIndex == _id || isHovered? model.sourceF : model.source

                        scale: window.width / 3666
                    }
                }
            }
            Rectangle{
                property int value: 25
                opacity: 0
                id: progressBar
                height: 5
                color: mainpage.color
                radius: 3
                anchors.top: listView.top
                anchors.topMargin: listView.contentHeight * 1.1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -5
                width: parent.width * 0.7
                Rectangle{
                    height: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width * parent.value / 100
                    color: blue.color
                    radius: parent.radius
                }
            }
            NumberAnimation {
                id: progressAnim
                target: progressBar
                property: "value"
                duration: 30500
                from: 0
                to: 100
                onStarted: NumberAnimation {
                    target: progressBar
                    property: "opacity"
                    duration: 100
                    from: 0
                    to: 1
                }
                onStopped: NumberAnimation {
                    target: progressBar
                    property: "value"
                    duration: 70
                    to: 0

                    onStopped: NumberAnimation {
                        target: progressBar
                        property: "opacity"
                        duration: 50
                        from: 1
                        to: 0
                    }
                }
            }

            Rectangle{
                id: quitRequire
                opacity: 0
                width: window.width / 8.5
                height: window.height / 9.8
                color: mainpage.color
                radius: height / 7
                anchors.bottom: logoutButton.top
                anchors.horizontalCenter: leftPan.horizontalCenter
                anchors.horizontalCenterOffset: -mainpage.radius/2
//                onFocusChanged:{console.log("focus: ", focus)} /*if(!focus) disAppearQuit.start()*/
                Text {
                    id: sureText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: parent.radius
                    color: textColor
                    font.family: helThin.font
                    font.pointSize: window.width / 68.75
                    font.styleName: "Light"
                    text: "Точно?"
                }
                Rectangle{
                    width: window.width / 9.16
                    height: width / 4
                    anchors.top: sureText.bottom
                    anchors.topMargin: height / 6
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: height / 5
                    color: "transparent"
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: textColor
                        font.family: helThin.font
                        font.styleName: "Thin"
                        font.pointSize: window.width / 73.3
                        text: "Выйти"
                    }
                    MouseArea{
                        enabled: quitRequire.opacity > 0
                        anchors.fill: parent
                        onClicked:{
                            needToSaveTable()
                            Qt.quit()
                        }
                    }
                    HoverHandler{
                        onHoveredChanged: parent.color = hovered? leftPan.color : "transparent"
                    }
                }

                NumberAnimation {
                    id: appearQuit
                    target: quitRequire
                    property: "opacity"
                    to: 1
                    duration: 200
                    onStopped: {quitRequire.focus = true}
                }
                NumberAnimation {
                    id: disAppearQuit
                    target: quitRequire
                    property: "opacity"
                    to: 0
                    duration: 200
                }
            }



            MySwitch {
                id: themeSwitch
                anchors.bottom: quitRequire.top
                anchors.bottomMargin: themeSwitch.height
                anchors.horizontalCenter: parent.horizontalCenter
                function posChanged(){
                    mainSettingsClass.saveThemeSetting(checked? "DAY" : "NIGHT")
                }
                Connections{
                    target: mainSettingsClass
                    function onSetColorTheme(isDayTheme){
                        themeSwitch.checked = isDayTheme
                    }
                }
            }


            LogoutButton{
                id: logoutButton
                anchors.bottom: parent.bottom
                anchors.bottomMargin: mainpage.radius
                anchors.leftMargin: mainpage.radius * 3
                color: "transparent"
                height: mainpage.radius * 3
            }

        }

        Timer {
                id: timer2
            }

        SwipeView{
            property bool isFirstTime: true
            id: swipeView
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftPan.right
            anchors.rightMargin: mainpage.radius
            anchors.leftMargin: -mainpage.radius
            interactive: false
            currentIndex: listView.currentIndex
            clip: true
            orientation: Qt.Vertical
            background: Rectangle{
                anchors.fill: parent
                color: mainpage.color
            }
            onCurrentIndexChanged: {
                function delay(delayTime, cb) {
                    timer2.interval = delayTime;
                    timer2.repeat = false;
                    timer2.triggered.connect(cb);
                    timer2.start();
                }
                if(currentIndex === 3 && isFirstTime == true){
                    isFirstTime = false
                    listView.enabled = 0
                    delay(400, function() {
                             infoPage.startAnim()
                            listView.enabled = 1
                            })
                }
            }
            HomePage {
                id: homePage
            }
            SecondPage {
                id: secondPage
            }
            SettingsPage{
                id: settingsPage
            }
            InfoPage {
                id: infoPage
            }
        }
    }

    Connections{
        target: subjectSettingsClass
        function onAddSubject(subjectName){
            subjectConfigList.insert(0,{
                                     "_name": subjectName
                                     })
        }
    }

    ListModel{
        id: subjectConfigList
    }

    Connections{
        target: teacherSettingsClass
        function onAddTeacherSetting(teacherName) {
            teacherModel.append({
                    "_name": teacherName,
                })
        }
        function onAddNewTeacher(teacherName){
            teacherModel.insert(0,{
                    "_name": teacherName,
                })
        }
    }
    ListModel{
        id: teacherModel
        onCountChanged: copyToBoxModel()
        function copyToBoxModel(){
            teacherBoxModel.clear()
            teacherBoxModel.append({"_name": "Нет преподавателя"})
            for(var i = 0; i < teacherModel.count; i++)
                teacherBoxModel.append({"_name": teacherModel.get(i)._name})
        }
    }
    ListModel{
        id: teacherBoxModel
        function sort(subject){
            var subjectProfiled = teacherSettingsClass.getSubjectProfiled(subject)
            for(var i = 0; i < teacherBoxModel.count; i++){
                var item = teacherBoxModel.get(i)
                if(subjectProfiled.includes(item._name))
                    teacherBoxModel.move(i, 1, 1)
            }
            return true
        }
    }
    ListModel{
        id: cabinetsConfigList
    }
    Connections{
        target: cabinetSettingsClass
        function onAddCabinetViewSetting(cabinet){
            cabinetsConfigList.append({"_name": cabinet})
        }
    }
}
