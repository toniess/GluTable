import QtQuick.Window 2.12
import QtQuick 2.9
import QtQuick.Controls 2.5

Rectangle{
    width: 100
    height: 100

    Text {
        anchors.verticalCenter: parent.verticalCenter
        id: logoutText
        x: 50
        color: textColor
        font.family: helThin.font
        font.styleName: "Thin"
        font.pointSize: 15
        text: "Выход"
    }
    Image {
        x: 30
        anchors.right: logoutText.left
        anchors.rightMargin: 5
        anchors.verticalCenter: logoutText.verticalCenter
        source: "./images/logout.svg"
        scale: 0.5
    }
    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            window.quitRequire()
        }
        onEntered:{
            parent.opacity = 0.5
        }
        onExited: {
            parent.opacity = 1
        }

    }
}
