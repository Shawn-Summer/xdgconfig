/*
An Octahedron expands into a Cuboctahedron and further into a Rhombicuboctahedron (O-CO-RCO) by a kinematic 
transformation (hinged mechanism) where side-faces are twisted by 45 deg.
The O-CO transformation is also known as Jitterbug transformation as described by B. Fuller.
Rotation is accompanied by outward motion along the fixed rotation axis (squares: cube, triangles: octahedral).
After each transform, new faces are inserted that are centered at the previous vertex positions.
Although it seems unlikely, that transformations beyond RCO are possible.
Note that the geometry also goes through the intermediate states icosahedron and snub cube when adding the appropriate edges.
Initially, my inspiration came from these animations on WP: 
https://en.wikipedia.org/wiki/File:A3-P5-P3.gif
https://en.wikipedia.org/wiki/File:A5-A7.gif

Implementation: first, I tried a loop based version using dynamic indexing which is slow in GLSL.
So I ended up with this macro mess - surely there is something better...
*/

#define PI 3.14159265
#define SR3 1.73205081
#define R(a) mat2(cos((a) + vec4(0,.5, 1.5,0)*PI))

float t;

vec3 cam(vec3 p){    
    p.xz *= R(-t); p.yz *= R(-PI/8.);  // rotation
    p.xy /= (1. + p.z*  .03)/  .12;  // perspective, scale
	return p;
}

float dseg(vec2 p, vec2 a, vec2 b){
	p -= a; b -= a;
    return length(p - b*clamp(dot(p,b)/dot(b,b),0.,1.));
}

float line(vec2 u, vec3 a, vec3 b) {
	a = cam(a); b = cam(b);
    float z = (a + b).z*.5*  .2+  3.;	
	// brightness and thickness vary with z
    return 3./(z*z) * smoothstep(.02/z, 0., dseg(u, a.xy, b.xy));
}


void mainImage(out vec4 O, vec2 U) {
    vec2 r = iResolution.xy, u = (U - .5*r)/r.y;
	
	vec3 col = vec3(.02,.025,.035),  // colors
	c0 = vec3(.4,.6,1), c1 = vec3(1,.8,.3);
    
    col *= 1. - dot(u,u); col += sin(U.x)*sin(U.y)/512.;  // dithered background - from iq
    
	float phi, psi, A, B, s, c, q;
	t = iTime  *.3;
    
	phi = abs(mod(t+2.,4.)-2.);  // triangle wave in [0,2]
	bool s0 = phi < 1.;  // 1st stage: CO-RCO
    
	// square rotation = animation variable (0: expanded, pi/4: contracted)
	phi = smoothstep(1., 0., fract(phi))*PI/4.;
    //phi = (1.-fract(phi))*PI/4.;  // continuous
    //phi = PI/4.; s0 = true;  // octahedron (O)
    //phi = PI/15.; s0 = true;  // (icosahedron)
    //phi = 0.; s0 = true;  // cuboctahedron (CO)
    //phi = PI/12.; s0 = !true;  // (snub cube)
    //phi = 0.; s0 = !true;  // rhombicuboctahedron (RCO)
    
	s = sin(phi); c = cos(phi); q = sqrt(3.*c*c-1.);
    
    // triangles
    if(s0) B = c/(1.5*sqrt(s*s+.5)), psi = atan(3.*s-c, -SR3*(c+s));  // position, rotation: O-CO
    else B = q/3.+c, psi = -atan(3.*s-q, -SR3*(q+s));  // CO-RCO    
    mat2x3 C = mat2x3(normalize(vec3(1,1,-2)),normalize(vec3(1,-1,0)))*2./SR3;  // local coordinates, scale
	#define V(a,b) b*(B + C*R((s0 ? psi : (psi+PI*.5)*b.x*b.y*b.z-PI*.5) + (a)*PI/1.5)[1])  // vertex	
    #define E(a,b) col += (s0&&b.x*b.y*b.z<0. ? c0 : c1)*line(u, V(a,b), V(a+1.,b));  // edge
	#define T(b) E(0.,vec3 b) E(1.,vec3 b) E(2.,vec3 b)  // triangle
    T((1)) T((1,-1,-1)) T((-1,1,-1)) T((-1,-1,1)) T((-1)) T((-1,1,1)) T((1,-1,1)) T((1,1,-1))  // permutations
    
    // squares
	A = c + q;  // position    
    #define W(a,b,c) vec3(b A, R(b phi+(a)*PI*.5)*vec2(1)).c  // vertex
    #define F(a,b,c) col += c0*line(u, W(a,b,c), W(a+1.,b,c));  // edge
    #define S(b,c) F(0.,b,c) F(1.,b,c) F(2.,b,c) F(3.,b,c)  // square
    if(!s0) { S(,xyz) S(,yzx) S(,zxy) S(-,xyz) S(-,yzx) S(-,zxy) }  // permutations
    
    O = vec4(sqrt(col),1);
}

