import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

import QtQuick.Controls 2.15
import QtQuick.Controls 2.5

import QtQuick.Layouts 1.15

import QtQuick 2.0
import QtQuick 2.12
import QtQuick 2.9

Page{
    id: subjectListPage

    property var currentPageName: ""
    property var currentListModel: ""
    property bool isWriting: false

    Connections{
        target: configurationsClass

        onShowConfigurationSetting : {
            currentListModel = "configurationModel"
            configurationModel.clear()
            isWriting = true
            configurationModel.append({settingName: "Study days per week", settingValue: dayPerWeek})
            configurationModel.append({settingName: "Lessons per day", settingValue: lessonsPerDay})
            configurationModel.append({settingName: "How many platoons", settingValue: platoonCount})
            isWriting = false
        }
    }

    ListModel{
        id: configurationModel

    }
    function deleteSubjectModelItem(id){
        for(var i = subjectModel.count-1; i > 0; i--){
            if(subjectModel.get(i)._id === id){
                subjectModel.remove(i)
                break
            }
            subjectModel.setProperty(i,"_id",subjectModel.get(i)._id-1)
        }
    }

    Connections{
        target: subjectSettingsClass
        onAddSubjectSetting : {
            currentListModel = "subjectsModel"
            isWriting = true
            subjectModel.append({_id: subjectModel.count, settingName: subjectSettingName, settingValue: subjectSettingValue})
            isWriting = false
        }

        onClearSubjectModel:{
            subjectModel.clear()
            isWriting = true
            subjectModel.append({_is: 0, settingName: "Добавить", settingValue: "4"})
            isWriting = false
        }
    }
    ListModel{
        id: subjectModel
    }

    Rectangle{
        anchors.fill: parent
        color: mainpage.color
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
            text: currentPageName
            font.family: poiret.font
            font.pointSize: 40
            color: textColor
        }
        Rectangle{
            id: gohomeBut
            width: 150
            height: 40
            color: leftPan.color
            radius: 20
            border.color: blue.color
            border.width: 0
            Text {
                anchors.centerIn: parent
                text: "Назад"
                font.family: poiret.font
                font.pointSize: 15
                color: textColor
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    gohomeBut.border.width = 2
                }
                onExited: {
                    gohomeBut.border.width = 0
                }
                onClicked: {
                    if(currentListModel == "subjectsModel"){
                        var subList = ""
                        for(var i = 1; i < subjectModel.count; i++){
                            subList += (subjectModel.get(i).settingName + "-" + subjectModel.get(i).settingValue)
                            if(i !== subjectModel.count-1)
                                subList += '\n'
                        }
                        subjectSettingsClass.saveSubjectSettings(currentPageName, subList)
                    }
                    configurationPage.setSwipeViewIndex(0)
                }
            }
        }
        ListView{
            visible: currentListModel == "configurationModel" ? true : false
            enabled: currentListModel == "configurationModel" ? true : false
            anchors.fill: parent
            anchors.margins: 200
            spacing: 10
            model: configurationModel
            delegate: Item{
                anchors.horizontalCenter: parent.horizontalCenter
                height: 50
                width: parent.width
                Rectangle{
                    id: input
                    height: 50
                    width: parent.width / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: leftPan.color
                    radius: 25
                    border.color: blue.color
                    border.width: 0
                    TextInput{
                        anchors.fill: parent
                        anchors.topMargin: 10
                        font.family: poiret.font
                        font.pointSize: 15
                        color: textColor
                        text: settingValue
                        anchors.leftMargin: 20
                        HoverHandler{
                            onHoveredChanged: {
                                if(hovered)
                                    input.border.width = 2
                                else
                                    input.border.width = 0
                            }
                        }
                    }
                }
                Text {
                    anchors.right: input.left
                    anchors.rightMargin: 20
                    anchors.verticalCenter: input.verticalCenter
                    text: settingName
                    font.family: poiret.font
                    font.pointSize: 15
                    color: textColor
                }
            }
        }
        ListView{
            visible: currentListModel == "subjectsModel"? true : false
            enabled: currentListModel == "subjectsModel"? true : false
            anchors.fill: parent
            anchors.topMargin: 200
            anchors.rightMargin: 300
            anchors.bottomMargin: 100
            anchors.leftMargin: 250
            clip: true
            spacing: 10
            model: subjectModel
            ScrollBar.vertical: ScrollBar{}
            delegate: Item{
                height: 50
                width: parent.width
                Rectangle{
                    id: input2
                    visible: settingName != "Добавить" ? true : false
                    enabled: settingName != "Добавить" ? true : false
                    height: 50
                    width: parent.width / 5
                    anchors.left: input3.right
                    anchors.leftMargin: 20
                    color: leftPan.color
                    radius: 25
                    border.color: blue.color
                    border.width: 0
                    TextEdit{
                        id: text2
                        anchors.fill: parent
                        anchors.topMargin: 10
                        font.family: poiret.font
                        font.pointSize: 15
                        color: textColor
                        text: settingValue
                        anchors.leftMargin: 20
                        onTextChanged: {
                            if(!isWriting)
                                subjectModel.setProperty(_id, "settingValue", text2.text)
                        }
                        HoverHandler{
                            onHoveredChanged: {
                                if(hovered)
                                    input2.border.width = 2
                                else
                                    input2.border.width = 0
                            }
                        }
                    }
                }
                Rectangle{
                    id: input3
                    height: 50
                    width: settingName != "Добавить" ? parent.width / 2.5 : parent.width / 2.5 + parent.width / 5 + 20
                    anchors.left: parent.left
                    anchors.leftMargin: 100
                    anchors.verticalCenter: input2.verticalCenter
                    color: leftPan.color
                    radius: 25
                    border.color: blue.color
                    border.width: 0
                    HoverHandler{
                        onHoveredChanged: {
                            if(hovered){
                                input3.border.width = 2
                                image2.opacity = 0.5
                            }else{
                                input3.border.width = 0
                                image2.opacity = 0
                            }
                        }
                    }
                    TextEdit{
                        id: text
                        readOnly: settingName == "Добавить"? true : false
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: settingName == "Добавить" ? Text.AlignRight : Text.AlignHCenter
                        width: settingName == "Добавить"? parent.width / 1.7 : contentWidth
                        anchors.left: parent.left
                        anchors.topMargin: 10
                        font.family: poiret.font
                        font.pointSize: 15
                        color: textColor
                        text: settingName
                        anchors.leftMargin: 20
                        onTextChanged:{
                            if(!isWriting && settingName != "Добавить")
                                subjectModel.setProperty(_id, "settingName", text.text)
                        }
                    }
                    MouseArea{
                        anchors.fill: parent
                        visible: settingName == "Добавить" ? true : false
                        enabled: settingName == "Добавить" ? true : false
                        onClicked: {
                            subjectModel.append({_id: subjectModel.count, settingName: "Предмет", settingValue: "0"})
                        }
                    }
                    Image{
                        id: image2
                        visible: settingName != "Добавить"? true : false
                        anchors.verticalCenter: parent.verticalCenter
                        opacity: 0
                        anchors.left: text.right
                        source: "./images/delete-red.png"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                if(!isWriting && settingName != "Добавить")
                                deleteSubjectModelItem(_id);
                            }
                        }
                    }
                }
            }
        }
    }
}
