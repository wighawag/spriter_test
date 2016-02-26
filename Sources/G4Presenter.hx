import imagesheet.ImageSheet;
import kha.Framebuffer;
using spriterkha.SpriterG4;

import kha.Assets;

import kha.Font;
import kha.Scheduler;

@:access(spriter)
class G4Presenter implements Presenter{
	
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
		
		var g4 = framebuffer.g4;
		
		//TODO
		
	}
	
	
}