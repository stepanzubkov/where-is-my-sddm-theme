import QtQuick 2.15
import QtQuick.Controls 2.0
import SddmComponents 2.0

import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    width: 640
    height: 480

    readonly property color textColor: config.stringValue("basicTextColor")
    property int currentUsersIndex: userModel.lastIndex
    property int currentSessionsIndex: sessionModel.lastIndex
    property int usernameRole: Qt.UserRole + 1
    property int realNameRole: Qt.UserRole + 2
    property int sessionNameRole: Qt.UserRole + 4
    property string currentUsername: config.boolValue("showUserRealNameByDefault") ?
    userModel.data(userModel.index(currentUsersIndex, 0), realNameRole)
    : userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
    property string currentSession: sessionModel.data(sessionModel.index(currentSessionsIndex, 0), sessionNameRole)
    property string passwordFontSize: config.intValue("passwordFontSize") || 96
    property string usersFontSize: config.intValue("usersFontSize") || 48
    property string sessionsFontSize: config.intValue("sessionsFontSize") || 24


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
        switch(config.stringValue("backgroundMode"))
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
            backgroundBorder.border.width = 5;
            animateBorder.restart();
            passwordInput.clear();
        }
        function onLoginSucceeded() {
            backgroundBorder.border.width = 0;
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

        Shortcut {
            sequence: "F10"
            onActivated: {
                if (sddm.canSuspend) {
                    sddm.suspend();
                }
            }
        }
        Shortcut {
            sequence: "F11"
            onActivated: {
                if (sddm.canPowerOff) {
                    sddm.powerOff();
                }
            }
        }
        Shortcut {
            sequence: "F12"
            onActivated: {
                if (sddm.canReboot) {
                    sddm.reboot();
                }
            }
        }

        Shortcut {
            sequence: "F1"
            onActivated: {
                helpMessage.visible = !helpMessage.visible
            }
        }


        Rectangle {
            id: background
            visible: true
            anchors.fill: parent
            color: config.stringValue("backgroundFill") || "transparent"
            Image {
                id: image
                anchors.fill: parent
                source: config.stringValue("background")
                smooth: true
                fillMode: bgFillMode()
                z: 2
            }

            Rectangle {
                id: backgroundBorder
                anchors.fill: parent
                z: 4
                border.color: "#ff3117"
                border.width: 0
                color: "transparent"
                Behavior on border.width {
                    SequentialAnimation {
                        id: animateBorder
                        running: false
                        loops: Animation.Infinite
                        NumberAnimation { from: 5; to: 10; duration: 700 }
                        NumberAnimation { from: 10; to: 5;  duration: 400 }
                    }
                }
            }

            FastBlur {
                id: fastBlur
                z: 3
                anchors.fill: image
                source: image
                radius: config.intValue("blurRadius")
            }

        }

        TextInput {
            id: passwordInput
            width: parent.width*(config.realValue("passwordInputWidth") || 0.5)
            height: 200/96*passwordFontSize
            font.pointSize: passwordFontSize
            font.bold: true
            font.letterSpacing: 20/96*passwordFontSize
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            echoMode: config.boolValue("passwordMask") ? TextInput.Password : null
            color: config.stringValue("passwordTextColor") || textColor
            selectionColor: textColor
            selectedTextColor: "#000000"
            clip: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            passwordCharacter: config.stringValue("passwordCharacter") || "*"
            cursorVisible: config.boolValue("passwordInputCursorVisible")
            onAccepted: {
                if (text != "" || config.boolValue("passwordAllowEmpty")) {
                    sddm.login(userModel.data(userModel.index(currentUsersIndex, 0), usernameRole)
 || "123test", text, currentSessionsIndex);
                }
            }
            Rectangle {
                z: -1
                anchors.fill: parent
                color: config.stringValue("passwordInputBackground") || "transparent"
                radius: config.intValue("passwordInputRadius") || 10
            }
            cursorDelegate: Rectangle {
                function getCursorColor() {
                    if (config.stringValue("passwordCursorColor").length == 7 && config.stringValue("passwordCursorColor")[0] == "#") {
                        return config.stringValue("passwordCursorColor");
                    } else if (config.stringValue("passwordCursorColor") == "constantRandom" ||
                               config.stringValue("passwordCursorColor") == "random") {
                        return generateRandomColor();
                    } else {
                        return textColor
                    }
                }
                id: passwordInputCursor
                width: 18/96*passwordFontSize
                visible: config.boolValue("passwordInputCursorVisible")
                onHeightChanged: height = passwordInput.height/2
                anchors.verticalCenter: parent.verticalCenter
                color: getCursorColor()
                property color currentColor: color

                SequentialAnimation on color {
				        loops: Animation.Infinite
                        PauseAnimation { duration: 100 }
                        ColorAnimation { from: currentColor; to: "transparent"; duration: 0 }
				        PauseAnimation { duration: 500 }
                        ColorAnimation { from: "transparent"; to: currentColor; duration: 0 }
				        PauseAnimation { duration: 400 }
				        running: config.boolValue("cursorBlinkAnimation")
				}

                function generateRandomColor() {
                    var color_ = "#";
                    for (var i = 0; i<3; i++) {
                        var color_number = parseInt(Math.random()*255);
                        var hex_color = color_number.toString(16);
                        if (color_number < 16) {
                            hex_color = "0" + hex_color;
                        }
                        color_ += hex_color;
                    }
                    return color_;
                }
                Connections {
                    target: passwordInput
                    function onTextEdited() {
                        if (config.stringValue("passwordCursorColor") == "random") {
                            passwordInputCursor.currentColor = generateRandomColor();
                        }
                    }
                }
            }
        }
        UsersChoose {
            id: username
            text: currentUsername
            visible: config.boolValue("showUsersByDefault")
            width: mainFrame.width/2.5/48*usersFontSize
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
            visible: config.boolValue("showSessionsByDefault")
            width: mainFrame.width/2.5/24*sessionsFontSize
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

        Text {
            id: helpMessage
            visible: false
            text: "Show help - F1\n" +
                  "Cycle select next user - F2 or Alt+u\n" +
                  "Cycle select previous user - Ctrl+F2 or Alt+Ctrl+u\n" +
                  "Cycle select next session - F3 or Alt+s\n" +
                  "Cycle select previous session - Ctrl+F3 or Alt+Ctrl+s\n" +
                  "Suspend - F10\n" +
                  "Poweroff - F11\n" +
                  "Reboot - F12"
            color: textColor
            font.pointSize: 18
            font.family: "monospace"
            anchors {
                top: parent.top
                topMargin: 30
                left: parent.left
                leftMargin: 30
            }
        }

        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }

    }

    Loader {
        active: config.boolValue("hideCursor") || false
        anchors.fill: parent
        sourceComponent: MouseArea {
            enabled: false
            cursorShape: Qt.BlankCursor
        }
    }
}

