import QtQuick 2.7
import QtQuick.Controls 2.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480

    readonly property color textColor: "#ffffff"
    readonly property color bgColor: "#000000"

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height

        Rectangle {
            id: background
            anchors.fill: parent
            color: "#000000"
        }

        TextInput {
            id: passwordInput

            width: parent.width/2
            height: 200
            font.pointSize: 72
            font.bold: true
            font.letterSpacing: 20
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            echoMode: TextInput.Password
            color: textColor
            selectionColor: textColor
            selectedTextColor: bgColor
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            passwordCharacter: "*"
            cursorDelegate: Rectangle {
                id: passwordInputCursor
                width: 30
                onHeightChanged: height = passwordInput.height/2
                anchors.verticalCenter: parent.verticalCenter
                color: textColor
                function generateRandomColor() {
                    var color = "#";
                    for (var i = 0; i<6; i++) {
                        color = color + parseInt((Math.random() * 16)).toString(16);
                    }
                    return color;
                }
                Timer {
                    id: changeCursorColor
                    repeat: false
                    interval: 200
                    onTriggered: {
                        passwordInputCursor.color = textColor;
                    }
                }
                Connections {
                    target: passwordInput
                    function onTextEdited() {
                        passwordInputCursor.color = generateRandomColor();
                        changeCursorColor.restart();
                    }
                }
            }
        }
        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }
    }
}
