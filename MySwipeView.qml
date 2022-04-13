import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

SwipeView {
    id: layout
    anchors.top: bar.bottom
    anchors.topMargin: -12
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    clip: true
    currentIndex: bar.currentIndex
    interactive: false

    property int lastInd: 0
    property int currentItemId: -1

    signal activeFocus
    signal changeTeacher(var text)
    signal getMixingData
    signal getPrintingData

    function getDataForPrinter(){
        getPrintingData()
    }
    function activeItemFocus(){
        activeFocus()
    }
    function teacherChanged(text){
        changeTeacher(text)
    }
    function getDataForMixing(){
        return getMixingData()
    }

    Repeater{
	model: tabsmodel
	delegate: SecondPageTab{
            property int tableId: index
            Connections{
                target: layout
                onActiveFocus:   {if(layout.currentIndex == index) activeFocus()}
                onChangeTeacher: {if(layout.currentIndex == index) changeTeacherinTableItem(text)}
                onGetMixingData: {getDataForMixing()}
                onGetPrintingData:{getDataForPrinter()}
            }
        }
    }
}
