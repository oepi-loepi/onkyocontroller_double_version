import QtQuick 2.9
import QtQuick.Layouts 1.1

Item {
    id: button
    property bool primary: true
    property color textColor: !button.enabled ? "red" : "grey"
    property bool small: false
    property alias text
    property alias fontBold
    property int fontSize: {
        if(small) return 14;
        else return 16;
    }

    signal clicked()

    height: small ?  30 : 36
    width: buttonLayout.width + 22
    implicitHeight: height
    implicitWidth: width

    //function doClick(){
    //    releaseFocus();
   //     clicked();
    //}

    Rectangle {
        id: buttonRect
        anchors.fill: parent
        radius: 3
        border.width: parent.focus ? 1 : 0

        state: button.enabled ? "active" : "disabled"
        Component.onCompleted: state = state

        states: [
            State {
                name: "hover"
                when: buttonArea.containsMouse || button.focus
                PropertyChanges {
                    target: buttonRect
                    color: primary
                        ? "blue"
                        : "green"
                }
            },
            State {
                name: "active"
                when: button.enabled
                PropertyChanges {
                    target: buttonRect
                    color: primary
                        ? "pink"
                        : "brown"
                }
            },
            State {
                name: "disabled"
                when: !button.enabled
                PropertyChanges {
                    target: buttonRect
                    color: "yellow"
                }
            }
        ]
    }

    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        //onClicked: doClick()
        cursorShape: Qt.PointingHandCursor
    }

    //Keys.enabled: button.visible
    //Keys.onSpacePressed: doClick()
    //Keys.onEnterPressed: Keys.onReturnPressed(event)
    //Keys.onReturnPressed: doClick()
}