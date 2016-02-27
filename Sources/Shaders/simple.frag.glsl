#ifdef GL_ES
precision mediump float;
#endif

uniform sampler2D texture;

varying vec2 texCoords;

void kore() {
	gl_FragColor = texture2D(texture, texCoords);
}
