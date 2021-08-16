// largely taken from http://wdnuon.blogspot.com/2010/05/implementing-ibooks-page-curling-using.html
// comments also taken from that source
shader_type spatial;
render_mode unshaded;

uniform sampler2D tex: hint_albedo;
uniform float width = 48;
uniform float height = 32;
uniform float time = 0;

const float PI = 3.14159265358979323846264;


// This method computes rho, theta, and A for time parameter t using pre-defined functions to simulate a natural page turn
// without finger tracking, i.e., for a quick swipe of the finger to turn to the next page.
// These functions were constructed empirically by breaking down a page turn into phases and experimenting with trial and error
// until we got acceptable results. This basic example consists of three distinct phases, but a more elegant solution yielding
// smoother transitions can be obtained by curve fitting functions to our key data points once satisfied with the behavior.
const float angle1 = 90.0 / 180.0 * PI;
const float angle2 = 8.0 / 180.0 * PI;
const float angle3 = 6.0 / 180.0 * PI;
const float A1 = -15.0;
const float A2 = -2.5;
const float A3 = -3.5;
const float theta1 = 0.05;
const float theta2 = 0.5;
const float theta3 = 10.0;
const float theta4 = 2.0;

const float phase1 = 0.7;
const float phase2 = 0.85;
const float phase3 = 1.0;

const float maxRotation = PI/2.0;

float funcLinear(float ft, float f0, float f1){
  // Linear interpolation between f0 and f1
	return f0 + (f1 - f0) * ft;	
}

vec3 parameters(float t) {
	//initial version
	float A = - 15.0 * t;
	float theta = PI / 2.0 * t;
	float rho = (1.0 - t)*PI/4.0;
	
	 float f1, f2, dt;

  // Here rho, the angle of the page rotation around the spine, is a linear function of time t. This is the simplest case and looks
  // Good Enough. A side effect is that due to the curling effect, the page appears to accelerate quickly at the beginning
  // of the turn, then slow down toward the end as the page uncurls and returns to its natural form, just like in real life.
  // A non-linear function may be slightly more realistic but is beyond the scope of this example.
  	rho = t * maxRotation;

	if (t <= phase1)
	{
    // Start off with a flat page with no deformation at the beginning of a page turn, then begin to curl the page gradually
    // as the hand lifts it off the surface of the book.
		dt = t / phase1;
		f1 = sin(PI * pow(dt, theta1) / 2.0);
		f2 = sin(PI * pow(dt, theta2) / 2.0);
    		theta = funcLinear(f1, angle1, angle2);
		A = funcLinear(f2, A1, A2);
	}
	else if (t <= phase2)
	{
    // Produce the most pronounced curling near the middle of the turn. Here small values of theta and A
    // result in a short, fat cone that distinctly show the curl effect.
		dt = (t - phase1) / (phase2 - phase1);
		theta = funcLinear(dt, angle2, angle3);
		A = funcLinear(dt, A2, A3);
	}
	else if (t <= phase3)
	{
    // Near the middle of the turn, the hand has released the page so it can return to its normal form.
    // Ease out the curl until it returns to a flat page at the completion of the turn. More advanced simulations
    // could apply a slight wobble to the page as it falls down like in real life.
		dt = (t - phase2) / (phase3 - phase2);
		f1 = sin(PI * pow(dt, theta3) / 2.0);
		f2 = sin(PI * pow(dt, theta4) / 2.0);
		theta = funcLinear(f1, angle3, angle1);
		A = funcLinear(f2, A3, A1);
	}
	
	//theta=PI/2.0;
	//A=0.0;
	//rho = 0.0;
	
	return vec3(A, theta, rho);
}

void vertex() {
	// move to calculation space
	// calculation is on x-y plane
	// whereas our godot texture is x-z
	float Px = (VERTEX.x + width / 2.0) / width;
	float Py = (-VERTEX.z + height / 2.0) / height;
	
	// enable to have a constantly running animation
	//float t = (TIME - floor(TIME));
	float t = time;
	// animation parameters change over time for finetuning
	vec3 parameters = parameters(t);
		
	//A represents the cone apex. A value of zero puts the apex at the origin while larger and smaller values
	// translate the apex farther away along the y axis (up and down the spine of the book). Very large values
	// of A (approaching infinity) combined with small values of θ produce an extremely elongated cone, or
	// essentially a cylinder. As θ becomes smaller, the page begins to wind in upon itself, which may be an
	// interesting way of implementing a scroll-like effect.
	float A = parameters.x;
	//theta represents the cone angle and can range from {0…π/2} (90° for those who prefer to think in degrees over radians).
	//The smaller the value, the skinner the cone; at zero, the cone degenerates into a ray and makes the page virtually disappear.
	//At the other extreme, the cone is infinitely wide, which maps to a perfectly flat page with no curl whatsoever.
	float theta = parameters.y;
	
	//The third and final parameter rho represents the rotation of the page around the y axis, or the spine of the book.
	// As mentioned in the paper, a complete page turn comprises both a deformation and rotation component. 
	// While we could combine both processes into one step, for illustrative purposes it's easier to keep them separate
	// and apply rho separately as a basic rotation transform.
	float rho = parameters.z;
	
	//curl the page itself
	// Radius of the circle circumscribed by vertex (vi.x, vi.y) around A on the x-y plane.
	// i.e distance from (x,y) to (0,A) with A usually being a negative value
	float Rc = sqrt(Px * Px + pow(Py - A, 2));
	// From R, calculate the radius of the cone cross section intersected by our vertex in 3D space.
	float d = Rc * sin(theta);
	// beta = Angle SCT, the angle of the cone cross section subtended by the arc |ST|.
	float alpha = asin(Px / Rc);
	float beta = alpha / sin(theta);
	
	float x = d * sin(beta);
	// *** MAGIC!!! ***
	float y = Rc + A - d * (1.0 - cos(beta)) * sin(theta);
	float z = d * (1.0 - cos(beta)) * cos(theta);
	
	//rotate the overall page
	// Apply a basic rotation transform around the y axis to rotate the curled page. These two steps could be combined
    // through simple substitution, but are left separate to keep the math simple for debugging and illustrative purposes.
	float x2 = (x * cos(rho) - z * sin(rho));
    float y2 =  y;
    float z2 = (x * sin(rho) + z * cos(rho));
	x = x2;
	y = y2;
	z = z2;
	
	// remap to x-z godot
	VERTEX.x = x * width - width / 2.0;
	VERTEX.z = -(y * height - height/2.0);
	VERTEX.y = z*20.0;
}

void fragment() {
	ALBEDO = texture(tex, UV).rgb;
}