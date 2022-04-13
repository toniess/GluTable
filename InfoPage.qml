import QtQuick.Window 2.12
import Qt.labs.qmlmodels 1.0

import QtQuick.Controls.Material 2.3

//import QtMultimedia 5.15

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
    id: thisPage
    function startAnim(){
        animf7.start()
        imaged.visible = 1
        //isVideoPlaying = true
    }

    Rectangle{
        anchors.fill: parent
        color: mainpage.color
//        Video {
//            id: video
//            anchors.fill: parent
//            muted: true
//            scale: 1.3
//            source: "./images/conf.m4v"

//            onStopped: {
//                videoPlay(0)
//            }
//        }
        Text {
            scale: 0
            id: justaText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.family: poiret.font
            font.pointSize: 40
            text: "GluTable"
            color: textColor
            font.letterSpacing: 10
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: 50
                font.family: poiret.font
                font.pointSize: 15
                text: "by Ignatiy Glushkov"
                color: textColor
                font.letterSpacing: 3
            }
        }

        Image {
            visible: false
            id: imaged
            clip: true
            width: 300
            height: 300
            source: "./images/Programmer.jpg"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
                Image {
                    id: imaged1
                    clip: true
                    width: 300
                    height: 300
                    opacity: 0
                    source: "./images/insta.jpg"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    NumberAnimation {
                        id: appear
                        target: imaged1
                        property: "opacity"
                        to: 0.6
                        duration: 200
                    }
                    NumberAnimation {
                        id: disAppear
                        target: imaged1
                        property: "opacity"
                        to: 0
                        duration: 200
                    }
                HoverHandler{
                    onHoveredChanged: hovered ? appear.start() : disAppear.start()
                }
            }

            Rectangle{
                anchors.centerIn: imaged
                color: "transparent"
                width: 400
                height: 400
                radius: 150
                border.width: 50
                border.color: mainpage.color
            }


            PropertyAnimation {
                id: animf7
                targets: [imaged, justaText]

                property: "scale"
                from: 0
                to: 1
                duration: 300
                onRunningChanged: {
                    if(!running){
                        animf8.start()
                        animf9.start()
                    }
                }
            }
            PropertyAnimation {
                id: animf8
                target: imaged
                property: "anchors.horizontalCenterOffset"

                to: -170
                duration: 550

            }
            PropertyAnimation {
                id: animf9
                target: justaText
                property: "anchors.horizontalCenterOffset"

                to: 170
                duration: 550
                onRunningChanged: {
                    if(running){
                        //video.play()
                    }
                }
            }
        }

    }
}
