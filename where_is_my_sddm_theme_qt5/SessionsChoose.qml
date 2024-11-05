import QtQuick 2.15
import QtQuick.Controls 2.0

Item {
    id: root
    property string text: ""
    property string prevText: "<"
    property string nextText: ">"
    property int fontPointSize: sessionsFontSize
    property string fontFamily: defaultFont
    signal prevClicked()
    signal nextClicked()
    Text {
        id: sessionName
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pointSize: root.fontPointSize
        font.family: root.fontFamily
        color: textColor
        text: root.text
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }
    Text {
        id: prevButton
        text: root.prevText
        color: textColor
        font.pointSize: root.fontPointSize
        font.family: root.fontFamily
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            rightMargin: 10
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.prevClicked();
            }
        }
    }
    Text {
        id: nextButton
        text: root.nextText
        color: textColor
        font.pointSize: root.fontPointSize
        font.family: root.fontFamily
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            leftMargin: 10
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.nextClicked();
            }
        }
    }
}
