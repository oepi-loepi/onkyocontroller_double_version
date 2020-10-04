import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;

Screen {
	id: onkyocontrollerConfigScreen
	screenTitle: "Controller for Onkyo & Pioneer Setup"


	function saveespURL(text) {
		if (text) {
			app.socketURL = "ws://" + text + ":81"
			app.espIP = text;
		}
	}


	function saveDomoticzURL1(text) {
		if (text) {
			app.domoticzURL1 = text;
		}
	}

	function saveOnkyoURL(text) {
		if (text) {
			app.onkyoURL = text;
		}
	}


	function saveidxOnOff(text) {
		if (text) {
			app.idxOnOff = text;
		}
	}

	function saveidxMS(text) {
		if (text) {
			app.idxMS = text;
		}
	}

	function saveidxCOM(text) {
		if (text) {
			app.idxCOM = text;
		}
	}

	function saveidxTitle(text) {
		if (text) {
			app.idxTitle = text;
		}
	}

	function saveidxPT(text) {
		if (text) {
			app.idxPT = text;
		}
	}

	function saveidxArtist(text) {
		if (text) {
			app.idxArtist = text;
		}
	}

	function saveidxAlbum(text) {
		if (text) {
			app.idxAlbum = text;
		}
	}

	onShown: {
		enableDomMode.isSwitchedOn = app.domMode;
		espIP.inputText = app.espIP;
		domoticzURL1.inputText = app.domoticzURL1;
		onkyoURL.inputText = app.onkyoURL;
		idxOnOff.inputText = app.idxOnOff;
		idxMS.inputText = app.idxMS;
		idxCOM.inputText = app.idxCOM;
		idxTitle.inputText = app.idxTitle;
		idxPT.inputText = app.idxPT;
		idxArtist.inputText = app.idxArtist;
		idxAlbum.inputText = app.idxAlbum;
		enableSleepToggle.isSwitchedOn = app.enableSleep;

		addCustomTopRightButton("Save");
	}

	onCustomButtonClicked: {
		app.saveSettings();
		hide();
	}

	Text {
		id: domModeTXT
		width:  160
		text: "Domoticz Mode, requires Domoticz"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: parent.left
			leftMargin: 20
			top:parent.top		
		}
	}

	OnOffToggle {
		id: enableDomMode
		height:  30
		leftIsSwitchedOn: true
		anchors {
			left: domModeTXT.right
			leftMargin: isNxt ? 200 : 145
			top: domModeTXT.top		
		}

		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.domMode = true;
			} else {
				app.domMode = false;
			}
		}
	}

	Text {
		id: domModeTXT2
		width:  160
		text: "ESP Socket Mode, required flashed Wemos D1 Mini"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: enableDomMode.right
			leftMargin: isNxt ? 65 : 25
			top: domModeTXT.top		
		}
	}

	Text {
		id: myLabel
		text: "IP adress of  esp8266 controller (example:192.168.10.65)"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: parent.left
			top: domModeTXT.bottom		
			leftMargin: 20
			topMargin: 10
		}
		visible: !app.domMode
	}

	EditTextLabel4421 {
		id: espIP
		width: parent.width - 40
		height: 35
		leftTextAvailableWidth: 300
		leftText: "esp8266 IP"

		anchors {
			left: myLabel.left
			top: myLabel.bottom
			topMargin: 10
		}

		onClicked: {
			qkeyboard.open("IP adress of esp8266 controller", espIP.inputText, saveespURL)
		}
		visible: !app.domMode
	}




	Text {
		id: myLabel88
		text: "URL to Domoticz (example: http://192.168.10.185:8080)"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: parent.left
			top: domModeTXT.bottom		
			leftMargin: 20
			topMargin: 10
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: domoticzURL1
		width: parent.width - 40
		height: 35
		leftTextAvailableWidth: 300
		leftText: "Domoticz URL"

		anchors {
			left: myLabel.left
			top: myLabel.bottom
			topMargin: 10
		}

		onClicked: {
			qkeyboard.open("URL to Domoticz incl. Port", domoticzURL1.inputText, saveDomoticzURL1)
		}
		visible: app.domMode
	}


	Text {
		id: myLabel66
		text: "URL of Onkyo/Pioneer Receiver (example: http://192.168.10.241)"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: parent.left
			top: domoticzURL1.bottom			
			leftMargin: 20
			topMargin: 10
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: onkyoURL
		width: parent.width - 40
		height: 35
		leftTextAvailableWidth: 300
		leftText: "Onkyo/Pioneer URL"

		anchors {
			left: myLabel.left
			top: myLabel66.bottom
			topMargin: 10
		}

		onClicked: {
			qkeyboard.open("URL of Onkyo receiver", onkyoURL.inputText, saveOnkyoURL)
		}
		visible: app.domMode
	}
////////////////////////////////////////////////////////////////////////

	Text {
		id: showInSleep
		width:  160
		text: "Show in Sleepmode"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: myLabel.left
			top: onkyoURL.bottom
			topMargin: 10
		}
	}

	OnOffToggle {
		id: enableSleepToggle
		height:  30
		anchors.left: showInSleep.right
		anchors.leftMargin: isNxt ? 65 : 30
		anchors.top: showInSleep.top
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.enableSleep = true;
			} else {
				app.enableSleep = false;
			}
		}
	}

////////////////////////////////////////////////////////////////////////

	Text {
		id: myLabel2
		text: "IDX from Domoticz (Devices Tab) :"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name

		anchors {
			left: myLabel.left
			top: enableSleepToggle.bottom
			topMargin: 10
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: idxOnOff
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Master power"

		anchors {
			left: myLabel2.left
			top: myLabel2.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Master Power", idxOnOff.inputText, saveidxOnOff)
		}
		visible: app.domMode
	}


	EditTextLabel4421 {
		id: idxMS
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Master selector"

		anchors {
			left: myLabel2.left
			top: idxOnOff.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Master selector", idxMS.inputText, saveidxMS)
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: idxCOM
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Master Volume"

		anchors {
			left: myLabel2.left
			top: idxMS.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Master Volume", idxCOM.inputText, saveidxCOM)
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: idxTitle
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Title Name"

		anchors {
			left: myLabel2.left
			top: idxCOM.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Title Name", idxTitle.inputText, saveidxTitle)
		}
		visible: app.domMode
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	EditTextLabel4421 {
		id: idxPT
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Playback time"

		anchors {
			left: idxOnOff.right
			top: idxOnOff.top
			leftMargin: 60
		}

		onClicked: {
			qkeyboard.open("Playback time", idxPT.inputText, saveidxPT)
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: idxArtist
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Artist"

		anchors {
			left: idxPT.left
			top: idxPT.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Artist", idxArtist.inputText, saveidxArtist)
		}
		visible: app.domMode
	}

	EditTextLabel4421 {
		id: idxAlbum
		width: (parent.width*0.4) - 40		
		height: 35		
		leftTextAvailableWidth: 200
		leftText: "Album"

		anchors {
			left: idxPT.left
			top: idxArtist.bottom
			topMargin: 6
		}

		onClicked: {
			qkeyboard.open("Album", idxAlbum.inputText, saveidxAlbum)
		}
		visible: app.domMode
	}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


}

