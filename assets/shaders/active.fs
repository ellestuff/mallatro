extern float progress;
extern float time;
extern vec4 uie_details;
extern vec2 mall_active;
extern number uie_scale;
extern number uie_rot;

vec3 getColour(int id) { // for once the shader is working
	vec3 colours[3];
	
	colours[0] = vec3(55./255.,66./255.,68./255.);		// G.C.BLACK
	colours[1] = vec3(75./255.,194./255.,146./255.);	// G.C.GREEN
	colours[2] = vec3(253./255.,162./255.,0);			// G.C.ORANGE
	
	return colours[id];
}

vec4 effect( vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords ) {
	vec2 uv = (screen_coords - uie_details.xy) / uie_details.zw;
	//return vec4(uv,0,1);
	float offset = sin((time*2+uv.y+uv.x*.1)*3.1415926535)*.01;
	if (mall_active.x < 0.00001) {uv.x += 0.00001;}
	if (uie_scale < 0.00001) {uv.x += 0.00001;}
	if (uie_rot < 0.00001) {uv.x += 0.00001;}

	return vec4(getColour(progress > uv.x+offset ? int(ceil(progress)) : int(floor(progress))),1.);
}