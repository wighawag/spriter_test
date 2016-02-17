package;

import kha.Framebuffer;
import kha.Assets;
import kha.Scheduler;
import kha.System;
import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import kha.math.FastVector4;
import kha.math.FastVector3;
import kha.math.FastVector2;
import kha.input.Keyboard;

import spriter.Spriter;
import spriter.EntityInstance;

import kha.Key;
import kha.Font;
using spriterkha.SpriterG2;

import imagesheet.ImageSheet;

@:access(spriter)
class Test {
	var lastTime : Float;
	var lastRenderTime : Float;
	
	var entities : Array<EntityInstance>;
	var currentEntity : EntityInstance;
	var imageSheet : ImageSheet;
	
	var updateFps : Float = 0;
	var drawFps : Float = 0;
	
	var loadedFont : Font;
	
	#if HXCPP_TELEMETRY 
	var hxt : hxtelemetry.HxTelemetry;
	#end
	
	public function new() {
		entities = new Array();
		currentEntity = null;
		Assets.loadEverything(loadingFinished);
	}

	function loadingFinished() {
		loadedFont = Assets.fonts.arial;
		lastTime = 0;
		lastRenderTime = 0;
		
		imageSheet = ImageSheet.fromTexturePackerJsonArray(Assets.blobs.player_sheet_json.toString());
		var spriter = Spriter.parseScml(Assets.blobs.player_scml.toString());
		entities.push(spriter.createEntity("Player"));
		
		var spriterPlus = Spriter.parseScml(Assets.blobs.player_006_scml.toString());
		entities.push(spriterPlus.createEntity("Player"));
		entities.push(spriterPlus.createEntity("TestEntity"));
		
 		var spriterSquare = Spriter.parseScml(Assets.blobs.squares_scml.toString());
		entities.push(spriterSquare.createEntity("squares"));
		
		currentEntity = entities[0];
		//switchEntity();
		//currentEntity.play(getNextAnimation());
		//currentEntity.step(100);
		
		// switchEntity();
		// switchEntity();
		// currentEntity.play("walk");
		// currentEntity.step(910);
		currentEntity.eventTriggered = eventTriggered;
		#if HXCPP_TELEMETRY
		hxt = new hxtelemetry.HxTelemetry();
		trace("hxt : ",hxt);
		#end
		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
		
		var keyboard = Keyboard.get();
		keyboard.notify(keyDown, keyUp);
	}
	
	function keyDown(key : Key, c : String){
		switch(key){
			case ENTER: switchEntity();
			case CHAR: 
				switch(c){
					case " " : currentEntity.play(getNextAnimation());
					case "p" : changeAnimationSpeed(0.2);
					case "o" : changeAnimationSpeed(-0.2);
					case "r" : currentEntity.speed = - currentEntity.speed;
					case "x" : currentEntity.play(currentEntity.currentAnimationName); 
					case "t" : currentEntity.transition(getNextAnimation(), 1);
					case "c" : nextCharacterMap();
				} 			
			default:
		}
	}
	
	function keyUp(key : Key, c : String){
		
	}
	
	private function getNextAnimation() : String
	{
		var animations = currentEntity.entity.animations;
		var index = animations.indexOf(currentEntity._currentAnimation);
		++index;
		if (index >= animations.length) index = 0;
		return animations[index].name;
	}

	private function changeAnimationSpeed(delta : Float)
	{
		var maxSpeed = 5;
		var speed = currentEntity.speed + delta;
		speed = Math.abs(speed) < maxSpeed ? speed : maxSpeed * (Math.abs(speed) / speed);
		currentEntity.speed = speed;
	}
		
	function switchEntity(){
		currentEntity.eventTriggered = null;
		var index = entities.indexOf(currentEntity);
		++index;
		if (index >= entities.length) index = 0;
		currentEntity = entities[index];
		currentEntity.eventTriggered = eventTriggered;
	}
	
	function nextCharacterMap()
	{
		//TODO ? define the api first
		// var maps = currentEntity.entity.characterMaps;
		// if (maps == null || maps.length == 0) return;
		// var charMap = currentEntity.characterMap;
		// if (charMap == null) charMap = maps[0]; 
		// else
		// {
		// 	var index = charMap.id + 1;
		// 	if (index >= maps.length) charMap = null;
		// 	else charMap = maps[index];
		// }

		// currentEntity.characterMap = charMap;
	}
	
	function eventTriggered(event : String){
		trace(event);
	}
	
	public function render(framebuffer: Framebuffer): Void {
		var now = Scheduler.time();
		var delta = now - lastRenderTime;
		lastRenderTime = now;
		
		drawFps = Std.int(1.0 / delta);
		
		var g2 = framebuffer.g2;
		g2.begin();
		g2.clear();
		g2.transformation = FastMatrix3.identity();
		g2.drawRect(0, 0, 10, 10);
		
		//g2.drawDebugSpriter(currentEntity,framebuffer.width/2,framebuffer.height);
		g2.drawSpriter(imageSheet, currentEntity,framebuffer.width/2,framebuffer.height);
		
		g2.transformation = FastMatrix3.identity();
		g2.font = loadedFont;
		g2.fontSize = 12;
		g2.color = kha.Color.White;
		//var w = loadedFont.width(12, text);
		var h = loadedFont.height(12);
		
		
		g2.drawString("FPS (Update) = " + updateFps, framebuffer.width - 200, 10);
		g2.drawString("FPS (Draw) =   " + drawFps, framebuffer.width - 200, 10 + h);
		//g2.drawString(instructions, 10, 10);
		g2.drawString("" + currentEntity.entity.name + " : " + currentEntity.currentAnimationName, 10, framebuffer.height - 50);
		//g2.drawString(metadata, framebuffer.width - 300, framebuffer.height * 0.5);
		drawMetadata(g2,framebuffer.width - 300, framebuffer.height * 0.5, h);
		g2.end();
	}
	
	function drawMetadata(g2 : kha.graphics2.Graphics, x : Float, y : Float, sep : Float){
		 g2.drawString("Variables:",x, y);
		 var height = sep;
		 var values = getVarValues();
		 for(line in values){
			g2.drawString(line,x, y + height);
			height += sep;	 
		 }
		 g2.drawString("Tags:",x, y + height);
		 height += sep;	 
		 var values = getTagValues();
		 for(line in values){
			g2.drawString(line,x, y + height);
			height += sep;	 
		 }
	}
	
	function getVarValues() : Array<String>
	{
		
		var strings : Array<String> = [];
		for(i in 0...currentEntity.animationVars.strings.numElements)
		{
			var key = currentEntity.animationVars.strings.getKey(i);
			var value = currentEntity.animationVars.strings.get(key);
			strings.push(key + " = "  + value);
		}
		for(i in 0...currentEntity.animationVars.ints.numElements)
		{
			var key = currentEntity.animationVars.ints.getKey(i);
			var value = currentEntity.animationVars.ints.get(key);
			strings.push(key + " = "  + value);
		}
		for(i in 0...currentEntity.animationVars.floats.numElements)
		{
			var key = currentEntity.animationVars.floats.getKey(i);
			var value = currentEntity.animationVars.floats.get(key);
			strings.push(key + " = "  + value);
		}
		
		for(i in 0...currentEntity.objectVars.strings.names.numElements)
		{
			var name = currentEntity.objectVars.strings.names.getKey(i);
			var index = currentEntity.objectVars.strings.names.get(name);
			var length = currentEntity.objectVars.strings.arrays[index];
			for(j in 0...length){
				var subIndex = currentEntity.objectVars.strings.arrays[1+index+j];
				var subName = currentEntity.objectVars.strings.subNames[subIndex];
				var value = currentEntity.objectVars.strings.get(name, subName);
				strings.push(name + "." + subName + " = "  + value);
			}
		}
		for(i in 0...currentEntity.objectVars.floats.names.numElements)
		{
			var name = currentEntity.objectVars.floats.names.getKey(i);
			var index = currentEntity.objectVars.floats.names.get(name);
			var length = currentEntity.objectVars.floats.arrays[index];
			for(j in 0...length){
				var subIndex = currentEntity.objectVars.floats.arrays[1+index+j];
				var subName = currentEntity.objectVars.floats.subNames[subIndex];
				var value = currentEntity.objectVars.floats.get(name, subName);
				strings.push(name + "." + subName + " = "  + value);
			}
		}
		for(i in 0...currentEntity.objectVars.ints.names.numElements)
		{
			var name = currentEntity.objectVars.ints.names.getKey(i);
			var index = currentEntity.objectVars.ints.names.get(name);
			var length = currentEntity.objectVars.ints.arrays[index];
			for(j in 0...length){
				var subIndex = currentEntity.objectVars.ints.arrays[1+index+j];
				var subName = currentEntity.objectVars.ints.subNames[subIndex];
				var value = currentEntity.objectVars.ints.get(name, subName);
				strings.push(name + "." + subName + " = "  + value);
			}
		}
		

		return strings;
	}


	function getTagValues() : Array<String>
	{
		var strings = new Array<String>();
		for(i in 0...currentEntity.animationTags.numElements){
			strings.push(currentEntity.animationTags.get(i));
		} 
		
		for(i in 0...currentEntity.objectTags.names.numElements){
			var name = currentEntity.objectTags.names.getKey(i);
			var index = currentEntity.objectTags.names.get(name);
			var length = currentEntity.objectTags.arrays[index];
			for(j in 0...length){
				var subIndex = currentEntity.objectTags.arrays[1+index+j];
				var subName = currentEntity.objectTags.subNames[subIndex];
				strings.push(name + "." + subName);
			}
			
		}

		return strings;
	}
	
	public function update(): Void {
		var now = Scheduler.time();
		var delta = now - lastTime;
		lastTime = now;
		
		updateFps = Std.int(1.0 / delta);
		
		//currentEntity.step(0);
		currentEntity.step(delta);
		
		#if HXCPP_TELEMETRY
		hxt.advance_frame();
		#end
	}
}