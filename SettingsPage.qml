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
    function setIndex(id){
        swipeView.currentIndex = id
    }

    id: settingsPage
    ListModel{
        id: settingsModel
        ListElement{
            _id: -1
            _text: "Настройки"
        }
        ListElement{
            _id: 0
            _text: "Основные"
        }
        ListElement{
            _id: 1
            _text: "Преподаватели"
        }
        ListElement{
            _id: 2
            _text: "Конфигурации"
        }
        ListElement{
            _id: 3
            _text: "Кабинеты"
        }

    }
    Rectangle{
        anchors.fill: parent
        color: mainpage.color
        SwipeView{
            id: swipeView
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 5
            anchors.topMargin: 10
            clip: true
            interactive: false
            SettingsChoice {

            }
            Settings {
                id: settings
            }
        }
    }
}
