import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtQuick.Controls 1.1
import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

//import QtQuick.Controls.Styles 1.4

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

//import QtGraphicalEffects 1.0

Page{
    property string tableToDelName: ""
    property bool isTableOpen: listModel.get(1).text !== "Редактор"
    id: homePage

    Connections{
        target : homePageClass
        function onSetStatusBarName(tableName){
            listModel.setProperty(1, "text", tableName)
        }
    }

    property int currentTable: -1
    property int tableToDel: -1

    function delTables(tabId){
        homePageClass.deleteTable(tablesModel.get(tabId-2)._text)
        tablesModel.remove(tabId-2)
        for(var i = tabId-2; i < tablesModel.count-1; i++)
            tablesModel.setProperty(i, "_id", i+2)
        homePageClass.setStatusBarName("")
    }

    function surelyDeleteting(_id){
        if(currentTable === _id){
            currentTable = -1
            homePageClass.clearWorkSpace()
            listModel.setProperty(1,"text", "Редактор")
       }
        delTables(_id)
    }
    Connections{
        target: homePageClass
        onAddTable : {
            tablesModel.insert(tablesModel.count-1,{
                                   _id: tablesModel.count + 1,
                                   _text: tableName,
                                   _height: window.height / 4.3,
                                   _width: window.width / 4.73,
                                   _color: "#2d3543",
                                   _bordercolor: "#3498DB",
                                   _source: "",
                                   _size: 25,
                                   _source: "",
                                   _bool: false,
                                   _i: 5,
                                   _y: 5
                               })
        }
    }
    function delHomeConfigModel(){
        configModel.delHomeConfigModel()
    }
    function addHomeConfigModelLine(text){
        configModel.addHomeConfigModelLine(text)
    }
    background: {
    color: mainpage.color
}
    StackLayout{
        id: stackLayout
        anchors.fill: parent
        anchors.leftMargin: 5
        clip: true

        Rectangle{
        anchors.fill: parent
        anchors.leftMargin: 5
        color: mainpage.color
        ScrollView{
            anchors.fill: parent
            anchors.margins: 50
            anchors.topMargin: 50
            anchors.bottomMargin: 50
            background: Rectangle{
                anchors.fill: parent
                color: mainpage.color
            }
            ScrollBar.vertical: MyScrollBar{}

            ListModel{
                id: tablesModel
                Component.onCompleted: {
                    tablesModel.append({
                       _id: 1,
                       _text: "",
                       _height: window.height/ 11.428,
                       _width: window.width / 4.73,
                       _color: "transparent",
                       _bordercolor: "transparent",
                       _size: 17,
                       _source: "",
                       _bool: false

                                       })
                    tablesModel.append({
                                           _id: 2,
                                           _text: "Ваши таблицы",
                                           _height: window.height / 11.428,
                                           _width: window.width / 4.73,
                                           _color: "transparent",
                                           _bordercolor: "transparent",
                                           _size: 50,
                                           _source: "",
                                           _bool: false
                                       })
                    tablesModel.append({
                                           _id: 3,
                                           _text: "",
                                           _height: window.height/ 11.428,
                                           _width: window.width / 4.73,
                                           _color: "transparent",
                                           _bordercolor: "transparent",
                                           _size: 17,
                                           _source: "",
                                           _bool: false
                                       })
                    tablesModel.append({
                                           _id: 4,
                                           _text: "",
                                           _height: window.height / 4.3,
                                           _width: window.width / 4.73,
                                           _color: "#2d3543",
                                           _bordercolor: "#3498DB",
                                           _source: "./images/addTable.png",
                                           _size: 17,
                                           _bool: true
                                       })
                }
            }
            Grid{
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 25
                anchors.bottom: parent.bottom
                spacing: window.width / 28.4
                columns: 3

                Repeater{
                    model: tablesModel
                    delegate: Rectangle{
                        property int tableScale: 1
                        clip: _id != 2? true : false
                        id: litleTable
                        height: _height
                        width: _width
                        color: _color === "transparent"? _color : secColor
                        scale: tableScale
                        radius: 10
                        border.color: blue.color//_bordercolor
                        border.width: mousewe.containsMouse || deleteMouse.containsMouse? 2 : 0


                        NumberAnimation {
                            id: scaleAnim
                            target: litleTable
                            property: "scale"
                            to: mousewe.containsMouse || deleteMouse.containsMouse? 1 : 1.05
                            duration: 175
                        }
                        Image{
                            anchors.centerIn: parent
                            source: _source
                            scale: 0.7
                        }

                        Text{
                            enabled:  _id != 1 && _id != 3 ? true:false
                            anchors.top: parent.top
                            anchors.bottom: parent.bottom
                            anchors.centerIn: parent
                            text: _text
                            color: textColor
                            font.family: homePageGridFont.font
                            font.letterSpacing: 0.5
                            font.pointSize: _size
                        }
                        MouseArea{
                            enabled:  _id > 3 ? true : false
                            id:mousewe
                            anchors.fill: parent
                            hoverEnabled: true
                            onContainsMouseChanged:{
                                    deleteAnim.restart()
                                    scaleAnim.restart()
                            }

                            onClicked: {
                                if(_bool){
                                    stackLayout.currentIndex = 2
                                }else{
                                    needToSaveTable()
                                    if(homePageClass.fillWorkSpace(_text)){
                                        listModel.setProperty(1,"text", "Edit " + _text)
                                        listView.currentIndex = 1
                                        swipeView.currentIndex = 1
                                        currentTable = _id
                                        secondPage.setFirstItem()
                                    }else{

                                    }
                                }
                            }
                        }
                        Image {
                            id: ima
                            property int margin: -13
                            visible: _id > 4 && mousewe.containsMouse? true : false
                            source: "./images/delete-red.svg"
                            scale: 0.5
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: margin

                            NumberAnimation {
                                id: deleteAnim
                                target: ima
                                property: "margin"
                                to: mousewe.containsMouse? -13 : -3
                                duration: 140
                            }

                            MouseArea{
                                id: deleteMouse
                                enabled:  _id > 3 ? true : false
                                property var ind: _id
                                property var cou: tablesModel.count
                                anchors.fill: parent
                                onClicked: {
                                    tableToDel = _id
                                    tableToDelName = _text
                                    stackLayout.currentIndex = 1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
        Rectangle{
            anchors.fill: parent
            id: areYouSure
            color: "transparent"

            Text {
                id: deleteHeader
                text: "Удалить таблицу?"
                color: textColor
                font.family: poiret.font
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 50
                y: 50
            }
            Rectangle{
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                height: tablesModel.get(tableToDel-1)._height
                width: tablesModel.get(tableToDel-1)._width
                color: leftPan.color

                radius: 10
                Text{
                    anchors.centerIn: parent
                    text: tableToDelName
                    color: textColor
                    font.family: poiret.font
                    font.pointSize: 25
                }
                Image {
                    anchors.top: parent.top
                    anchors.topMargin: -5
                    anchors.left: parent.left
                    anchors.leftMargin: -5
                    source: "./images/sad.png"
                }
            }
            MyButton {
                id: butDelete
                property int margin: -130
                hCOffset: margin - 5
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.right: parent.right
                anchors.rightMargin: margin
                color: blue.color
                buttonText: "Удалить"
                pointSize: 18
                NumberAnimation {
                    id: animButDeleteButton
                    target: butDelete
                    property: "margin"
                    to: butDelete.isHovered? -130 : 5
                    duration: 150
                }
                onIsHoveredChanged: animButDeleteButton.restart()
                function onButtonClicked(){
                    surelyDeleteting(tableToDel)
                    stackLayout.currentIndex = 0
                    secondPage.setFirstItem()
                }
            }
            MyButton {
                id: butCancel
                property int margin: -130
                hCOffset: 5 - margin
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.left: parent.left
                anchors.leftMargin: margin
                buttonText: "Отменить"
                function onButtonClicked(){ stackLayout.currentIndex = 0 }
                NumberAnimation {
                    id: animButCancelButton
                    target: butCancel
                    property: "margin"
                    to: butCancel.isHovered? -130 : 5
                    duration: 150
                }
                onIsHoveredChanged: animButCancelButton.restart()
            }
        }
        Rectangle{
            property string currentConfigText: ""
            id: newTableReal
            color: mainpage.color
            anchors.fill: parent
            Text{
               id: headerText
               anchors.horizontalCenter: parent.horizontalCenter
               font.family: poiret.font
               font.pointSize: 50
               text: "Новая таблица"
               color: textColor
               y: 50
            }

            MyButton {
                id: but1
                property int margin: -130
                hCOffset: margin - 5
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.right: parent.right
                anchors.rightMargin: margin
                border.width: margin == 5? 1 : 0

                NumberAnimation {
                    id: animButton
                    target: but1
                    property: "margin"
                    to: but1.isHovered? -130 : 5
                    duration: 150
                }
                buttonText: "Создать"
                color: blue.color
                pointSize: 18
               function onButtonClicked(){
                    if(textedittt.text != ""){
                        homePageClass.addNewTable(textedittt.text, newTableReal.currentConfigText)
                        swipeView.currentIndex = 1
                        listView.currentIndex = 1
                        stackLayout.currentIndex = 0
                        currentTable = tablesModel.count
                    }
                    secondPage.setFirstItem()
                    textedittt.text = "";
                    textedittt.focus = 0;
                }
               onIsHoveredChanged: animButton.restart()

            }

            MyButton {
                id: but2
                property int margin: -130
                hCOffset: 5 - margin
                anchors.top: parent.top
                anchors.topMargin: 60
                anchors.left: parent.left
                anchors.leftMargin: margin
                border.width: margin == 5? 1 : 0

                buttonText: "Назад"
                onIsHoveredChanged: animButton2.restart()

                NumberAnimation {
                    id: animButton2
                    target: but2
                    property: "margin"
                    to: but2.isHovered? -130 : 5
                    duration: 150
                }

                function onButtonClicked(){
                    stackLayout.currentIndex = 0
                    textedittt.text = "";
                    textedittt.focus = 0;
                }
            }

            Rectangle{
                property bool isHovered: false
                id: rect2
                width: 400
                height: 30
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                color: leftPan.color
                border.width: textedittt.focus || isHovered? 1 : 0
                border.color: blue.color

                radius: 5

                HoverHandler{
                   onHoveredChanged: parent.isHovered = hovered
                }

                TextInput{
                    id: textedittt
                    color: textColor
                    font.family:  helThin.font
                    font.styleName: "Light"
                    font.pointSize: parent.height /1.6
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 5
                    anchors.verticalCenterOffset: 4
                    width: parent.width
                    height: parent.height
                }
            }

            ListView{
                    id: configList
                    anchors.top: rect2.bottom
                    anchors.left: rect2.left
                    anchors.bottom: parent.bottom
                    anchors.right: rect2.right
                    clip: true
                    ScrollBar.vertical: ScrollBar{visible: false}

                    model: ConfigModel{
                        id: configModel
                    }

                    delegate: RadioButton {
                            id: control
                            text: _text
                            checked: _text === "standart_configuration" ? true : false
                            onCheckedChanged: if(checked) newTableReal.currentConfigText = _text
                            indicator: Rectangle {
                                implicitWidth: 26
                                implicitHeight: 26
                                x: control.leftPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: leftPan.color

                                Rectangle {
                                    width: 14
                                    height: 14
                                    x: 6
                                    y: 6
                                    radius: 7
                                    color: blue.color
                                    visible: control.checked
                                }
                            }
                            contentItem: Text {
                                font.family: helThin.font
                                text: control.text
                                opacity: enabled ? 1.0 : 0.3
                                color: textColor
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: control.indicator.width + control.spacing
                            }
                        }
                }
        }
    }
}
