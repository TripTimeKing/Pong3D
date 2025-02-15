shader_type spatial;
render_mode unshaded,wireframe,cull_disabled;

uniform vec4 albedo : source_color = vec4(0.0,0.0,1.0,0.0);
uniform float outline_width = 10.0;
uniform vec3 box_size;


varying vec3 world_normal;


void vertex() {
	world_normal = abs(NORMAL);
}

void fragment() {
	 //ALBEDO = albedo.rgb;
	ALBEDO = world_normal;
	//vec3 initialPoint = (inverse(MODEL_MATRIX) * VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float depth = FRAGCOORD.z;
    // FRAGCOORD go from [0, VIEWPORT_SIZE] so dividing it by VIEWPORT_SIZE 
    // makes it to go from [0, 1]. Multiply it by 2 makes it to [0, 2] and 
    // subtracting 1 makes it go from [-1,1] which is the correct range 
    // for normalized device coordinates (ndc).
	vec2 frag_ndc = ((FRAGCOORD.xy / VIEWPORT_SIZE) * 2.0) - 1.0; 
    // Use the INV_PROJECTION_MATRIX to go from NDC to viewspace.
	vec4 frag_view_space_position = INV_PROJECTION_MATRIX * vec4(frag_ndc, depth, 1.0);
    // make the perspective divide
	frag_view_space_position /= frag_view_space_position.w;
    // Use the INV_VIEW_MATRIX to go from view space to world space
	vec4 frag_world_space = INV_VIEW_MATRIX * frag_view_space_position;
	//vec4 frag_local_space = inverse(MODEL_MATRIX) * frag_world_space;
	vec4 frag_local_space = frag_world_space;
	//vec4 color = vec4(frag_local_space.x, frag_local_space.y, frag_local_space.z, 1.0);
	//ALBEDO.rgb = color.rgb;
	
	vec3 box_min = box_size * -0.5;
    vec3 box_max = box_size * 0.5;
	
	int AxisOutsideNumber = 0;
	// if it's 2 or above that means it's an edge point, else it's an inside point
	
	for (float i = -0.05; i < 0.06; i+=0.05) {
		// X
		vec3 point = frag_local_space.xyz + vec3(i, 0.0, 0.0);
		if (point.x <= box_min.x || point.x >= box_max.x) {
			//ALBEDO = albedo.rgb;
			AxisOutsideNumber++;
		}
		// Y
		point = frag_local_space.xyz  + vec3(0.0, i, 0.0);
		if (point.y <= box_min.y || point.y >= box_max.y) {
			//ALBEDO = vec3(1.0,0.0,0.0);
			AxisOutsideNumber++;
		}
		// Z
		point = frag_local_space.xyz  + vec3(0.0, i, 0.0);
		if (point.z <= box_min.z || point.z >= box_max.z) {
			//ALBEDO = vec3(0.0,1.0,0.0);
			AxisOutsideNumber++;
		}
	}
	
	//switch (AxisOutsideNumber) {
		//case 1:
			////ALBEDO = vec3(0.0,1.0,0.0);
			//ALPHA = 1.0;
			//break;
		//case 2:
			//ALPHA = 1.0;
			//ALBEDO = vec3(1.0,0.0,0.0);
			//break;
		//case 3:
			//ALPHA = 1.0;
			//ALBEDO = vec3(0.0,0.0,1.0);
			//break;
	//}
	ALBEDO = vec3(1.0,1.0,1.0);
	ALPHA = 0.1;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
