import QtQuick 2.0
import QtQuick.Controls 2.4

ScrollView {

    id: control
    property ScrollBar hScrollBar: ScrollBar.horizontal
    property ScrollBar vScrollBar: ScrollBar.vertical
    function scrolled(){}

    contentWidth: -1

    ScrollBar.vertical: MyScrollBar {
        onPositionChanged: scrolled()
    }

    ScrollBar.horizontal: ScrollBar {
        visible: false
        active: false
    }

    function scrollTo(type, ratio) {
        var scrollFunc = function (bar, ratio) {
            bar.setPosition(ratio)
        }
        switch(type) {
        case Qt.Horizontal:
            scrollFunc(control.hScrollBar, ratio)
            break;
        case Qt.Vertical:
            scrollFunc(control.vScrollBar, ratio)
            break;
        }
    }
}
