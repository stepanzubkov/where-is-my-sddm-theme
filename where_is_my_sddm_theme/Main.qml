import QtQuick 2.15
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480

    readonly property color textColor: "#ffffff"
    property int currentUsersIndex: userModel.lastIndex
    property int usernameRole: Qt.UserRole + 1
    property int realNameRole: Qt.UserRole + 2
    property string currentUsername: userModel.data(userModel.index(currentUsersIndex, 0), realNameRole) ||
                                     userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)

    Connections {
        target: sddm
        function onLoginFailed() {
            background.border.width = 5;
            animateBorder.restart();
            passwordInput.clear();
        }
        function onLoginSucceeded() {
            background.border.width = 0;
            animateBorder.stop();
        }
    }

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height
        Shortcut {
            sequences: ["Alt+U", "F2"]
            onActivated: {
                if (!username.visible) {
                    username.visible = true;
                    return;
                }
                if (currentUsersIndex >= userModel.count - 1) {
                    currentUsersIndex = 0;
                } else {
                    currentUsersIndex++;
                }
            }
        }

        Rectangle {
            id: background
            visible: true
            anchors.fill: parent
            border.color: "#ff3117"
            border.width: 0
            Behavior on border.width {
                SequentialAnimation {
                    id: animateBorder
                    running: false
                    loops: Animation.Infinite
                    NumberAnimation { from: 5; to: 10; duration: 700 }
                    NumberAnimation { from: 10; to: 5;  duration: 400 }
                }
            }

            Image {
                id: image
                anchors.fill: parent
                source: config.background
                fillMode: Image.PreserveAspectCrop
                z: 2
              }

            Rectangle {
                id: rectangle
                anchors.fill: parent
                color: config.backgroundFill || "transparent"
            }
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
            selectedTextColor: "#000000"
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            passwordCharacter: config.passwordCharacter || "*"
            onAccepted: {
                if (text != "") {
                    sddm.login(userModel.lastUser || "123test", text, sessionModel.lastIndex || 0);
                }
            }
            cursorDelegate: Rectangle {
                id: passwordInputCursor
                width: 10
                onHeightChanged: height = passwordInput.height/2
                anchors.verticalCenter: parent.verticalCenter
                color: textColor
                function generateUniqueColorForChar(chr, username) {
                    var chr_hex = (chr.charCodeAt(0)%255).toString(16);
                    if (chr_hex.length == 1) {
                        chr_hex = "0" + chr_hex;
                    }
                    var green_num = username[0].charCodeAt(0) + username[1].charCodeAt(0);
                    if (green_num > 255) {
                        green_num = 255;
                    }
                    var green_hex = green_num.toString(16)
                    if (green_hex.length == 1) {
                        green_hex = "0" + green_hex;
                    }
                    var blue_num = (username[username.length - 1].charCodeAt(0) +
                                username[username.length - 2].charCodeAt(0))
                    if (blue_num > 255) {
                        blue_num = 255;
                    }
                    var blue_hex = blue_num.toString(16)
                    if (blue_hex.length == 1) {
                        blue_hex = "0" + blue_hex;
                    }
                    var rgb = [chr_hex, green_hex, blue_hex];

                    return ("#" + rgb[parseInt(Math.random()*3)]
                                + rgb[parseInt(Math.random()*3)]
                                + rgb[parseInt(Math.random()*3)]);

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
                        passwordInputCursor.color = generateUniqueColorForChar(
                            passwordInput.text[passwordInput.text.length - 1] || "\x00", userModel.lastUser || "123test",
                        );
                        changeCursorColor.restart();
                    }
                }
                Glow {
                    source: passwordInputCursor
                    anchors.fill: passwordInputCursor
                    color: passwordInputCursor.color
                    samples: 9
                    radius: 4
                }
            }
        }

        Text {
            id: username
            visible: false
            width: root.width/2.5
            font.pointSize: 48
            font.family: "monospace"
            color: textColor
            text: currentUsername
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: passwordInput.top
                bottomMargin: 30
            }
        }
        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }

    }
}

