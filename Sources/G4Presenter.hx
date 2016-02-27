import imagesheet.ImageSheet;
import kha.Framebuffer;
import spriterkha.SpriterG4;

import kha.Assets;

import kha.Font;
import kha.Scheduler;

import kha.Color;
import kha.Shaders;
import kha.graphics4.PipelineState;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.math.FastMatrix4;
import kha.math.FastVector3;
import kha.graphics4.TextureUnit;

@:access(spriter)
class G4Presenter implements Presenter{
	
	var lastRenderTime : Float;
	var drawFps : Float = 0;
	var imageSheet : ImageSheet;
	var loadedFont : Font;
	var model : Test;
	
	var vertexBuffer:VertexBuffer;
	var indexBuffer:IndexBuffer;
	var pipeline:PipelineState;

	var mvp:FastMatrix4;
	var mvpID:ConstantLocation;
	var textureUnit : TextureUnit;

	
	public function new(model : Test, imageSheet : ImageSheet){
		this.imageSheet = imageSheet;
		lastRenderTime = 0;
		loadedFont = Assets.fonts.arial;
		this.model = model;
		
		var structure = new VertexStructure();
		structure.add("pos", VertexData.Float2);
		structure.add("tex", VertexData.Float2);

		pipeline = new PipelineState();
		pipeline.inputLayout = [structure];
		pipeline.fragmentShader = Shaders.simple_frag;
		pipeline.vertexShader = Shaders.simple_vert;

		// pipeline.depthWrite = true;
		// pipeline.depthMode = CompareMode.Less;
		pipeline.compile();

		mvpID = pipeline.getConstantLocation("MVP");
		textureUnit = pipeline.getTextureUnit("texture");

		
		vertexBuffer = new VertexBuffer(
			1000,
			structure,
			Usage.DynamicUsage 
		);
		//TODO remove
		// var vData = vertexBuffer.lock();
		// vData.set(0,0);
		// vData.set(1,0);
		// vData.set(2,0);
		// vData.set(3,0);
		
		// vData.set(4,50);
		// vData.set(5,0);
		// vData.set(6,0);
		// vData.set(7,0);
		
		// vData.set(8,0);
		// vData.set(9,50);
		// vData.set(10,0);
		// vData.set(11,0);
		
		// vData.set(12,50);
		// vData.set(13,50);
		// vData.set(14,0);
		// vData.set(15,0);
		 
		// vertexBuffer.unlock();
		
		indexBuffer = new IndexBuffer(
			1000,
			Usage.DynamicUsage 
		);
		//TODO remove:
		// var iData = indexBuffer.lock();
		// iData[0] = 0;
		// iData[1] = 1;
		// iData[2] = 2;
		// iData[3] = 2;
		// iData[4] = 1;
		// iData[5] = 3;
		// indexBuffer.unlock();
		
	}
		
	public function render(framebuffer: Framebuffer): Void {
		var now = Scheduler.time();
		var delta = now - lastRenderTime;
		lastRenderTime = now;
		
		drawFps = Std.int(1.0 / delta);
		
		var g = framebuffer.g4;
		g.begin();
		g.clear(Color.fromFloats(0.3, 0.3, 0.3), 1.0);

		g.setPipeline(pipeline);
		
		mvp = FastMatrix4.orthogonalProjection(0, framebuffer.width, framebuffer.height, 0 , 0.0, 100.0);
		g.setMatrix(mvpID, mvp);
		g.setTexture(textureUnit, imageSheet.image);
		
		var vData = vertexBuffer.lock();
		var iData = indexBuffer.lock();
		
		//vertexBuffer : VertexBuffer, vertexStart : Int, vertexSize : Int, posStride : Int, texStride : Int, indexBuffer : IndexBuffer, indexStart : Int,  imageSheet : ImageSheet, entity : EntityInstance, x : Float, y : Float
		SpriterG4.drawSpriter(vData,0,4,0,2,iData,0,-1,imageSheet,model.currentEntity,framebuffer.width/2,framebuffer.height);
		
		vertexBuffer.unlock();
		indexBuffer.unlock();

		g.setVertexBuffer(vertexBuffer);
		g.setIndexBuffer(indexBuffer);

		g.drawIndexedVertices();

		g.end();
		
	}
	
	
}