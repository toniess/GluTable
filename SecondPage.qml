import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtQuick.Controls.Private 1.0

//import QtQuick.Controls.Styles 1.4

//import QtQuick.Controls 1.1
import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

Page{
    id: page

    function setFirstItem(){
        bar.currentIndex = 0
    }
    function conveyInfoToMixer(isSimple){
        tableMixerClass.inizialize(swipeView.count, isSimple)
        swipeView.getDataForMixing()
    }
    function conveyInfoToPrinterAndPrint(){
        swipeView.getDataForPrinter()
        printer.printData()
    }
    function conveyInfoToPrinterAndPrintTeachers(){
        swipeView.getDataForPrinter()
        printer.printTeachersData()
    }

    property bool isLoading: false
    property bool isPanelOpened: false

    property string hoveredTeacher

    property string currentItemText: ""

    onHoveredTeacherChanged: {
        lightedRows = []
    }
    signal activeItemFocus(var tableId, var itemId)

    property var lightedRows: []

    function delTab(pos){
        tabsmodel.remove(pos);
        for(var i = pos; i < tabsmodel.count; i++)
            tabsmodel.setProperty(i, "_pos", i)
        homePageClass.deleteCompanyTable(pos)
    }
    function clearTabBar(){
        for(var i = 0; i < tabsmodel.count; i++)
            tabsmodel.remove(i);
    }

    Connections{
        target: tableMixerClass
        function onStopLoading(){
            isLoading = false
            progressAnim.stop()
        }
    }

    function addCompanyTable(companyTablePos){
        tabsmodel.append({
                     "_text": companyTablePos + 1,
                     "_pos": companyTablePos
                         })
        bar.currentIndex = companyTablePos
    }

    Connections{
        target: homePageClass
        onAddCompanyTable:{
            page.addCompanyTable(companyTablePos)
        }
        onClearWorkSpace: {
            tabsmodel.clear()
        }
        onOpenEditPage:{
            bar.currentIndex = 0
        }
    }

    function changeIndex(text){
        control.setDisplayText(text)
    }
    function changeTeacherinTableItem(text){
        swipeView.changeTeacher(text)
    }

    Item{
        anchors.fill: parent
        Rectangle{
            id:secpage
            anchors.fill: parent
            color: mainpage.color
            ListModel{
                id: tabsmodel
            }
            Timer {
                    id: timer
                }
            GreenButton {
                id: buttonSave
                anchors.right: makeUpButton.left
                anchors.verticalCenter: makeUpButton.verticalCenter
                anchors.rightMargin: 5
                image: "./images/save.svg"
                imageScale: 0.5
                function buttonClicked() {
//                    conveyInfoToPrinterAndPrint()
                    needToSaveTable();
                }
            }
            GreenButton {
                id: makeUpButton
                anchors.verticalCenter: makeUpComplexButton.verticalCenter
                anchors.right: makeUpComplexButton.left
                anchors.rightMargin: 5
                image: isLoading? "./images/cancel.svg" : "./images/makeup-simple.svg"
                imageScale: 0.35
                function buttonClicked() {
                    if(!isLoading){
                        isLoading = true
                        conveyInfoToMixer(true)
                    }else{
                        isLoading = false
                        tableMixerClass.stopThread()
                    }
                }
            }
            GreenButton {
                id: makeUpComplexButton
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5

                image: "./images/menu.svg"
                imageScale: 0.35
                function buttonClicked() {
                    slidePanel.opened = !slidePanel.opened
                }
            }

            TeacherBox {
                id: control
                onFocusChanged: {
                    swipeView.activeItemFocus()
                }
                function valueChanged(text){
                    swipeView.teacherChanged(text)
                }
            }

            MySwipeView {
                id: swipeView
            }
            AnimatedImage{
                anchors.centerIn: parent
                scale: 0.13
                opacity: 0.6
                enabled: isLoading
                visible: isLoading
                source: "./images/loading.gif"
            }

            Rectangle{
                id: plusButton
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 5
                anchors.leftMargin: 5
                width: 30
                height: 30
                radius: 8
                color: hoverHandler1.containsMouse? blue.color : leftPan.color
                Image {
                    anchors.centerIn: parent
                    source: "./images/addTable.png"
                    scale: 0.5
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    id: hoverHandler1
                    onClicked: {
                            if(tabsmodel.count < 7){
                                var newCompanyTablePos = tabsmodel.count
                                homePageClass.addCompanyTableToFile(newCompanyTablePos);
                        }
                    }
                }
            }
            Bar {
                id: bar
            }
        }
    }

    SlidePanel {
        id: slidePanel
        anchors.bottom: parent.bottom
        anchors.left: parent.right
        anchors.top: parent.top
        anchors.topMargin: bar.height
    }


    Rectangle{
        visible: !homePage.isTableOpen
        anchors.fill: parent
        color: mainpage.color
        Text{
            anchors.centerIn: parent
            color: textColor

            text: qsTr("Тут пусто((0")
            font.pointSize: 40
            font.family: poiret.font
            Text {
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Откройте расписание или создайте новое на главной странице")
                font.pointSize: 20
                font.family: poiret.font
                color: textColor
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {}
        }
    }


}
