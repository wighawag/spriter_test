import imagesheet.ImageSheet;
import kha.Framebuffer;
using spriterkha.SpriterG2;

import kha.math.FastMatrix4;
import kha.math.FastMatrix3;
import kha.math.FastVector4;
import kha.math.FastVector3;
import kha.math.FastVector2;

import kha.Assets;

import kha.Font;
import kha.Scheduler;

@:access(spriter)
class G2Presenter implements Presenter{
	
	var lastRenderTime : Float;
	var drawFps : Float = 0;
	var imageSheet : ImageSheet;
	var loadedFont : Font;
	var model : Test;
	
	public function new(model : Test, imageSheet : ImageSheet){
		this.imageSheet = imageSheet;
		lastRenderTime = 0;
		loadedFont = Assets.fonts.arial;
		this.model = model;
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
		g2.drawSpriter(imageSheet, model.currentEntity,framebuffer.width/2,framebuffer.height);
		
		g2.transformation = FastMatrix3.identity();
		g2.font = loadedFont;
		g2.fontSize = 12;
		g2.color = kha.Color.White;
		//var w = loadedFont.width(12, text);
		var h = loadedFont.height(12);
		
		
		g2.drawString("FPS (Update) = " + model.updateFps, framebuffer.width - 200, 10);
		g2.drawString("FPS (Draw) =   " + drawFps, framebuffer.width - 200, 10 + h);
		//g2.drawString(instructions, 10, 10);
		g2.drawString("" + model.currentEntity.entity.name + " : " + model.currentEntity.currentAnimationName, 10, framebuffer.height - 50);
		//g2.drawString(metadata, framebuffer.width - 300, framebuffer.height * 0.5);
		drawMetadata(g2,framebuffer.width - 300, framebuffer.height * 0.5, h);
		g2.end();
	}
	
	function drawMetadata(g2 : kha.graphics2.Graphics, x : Float, y : Float, sep : Float){
		 g2.drawString("Variables:",x, y);
		 var height = sep;
		 var values = model.getVarValues();
		 for(line in values){
			g2.drawString(line,x, y + height);
			height += sep;	 
		 }
		 g2.drawString("Tags:",x, y + height);
		 height += sep;	 
		 var values = model.getTagValues();
		 for(line in values){
			g2.drawString(line,x, y + height);
			height += sep;	 
		 }
	}
}