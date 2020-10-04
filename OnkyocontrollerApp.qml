//
// Onkyoesp v1.1.0 by Oepi-Loepi
//

import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0;
import ScreenStateController 1.0
import FileIO 1.0
import QtWebSockets 1.1

App {

	id: onkyocontrollerApp

	property url tileUrl : "OnkyocontrollerTile.qml"
	property url thumbnailIcon: "qrc:/tsc/onkyo-resize.png"
	property url onkyocontrollerConfigScreenUrl : "OnkyocontrollerConfigScreen.qml"
	property OnkyocontrollerConfigScreen onkyocontrollerConfigScreen
	property url onkyocontrollerScreenUrl : "OnkyocontrollerScreen.qml"
	property OnkyocontrollerScreen onkyocontrollerScreen

	property string	statnrHEX
	property string actualArtist
	property string actualTitle
	property string oldTitle
	property string oldArtist

	property string actualPlaytime
	property string actualSelector : "2B"
	property string actualPower
	property string actualStation
	property string actualPreset
	property string actualTuner
	property string actualVolume

	property bool actualArtistLong : false
	property bool actualTitleLong : false
	property bool actSelector : false
	property bool actPower : false

	property bool actFM : false
	property bool actPhono : false
	property bool actAux : false
	property bool actTV : false
	property bool actBT : false
	property bool actAirplay : false
	property bool actNET : true

	property bool showButtons : false
	property bool enableSleep : false
	
	property bool domMode : false
	
	property bool webSocketactive : true
	property bool socketerror : false

	property string socketURL : "ws://192.168.10.65:81"
	property string espIP : "192.168.10.65"

	property string socketMessage : ""
	property string socketERRMessage : "ESP<->Toon error"
	property string onkyoERRMessage : "Onkyo<->ESP error"

	property string onkyoURL : "http://192.168.10.241"
	property string domoticzURL1 : "http://192.168.10.185:8080"
	property string idxOnOff : "94"
	property string idxMS : "92"
	property string idxCOM : "95"
	property string idxTitle : "101"
	property string idxPT : "102"
	property string idxArtist : "104"
	property string idxAlbum : "103"

	property string imageURL : onkyoURL + "/album_art.cgi"

	property string tmpSleep : "No"
	property string tmpDOM : "No"

	property variant onkyocontrollerSettingsJson : {
		'socketURL': "",
		'espIP': "",
		'domoticzURL1': "",
		'onkyoURL': "",
		'idxOnOff': "",
		'idxMS': "",
		'idxCOM': "",
		'iidxTitle': "",
		'idxPT': "",
		'idxArtist': "",
		'idxAlbum': "",
		'tmpDOM': "",
		'tmpSleep': ""
	}


/////////////////////////////////ESP SOCKET OPTION///////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////
   	WebSocket {
        	id: socket
        	url: socketURL 
       		onTextMessageReceived: {
			socketERRMessage = "ESP<->Toon connected"
			onkyoERRMessage = "Onkyo<->ESP error"
 	    		writewebsockettovars(message)
			socketMessage = message
        	}
        	onStatusChanged: 
		if (socket.status == WebSocket.Error) {
                     socketerror = true
		     socketERRMessage = "ESP<->Toon error"
                } else if (socket.status == WebSocket.Open) {
                     socket.sendTextMessage("This is Toon for ESP controller")
		     socketERRMessage = "ESP<->Toon connected"
                } else if (socket.status == WebSocket.Closed) {
		     socketERRMessage = "ESP<->Toon closed"
                }
        	active:!domMode & webSocketactive
    	}

	function sendwebsock(socketmessage) {
		socket.sendTextMessage(socketmessage)
	}


	function writewebsockettovars(webmessage) {
	try {
		var JsonObject4= JSON.parse(webmessage);

		actualPower = JsonObject4['power1'];

		if ((actualPower == '01') || (actualPower == "01")) {
			actPower = true;
		}else{
			actPower = false;
			actualTitle = '';
			actualArtist = '';
		}

		actualSelector = JsonObject4['input'];
		onkyoURL = "http://" + JsonObject4['ip'];
		actualTitle = JsonObject4['title'];
		actualArtist = JsonObject4['artist'];
		actualPlaytime = JsonObject4['timestamp'];
		actualVolume = JsonObject4['volume'];
		actualPreset = JsonObject4['preset'];
		actualTuner = JsonObject4['tuner'];
		onkyoERRMessage = JsonObject4['status'];

		//24 = radio, 22 phono, 2d airplay, 2e bt, 2b netwerk, 12 tv
		actFM = false;
		actPhono = false;
		actAux = false;
		actTV = false;
		actBT = false;
		actAirplay = false;
		actNET = false;

		switch (actualSelector) {

			case "24": {
				actFM=true;
				break;
			}
			case "22": {
				actPhono=true;
				actualTitle = "";
				actualArtist = "";
				break;
			}
			case "2D": {
				actAirplay=true;
				break;
			}
			case "2E": {
				actBT=true;
				break;
			}
			case "2B": {
				actNET=true;
				break;
				}
			case '2B': {
				actNET=true;
				break;
				}

			case "12": {
				actTV=true;
				actualTitle = "";
				actualArtist = "";
				break;
			}
			 case "03": {
				actAUX=true;
				actualTitle = "";
				actualArtist = "";
				break;
			}
			default: {
				break;
			}
		}

		if (actualTitle.length > 22) {
			actualTitleLong = true;
		}else{
			actualTitleLong = false;
		}

		if (actualArtist.length > 22) {
			actualArtistLong = true;
		}else{
			actualArtistLong = false;
		}


	} catch(e) {
	}

	}

/////////////////////////////////DOMOTICZ OPTION///////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////

	function readOnkyoState() {

		var xmlhttp4 = new XMLHttpRequest();
		xmlhttp4.onreadystatechange=function() {
			if (xmlhttp4.readyState == XMLHttpRequest.DONE) {
				if (xmlhttp4.status == 200) {
						var JsonString4 = xmlhttp4.responseText;
        					var JsonObject4= JSON.parse(JsonString4);
						actualPower = JsonObject4.result[0].Data;
						if (actualPower == 'On') {
							actPower = true;
						}else{
							actPower = false;
							actualTitle = "";
							actualArtist = "";
						}
				}
			}
		}
		xmlhttp4.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxOnOff);
		xmlhttp4.send();

		if (actPower){
			var xmlhttp5 = new XMLHttpRequest();
			xmlhttp5.onreadystatechange=function() {
				if (xmlhttp5.readyState == XMLHttpRequest.DONE) {
					if (xmlhttp5.status == 200) {
							var JsonString5 = xmlhttp5.responseText;
        						var JsonObject5= JSON.parse(JsonString5);
							actualSelector = JsonObject5.result[0].Data;

							actFM = false;
							actPhono = false;
							actAux = false;
							actTV = false;
							actBT = false;
							actAirplay = false;
							actNET = false;
							
							switch (actualSelector) {
								case "Set Level: 80 %": {
									actFM=true;
									break;
								}
								case "Set Level: 110 %": {
									actPhono=true;
									actualTitle = "";
									actualArtist = "";
									break;
								}
								case "Set Level: 190 %": {
									actAirplay=true;
									break;
								}
								case "Set Level: 130 %": {
									actBT=true;
									break;
								}
								case "Set Level: 120 %": {
									actNET=true;
									break;
									}

								case "Set Level: 100 %": {
									actTV=true;
									actualTitle = "";
									actualArtist = "";
									break;
								}
								 case "Set Level: 60 %": {
									actAUX=true;
									actualTitle = "";
									actualArtist = "";
									break;
								}
								default: {
									break;
								}
							}
					}
				}
			}
			xmlhttp5.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxMS);
			xmlhttp5.send();

				var xmlhttp = new XMLHttpRequest();
				xmlhttp.onreadystatechange=function() {
					if (xmlhttp.readyState == XMLHttpRequest.DONE) {
						if (xmlhttp.status == 200) {
								var JsonString = xmlhttp.responseText;
        							var JsonObject= JSON.parse(JsonString);
        							actualTitle = JsonObject.result[0].Data;
								if (actualTitle.length > 22) {
									actualTitleLong = true;
								}else{
									actualTitleLong = false;
								}
						}
					}
				}

				xmlhttp.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxTitle);
				xmlhttp.send();

				var xmlhttp2 = new XMLHttpRequest();
				xmlhttp2.onreadystatechange=function() {
					if (xmlhttp2.readyState == XMLHttpRequest.DONE) {
						if (xmlhttp2.status == 200) {
								var JsonString2 = xmlhttp2.responseText;
        							var JsonObject2= JSON.parse(JsonString2);
								actualArtist = JsonObject2.result[0].Data;
								if (actualArtist.length > 22) {
									actualArtistLong = true;
								}else{
									actualArtistLong = false;
								}
						}
					}
				}
				xmlhttp2.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxArtist);
				xmlhttp2.send();

				var xmlhttp3 = new XMLHttpRequest();
				xmlhttp3.onreadystatechange=function() {
					if (xmlhttp3.readyState == XMLHttpRequest.DONE) {
						if (xmlhttp3.status == 200) {
								var JsonString3 = xmlhttp3.responseText;
        							var JsonObject3= JSON.parse(JsonString3);
								actualPlaytime = JsonObject3.result[0].Data;
						}
					}
				}
				xmlhttp3.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxPT);
				xmlhttp3.send();

				var xmlhttp4 = new XMLHttpRequest();
				xmlhttp4.onreadystatechange=function() {
					if (xmlhttp4.readyState == XMLHttpRequest.DONE) {
						if (xmlhttp4.status == 200) {
								var JsonString4 = xmlhttp4.responseText;
        							var JsonObject4= JSON.parse(JsonString4);
        							actualVolume = JsonObject4.result[0].Level;
						}
					}
				}

				xmlhttp4.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxCOM);
				xmlhttp4.send();

				
				//in BT mode the title is in the album and the title is the source.
				if (actBT){
					var xmlhttp5 = new XMLHttpRequest();
					xmlhttp5.onreadystatechange=function() {
						if (xmlhttp5.readyState == XMLHttpRequest.DONE) {
							if (xmlhttp5.status == 200) {
									var JsonString5 = xmlhttp5.responseText;
        								var JsonObject5= JSON.parse(JsonString5);
        								actualTitle = JsonObject5.result[0].Data;
							}
						}
					}
					xmlhttp5.open("GET", domoticzURL1 + "/json.htm?type=devices&rid=" + idxAlbum);
					xmlhttp5.send();
				}
		}
	}

	function simpleSynchronous(request) {
		var xmlhttp = new XMLHttpRequest();
		xmlhttp.open("GET", request, true);
		xmlhttp.timeout = 1500;
		xmlhttp.send();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					if (typeof(functie) !== 'undefined') {
						functie(parameter);
					}
				}
			}
		}
	}
	

////////////////////////////////////////GENERAL////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

	FileIO {
		id: onkyocontrollerSettingsFile
		source: "file:///mnt/data/tsc/onkyocontroller_userSettings.json"
 	}


	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("Onkyo"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", onkyocontrollerConfigScreenUrl, this, "onkyocontrollerConfigScreen");
		registry.registerWidget("screen", onkyocontrollerScreenUrl, this, "onkyocontrollerScreen");
	}
	
	Connections {
		target: screenStateController
		onScreenStateChanged: {
			if (screenStateController.screenState == ScreenStateController.ScreenColorDimmed || screenStateController.screenState == ScreenStateController.ScreenOff) {
				onkyoPlayInfoTimer.stop();
				onkyoPlayInfoTimer.interval = 10000;
				onkyoPlayInfoTimer.start();
			} else {
				onkyoPlayInfoTimer.stop();
				onkyoPlayInfoTimer.interval = 5000;
				onkyoPlayInfoTimer.start();
			}
		}
	}


	Timer {
		id:socketreconnectTimer
		interval: 60000
		triggeredOnStart: true
		running: !domMode
		repeat: true
		onTriggered: {webSocketactive = false; webSocketactive = true}
	}

	Timer {
		id: onkyoPlayInfoTimer
		interval: 5000
		triggeredOnStart: true
		running: domMode
		repeat: true
		onTriggered: readOnkyoState()
	}
	
	Timer {
		id:imageRefreshTimer
		interval: 2000
		running: (actualTitle != oldTitle)
		onTriggered: imageURL =onkyoURL + "/album_art.cgi?" +  Math.random()
	}
	
	Component.onCompleted: {
		try {
			onkyocontrollerSettingsJson = JSON.parse(onkyocontrollerSettingsFile.read());
			if (onkyocontrollerSettingsJson['tmpSleep'] == "Yes") {
				enableSleep = true
			} else {
				enableSleep = false
			}
			
			if (onkyocontrollerSettingsJson['tmpDOM'] == "Yes") {
				domMode= true
			} else {
				domMode = false
			}

			socketURL = onkyocontrollerSettingsJson['socketURL'];
			espIP = onkyocontrollerSettingsJson['espIP'];

			domoticzURL1 = onkyocontrollerSettingsJson['domoticzURL1'];
			onkyoURL = onkyocontrollerSettingsJson['onkyoURL'];


			idxOnOff = onkyocontrollerSettingsJson['idxOnOff'];
			idxMS = onkyocontrollerSettingsJson['idxMS'];
			idxCOM = onkyocontrollerSettingsJson['idxCOM'];
			idxTitle = onkyocontrollerSettingsJson['idxTitle'];
			idxPT = onkyocontrollerSettingsJson['idxPT'];
			idxArtist = onkyocontrollerSettingsJson['idxArtist'];
			idxAlbum = onkyocontrollerSettingsJson['idxAlbum'];

		} catch(e) {
		}
	}


	function saveSettings() {

		if (enableSleep == true) {
			tmpSleep = "Yes";
		} else {
			tmpSleep = "No";
		}
		
		if (domMode == true) {
			tmpDOM = "Yes";
		} else {
			tmpDOM = "No";
		}

 		var setJson = {
		
			"socketURL" : socketURL,
			"espIP" : espIP,

			"domoticzURL1" : domoticzURL1,
			"onkyoURL" : onkyoURL,

			"idxOnOff" : idxOnOff,
			"idxMS" : idxMS,
			"idxCOM" : idxCOM,
			"idxTitle" : idxTitle,
			"idxPT" : idxPT,
			"idxArtist" : idxArtist,
			"idxAlbum" : idxAlbum,

			"tmpDOM" : tmpDOM,
			"tmpSleep" : tmpSleep
		}
  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/onkyocontroller_userSettings.json");
   		doc3.send(JSON.stringify(setJson));
	}
}
