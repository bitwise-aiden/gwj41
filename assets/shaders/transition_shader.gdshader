shader_type canvas_item; 

// Constants

const vec2 SIZE = vec2(1280.0, 720.0);

const float bubble_size = 50.0 / 50.0;
const float bubble_outline = 47.0 / 50.0;
const float bubble_offset = 5.0 / 50.0;
const float bubble_highlight_angle_min = 290.0;
const float bubble_highlight_angle_max = 340.0;
const float bubble_highlight_size_min = 25.0 / 50.0;
const float bubble_highlight_size_max = 35.0 / 50.0;


// Variables

uniform sampler2D bubbles;
uniform int bubble_count;
uniform float bubble_time;

uniform vec4 blue_color: hint_color;
uniform vec4 blue_highlight: hint_color;
uniform vec4 blue_outline: hint_color;
uniform vec4 blue_shadow: hint_color;


// Helper methods 

float det(vec2 a, vec2 b)
{
	return a.x * b.y - a.y * b.x;
}


float inner_angle(vec2 a, vec2 b)
{
	float cosx = dot(a, b) / (length(a) * length(b));
	
	return acos(cosx) * 180.0 / 3.1415;
}


float angle_between(vec2 a, vec2 b)
{
	float inner = inner_angle(a, b);
	
	if (det(a, b) < 0.0)
	{
		return inner;
	}
	
	return 360.0 - inner;
}

vec4 get_bubble_color(vec2 position) 
{
	if (bubble_time == 0.0)
	{
		return vec4(0.0);
	}
	
	for (int bubble_index; bubble_index < bubble_count; ++bubble_index)
	{
		vec4 bubble_data = texelFetch(bubbles, ivec2(bubble_index, 0), 0) * SIZE.x;
		
		float dist = distance(position, bubble_data.xy);	
		float bubble_ratio = (bubble_time - bubble_data.w) / (1.0 - bubble_data.w);
		
		if (dist > bubble_data.z * bubble_size * bubble_ratio)
		{
			continue;
		}
		
		vec4 color = blue_outline;
		
		if (dist < bubble_data.z * bubble_outline * bubble_ratio)
		{
			color = blue_color;
		}
		
		float offset = bubble_data.z * bubble_offset * bubble_ratio;
		vec2 offset_point = bubble_data.xy - vec2(offset);
		float offset_dist = distance(offset_point, position);
		
		if (offset_dist > bubble_data.z * bubble_size * bubble_ratio)
		{
			color = blue_shadow;
		}
		
		vec2 direction = position - bubble_data.xy;
		float angle = angle_between(vec2(-1.0, 0.0), direction);
		
		if (
			bubble_highlight_angle_min < angle && 
			angle < bubble_highlight_angle_max &&
			bubble_data.z * bubble_highlight_size_min * bubble_ratio < dist &&
			dist < bubble_data.z * bubble_highlight_size_max * bubble_ratio
		)
		{
			color = blue_highlight
		}
		
		return color;
	}
	
	return vec4(0.0);
}


// Lifecycle methods 

void fragment() 
{
	vec2 position = UV * SIZE;
	
	COLOR = get_bubble_color(position);
}