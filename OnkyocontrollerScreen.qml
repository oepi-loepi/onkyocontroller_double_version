import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;

Screen {
	id: onkyocontrollerScreen
	screenTitle: "Controller for Onkyo & Pioneer"
	property int butHeight : isNxt ? 50: 40

		onShown: {
			addCustomTopRightButton("Instellingen");
		}

		onCustomButtonClicked: {
			if (app.onkyocontrollerConfigScreen) {app.onkyocontrollerConfigScreen.show()};
		}

		NewTextLabel {
			id: powerlabel
			width: isNxt?  1019:795; height: butHeight
			buttonActiveColor: !app.actPower? "grey" : "red"
			buttonHoverColor: "blue"
			buttonDisabledColor: "lightgray"
			enabled : true
			textColor : "black"
			textDisabledColor : "grey"
			buttonText: !app.actPower? "Power": "Power Off"
			anchors {
				left: parent.left
				leftMargin: isNxt? 5:4
            		}
			onClicked: !app.actPower? (app.domMode?	app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=PWR01") : app.sendwebsock("PWR01")):
						  (app.domMode?app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=PWR00") : app.sendwebsock("PWR00"))
		}


		NewTextLabel {
			id: selectorlabel1
			width: isNxt? 140:108 ; height: butHeight
			buttonActiveColor: (app.actAirplay) ? "red" : "grey"
			buttonHoverColor: "green"
			buttonDisabledColor: "lightgray"
			enabled : true
			textColor : "black"
			textDisabledColor : "grey"
			buttonText: "Airplay"
			anchors {
				top: parent.top
				topMargin: isNxt? 50:40
				right: selectorlabel2.left
				rightMargin:  isNxt? 6:5
            		}
			onClicked:app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI2D") : app.sendwebsock("SLI2D")
		}

		NewTextLabel {
			id: selectorlabel2
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: (app.actAirplay) ? "red" : "grey"
			buttonText: "Aux"
			anchors {
				top: selectorlabel1.top
				right: selectorlabel3.left
				rightMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI03"): app.sendwebsock("SLI03")
		}

		NewTextLabel {
			id: selectorlabel3
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: (app.actFM) ? "red" : "grey"
			buttonText: "FM"
			anchors {
				top: selectorlabel1.top
				right: selectorlabel4.left
				rightMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI24"): app.sendwebsock("SLI24")
		}

		NewTextLabel {
			id: selectorlabel4
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: (app.actTV) ? "red" : "grey"
			buttonText: "TV"
			anchors {
				top: selectorlabel1.top
				horizontalCenter: powerlabel.horizontalCenter
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI12"): app.sendwebsock("SLI12")
		}

		NewTextLabel {
			id: selectorlabel5
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: (app.actPhono) ? "red" : "grey"
			buttonText: "Phono"
			anchors {
				top: selectorlabel1.top
				left: selectorlabel4.right
				leftMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI22"): app.sendwebsock("SLI22")
		}

		NewTextLabel {
			id: selectorlabel6
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: (app.actNET) ? "red" : "grey"
			buttonText: "NET"
			anchors {
				top: selectorlabel1.top
				left: selectorlabel5.right
				leftMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI2B"): app.sendwebsock("SLI2B")
		}

		NewTextLabel {
			id: selectorlabel7
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: (app.actBT) ? "red" : "grey"
			buttonText: "BT"
			anchors {
				top: selectorlabel1.top
				left: selectorlabel6.right
				leftMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=SLI2E"): app.sendwebsock("SLI2E")
		}


	//volume control session start here, first you'll find the first button.
		NewTextLabel {
			id: selectorlabel11
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: "grey"
			buttonText: "VOL -"
			anchors {
				bottom: parent.bottom
				bottomMargin: isNxt? 5:4
				right: selectorlabel12.left
				rightMargin: isNxt? 5:4
            		}
			onClicked: 
				app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=MVLDOWN1"): app.sendwebsock("MVLDOWN1")
			visible: app.actPower
		}


		NewTextLabel {
			id: selectorlabel12
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: "grey"
			buttonText: "Prev"
			anchors {
				top: selectorlabel11.top
				right: selectorlabel13.left
				rightMargin: isNxt? 6:5
            		}
			onClicked: {
				app.actFM?
				(app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=PRSDOWN"):app.sendwebsock("PRSDOWN")):
				(app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=NTCTRDN"):app.sendwebsock("NTCTRDN"))
			}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET || app.actFM)
		}


		NewTextLabel {
			id: selectorlabel13
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: "grey"
			buttonText: "Play"
			anchors {
				top: selectorlabel11.top
				right: selectorlabel14.left
				rightMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=NTCPAUSE"): app.sendwebsock("NTCPAUSE")

			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET)

		}


		NewTextLabel {
			id: selectorlabel14
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor:  "grey"
			buttonText: "Stop"
			anchors {
				top: selectorlabel11.top
				horizontalCenter: powerlabel.horizontalCenter
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=NTCSTOP"): app.sendwebsock("NTCSTOP")
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET)
		}

		NewTextLabel {
			id: selectorlabel15
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor: "grey"
			buttonText: "Random"
			anchors {
				top: selectorlabel11.top
				left: selectorlabel14.right
				leftMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=NTCRANDOM"): app.sendwebsock("NTCRANDOM")
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET)
		}


		NewTextLabel {
			id: selectorlabel16
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor:  "grey"
			buttonText: "Next"
			anchors {
				top: selectorlabel11.top
				left: selectorlabel15.right
				leftMargin: isNxt? 6:5
            		}
			onClicked: {
				app.actFM?
				(app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=PRSUP"):app.sendwebsock("PRSUP")):
				(app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=NTCTRUP"):app.sendwebsock("NTCTRUP"))
			}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET || app.actFM)
		}


		NewTextLabel {
			id: selectorlabel17
			width: isNxt? 140:108; height: butHeight
			buttonActiveColor:  "grey"
			buttonText: "Vol +"
			anchors {
				top: selectorlabel11.top
				left: selectorlabel16.right
				leftMargin: isNxt? 6:5
            		}
			onClicked: app.domMode? app.simpleSynchronous(app.domoticzURL1 + "/json.htm?type=command&param=onkyoeiscpcommand&idx=" + app.idxCOM +"&action=MVLUP1"): app.sendwebsock("MVLUP1")
			visible: app.actPower
		}

/////////////////////////////////////////////////////////////////////////////////////// End of playbuttons section
		Image {
			id:albumArt
			width: isNxt? 250:200; height: isNxt? 250:200
			source: app.imageURL
			anchors {
				baseline:  itemText.top
				left: powerlabel.left
				leftMargin: isNxt? 30:24
			}
			visible: app.actPower && (app.actBT || app.actAirplay|| app.actNET)
		}

		Rectangle {
			id: itemText
			color: "transparent"
			width: isNxt? (parent.width - albumArt.width - volBar.barWidth - 120): (parent.width - albumArt.width - volBar.barWidth - 96)
			height: isNxt? 120:96 		
			Text{
				id: iText
				width: parent.width
				font.pixelSize: isNxt? 30:24
				wrapMode: Text.WordWrap
				text: !app.actFM ? app.actualArtist : !app.domMode? ("Radio Preset: " + app.actualPreset) : "Radio Mode"
				font.family: qfont.regular.name
				font.bold: true
				color: "black"
				anchors.bottom: parent.bottom
				anchors.horizontalCenter: parent.horizontalCenter 
				}
			anchors {
				top: selectorlabel1.bottom
				left: albumArt.right
				topMargin: isNxt? 20:16
				leftMargin: isNxt? 30:24
					}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET || app.actFM)
		}

		Rectangle {
			id: titleText
			color: "transparent"
			width: itemText.width 
			height: isNxt? 120:96  		
			Text{
				id: tText
				width: parent.width
				font.pixelSize: isNxt? 30:24
				wrapMode: Text.WordWrap 
				text: !app.actFM? app.actualTitle : !app.domMode? ("Radio Frequency: " + app.actualTuner) : ""
				font.family: qfont.regular.name
				font.bold: true
				color: "black"
				anchors.top: parent.top
				anchors.horizontalCenter: parent.horizontalCenter     		
			}
			anchors {
				top: itemText.bottom
				left: itemText.left
				topMargin: isNxt? 10:8
					}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET || app.actFM)
		}


		Text {
			id:timeText
			width: parent.width
			text: app.actualPlaytime
			font.pixelSize:  isNxt? 22:18
			font.family: qfont.regular.name
			font.bold: false
			color: colors.clockTileColor
			wrapMode: Text.WordWrap
			anchors {
				left: itemText.left
				top: titleText.bottom
				topMargin: isNxt? 30:24
			}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET)
		}

		Text {
			id:socketERRMessage
			width: parent.width
			text: app.socketERRMessage
			font.pixelSize:  isNxt? 12:10
			font.family: qfont.regular.name
			font.bold: false
			color: colors.clockTileColor
			wrapMode: Text.WordWrap
			anchors {
				left: albumArt.left
				top: timeText.top
			}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET)
		}

		Text {
			id:onkyoERRMessage
			width: parent.width
			text: app.onkyoERRMessage
			font.pixelSize:  isNxt? 12:10
			font.family: qfont.regular.name
			font.bold: false
			color: colors.clockTileColor
			wrapMode: Text.WordWrap
			anchors {
				left: albumArt.left
				top: socketERRMessage.bottom
				topMargin: isNxt? 5:4
			}
			visible: app.actPower && (app.actBT || app.actAirplay || app.actNET)
		}


		NewBargraph {
			id: volBar
			maxValue :100
			value: app.actualVolume        
			barHeight : isNxt? 210:170
			barWidth : isNxt? 50:40
			anchors {
				top:  itemText.top
				right: selectorlabel7.right
				rightMargin : 30
			}
			visible: app.actPower
		} 
	
	}

