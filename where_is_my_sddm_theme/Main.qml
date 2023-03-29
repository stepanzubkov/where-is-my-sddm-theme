import QtQuick 2.7
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0
import SddmComponents 2.0

Rectangle {
    id: root
    width: 640
    height: 480

    readonly property color textColor: "#ffffff"
    readonly property color bgColor: "#000000"

    Connections {
        target: sddm
        function onLoginFailed() {
            errorBorder.visible = true;
            animateBorder.start();
            passwordInput.text = "";
        }
        function onLoginSucceeded() {
            errorBorder.visible = false;
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
            passwordCharacter: config.passwordCharacter || "*"
            onAccepted: {
                sddm.login(userModel.lastUser || "123test", text, sessionModel.lastIndex || 0);
                sddm.loginFailed();
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
                    samples: 8
                    radius: 10
                }
            }
        }
        Component.onCompleted: {
            passwordInput.forceActiveFocus();
        }

        Rectangle {
            id: errorBorder
            visible: false
            color: "transparent"
            anchors.fill: parent
            border.color: "#ff3117"
            border.width: 5
            NumberAnimation {
                id: animateBorder
                target: errorBorder
                properties: "border.width"
                duration: 1500
                from: 5
                to: 10
                loops: Animation.Infinite
                easing {
                    type: Easing.InOutBack
                    amplitude: 2.0
                }
           }
        }
    }
}
