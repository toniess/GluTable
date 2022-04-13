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

ListModel{
    id: teacherModel

    onCountChanged:{
        upDateList();
        var teachers = ""
        for(var i = 0; i < teacherModel.count; i++){
            teachers += teacherModel.get(i)._text + '\n'
        }
        mainSettingsClass.saveSettings(teachers, "settings/teachers.gts")
    }
}
