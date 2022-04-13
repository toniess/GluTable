import QtQml 2.12
import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle{
    id: slidePanel
    property bool opened: false
    onOpenedChanged: {slideAnim.start(); isPanelOpened = opened}
    anchors.bottomMargin: bar.height / 2
    width: parent.width/3.5
    color: secColor
    radius: width / 15

    Text {
        anchors.top: parent.top
        anchors.topMargin: 20
        id: title
        text: qsTr("Действия")
        anchors.horizontalCenter: parent.horizontalCenter
        color: textColor
        font.family: helThin.font
        font.pointSize: 20
    }

    Column{
        id: coll
        width: parent.width * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 60

        spacing: 10

        Rectangle{
            width: parent.width
            implicitHeight: 1
            color: "grey"
        }
        DoubleBottomButton {
            id: firButton
            buttonText: "Cохранить"
            function buttonClicked(){
                needToSaveTable()
            }
        }
        DoubleBottomButton {
            id: secButton
            buttonText: "Экспорт"
            function buttonClicked(){
//                printer.chooseSavePath()
                conveyInfoToPrinterAndPrint()
            }
        }
        DoubleBottomButton {
            id: thiButton
            buttonText: "Экспорт препод."
            function buttonClicked(){
                conveyInfoToPrinterAndPrintTeachers()
            }
        }

        Rectangle{
            width: parent.width
            implicitHeight: 1
            color: "grey"
        }

        DoubleBottomButton {
            buttonText: "Генерировать"
            function buttonClicked(){
                if(isLoading){
                    tableMixerClass.stopThread()
                    isLoading = false
                }else{
                    isLoading = true
                    conveyInfoToMixer(false)
                    progressAnim.start()
                }
            }
        }
        DoubleBottomButton {
            buttonText: "Проверить"
            function buttonClicked(){}
        }
        DoubleBottomButton {
            buttonText: "Очистить"
            function buttonClicked(){}
        }
    }

    NumberAnimation{
        id: slideAnim
        property int aim: 0
        target: slidePanel
        property: "anchors.leftMargin"
        to: aim
        duration: 150
        function start(){
            running = false
            aim = aim == 0? - slidePanel.width * 1.05 : 0
            running = true
        }
    }

}
