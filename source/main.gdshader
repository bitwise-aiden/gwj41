shader_type canvas_item;

uniform vec2 line_start; 
uniform vec2 line_end;
uniform vec2 current;

const float width_start = 10.0;
const float width_end = 5.0;

float lerp(float a, float b, float t) 
{
	return a + t * (b - a);
}

vec2 point_on_line(vec2 a, vec2 b, vec2 p)
{
	vec2 ab = b - a; 
	vec2 ap = p - a; 
	
	float ab2 = ab.x * ab.x + ab.y * ab.y; 
	float ap_d_ab = dot(ap, ab);
	
	float t = ap_d_ab / ab2; 
	
	vec2 pol = vec2(a.x + ab.x * t, a.y + ab.y * t);
	
	return clamp(a, b, pol);
}

float distance_to_line(vec2 a, vec2 b, vec2 p)
{
	vec2 pol = point_on_line(a, b, p);
	return length(p - pol);
}


void fragment()
{
	vec2 position = UV * vec2(1280.0, 720.0);
	
	vec2 pol = point_on_line(line_start, line_end, position);
	float lb = length(line_end - line_start);
	float lp = length(position - line_start);
	float d = lb / lp; 
	
	
	
	vec4 color = vec4(0.0);
	
	if (distance_to_line(line_start, line_end, position) < 5.0)
	{
		color = vec4(1.0);
	}
	
	COLOR = color;
}