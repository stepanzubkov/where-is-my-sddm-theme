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
    property int currentSessionsIndex: sessionModel.lastIndex
    property int usernameRole: Qt.UserRole + 1
    property int realNameRole: Qt.UserRole + 2
    property int sessionNameRole: Qt.UserRole + 4
    property string currentUsername: userModel.data(userModel.index(currentUsersIndex, 0), realNameRole) ||
                                     userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
    property string currentSession: sessionModel.data(sessionModel.index(currentSessionsIndex, 0), sessionNameRole)

    function usersCycleSelectPrev() {
        if (currentUsersIndex - 1 < 0) {
            currentUsersIndex = userModel.count - 1;
        } else {
            currentUsersIndex--;
        }
    }

    function usersCycleSelectNext() {
        if (currentUsersIndex >= userModel.count - 1) {
            currentUsersIndex = 0;
        } else {
            currentUsersIndex++;
        }
    }

    function bgFillMode() {
        switch(config.backgroundMode)
        {
            case "aspect":
                return Image.PreserveAspectCrop;

            case "fill":
                return Image.Stretch;

            case "tile":
                return Image.Tile;

            default:
                return Image.Pad;
        }
    }

    function sessionsCycleSelectPrev() {
        if (currentSessionsIndex - 1 < 0) {
            currentSessionsIndex = sessionModel.rowCount() - 1;
        } else {
            currentSessionsIndex--;
        }
    }

    function sessionsCycleSelectNext() {
        if (currentSessionsIndex >= sessionModel.rowCount() - 1) {
            currentSessionsIndex = 0;
        } else {
            currentSessionsIndex++;
        }
    }


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
                usersCycleSelectNext();
            }
        }
        Shortcut {
            sequences: ["Alt+Ctrl+S", "Ctrl+F3"]
            onActivated: {
                if (!sessionName.visible) {
                    sessionName.visible = true;
                    return;
                }
                sessionsCycleSelectPrev();
            }
        }

        Shortcut {
            sequences: ["Alt+S", "F3"]
            onActivated: {
                if (!sessionName.visible) {
                    sessionName.visible = true;
                    return;
                }
                sessionsCycleSelectNext();
            }
        }
        Shortcut {
            sequences: ["Alt+Ctrl+U", "Ctrl+F2"]
            onActivated: {
                if (!username.visible) {
                    username.visible = true;
                    return;
                }
                usersCycleSelectPrev();
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
                fillMode: bgFillMode()
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
                    sddm.login(userModel.lastUser || "123test", text, currentSessionsIndex);
                }
            }
            cursorDelegate: Rectangle {
                id: passwordInputCursor
                width: 10
                onHeightChanged: height = passwordInput.height/2
                anchors.verticalCenter: parent.verticalCenter
                color: (() => {
                        if (config.cursorColor.length == 7 && config.cursorColor[0] == "#") {
                            return config.cursorColor;
                        } else {
                            return textColor
                        }
                    })()

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
                        if (config.cursorColor == "random") {
                            passwordInputCursor.color = generateUniqueColorForChar(
                                passwordInput.text[passwordInput.text.length - 1] || "\x00", currentUsername || "123test",
                            );
                            changeCursorColor.restart();
                        }
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
        UsersChoose {
            id: username
            text: currentUsername
            visible: false
            width: mainFrame.width/2.5
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: passwordInput.top
                bottomMargin: 40
            }
            onPrevClicked: {
                usersCycleSelectPrev();
            }
            onNextClicked: {
                usersCycleSelectNext();
            }
        }

        SessionsChoose {
            id: sessionName
            text: currentSession
            visible: false
            width: mainFrame.width/2.5
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: 30
            }
            onPrevClicked: {
                sessionsCycleSelectPrev();
            }
            onNextClicked: {
                sessionsCycleSelectNext();
            }
        }

        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }

    }
}

