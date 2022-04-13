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


Rectangle{
    id: settings
    function setIndex(id){
        swipeView.currentIndex = id
    }

    color: mainpage.color

    StackLayout{
        id: swipeView
        anchors.fill: parent
        MainSetPage {
            id: mainSetPage
        }
        TeacherPage {
            id: teachersPage
        }
        ConfigurationPage {
            id: configurationPage
        }
        CabinetSettings{
            id: cabinetSettings
        }
    }
    MyButton{
        id: backButton
        buttonText: "Назад"
        function onButtonClicked(){
            settingsPage.setIndex(0)
        }
    }
}
