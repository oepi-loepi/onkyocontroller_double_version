import QtQuick 2.1
Item {    
	width: childrenRect.width    
	height: childrenRect.height
        property int maxValue: 5000    
	property int value: 0   
	property int barHeight: 100
	property int barWidth: 100  
	property bool 
	
	dimState: canvas.dimState
        Component.onCompleted: 	redraw(value)    
	onValueChanged: redraw(value)    
	onMaxValueChanged: redraw(value)    
	onDimStateChanged: redraw(value)
	
    function redraw(val) {        
		var count = barGraph.count        
		var num = Math.round(val / (maxValue / count));        
		for (var i = 0; i < 20; i++) {            
			barGraph.itemAt(i).color = i < num ? "#ff0000" : "#aaaaaa"        
		}
	}
    
	Column {        
		spacing: 3        
		Repeater {            
			id: barGraph            
			model: 20            
			Rectangle {                
				width: barWidth          
				height: barHeight/23                
				color: "#aaaaaa"            
			}       
		}        
		rotation: 180    
	} 
}