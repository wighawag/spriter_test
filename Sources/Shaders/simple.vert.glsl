#ifdef GL_ES
precision highp float;
#endif

attribute vec2 pos;
attribute vec2 tex;

varying vec2 texCoords;

uniform mat4 MVP;

void kore() {
	texCoords = tex;
	gl_Position = MVP * vec4(pos, 0.0, 1.0);
}
