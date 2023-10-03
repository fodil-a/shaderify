[![Version](https://img.shields.io/github/v/release/fodil-a/shaderify?label=version)](https://pub.dev/packages/shaderify)
[![Build Status](https://github.com/fodil-a/shaderify/workflows/build/badge.svg)](https://github.com/fodil-a/shaderify/actions)

That's a helper to add shaders easily, with some variables like time, mouse position, and size  

# Licensing
I do not allow you to use this package nor use anything you find here if you work in one of these fields :
  - Insurances
  - Blockchain
  - Defense
  - Banks (except if you don't do interests)
  - Deceiving your customers
  - Make people lose time 
  - Alcohol or ruminating animals
  - Art (music, representing faces/humans/animals...)
  - Anything Evil  
In case of doubts ask me by email I try to answer very fast (dev@fodil.org)

# Features

## Getting started

Just add the plugin `flutter pub add shaderify`.

## Usage

Just as a widget like that:
```dart
ShaderWidget(shaderPath: "shaders/myshader.frag");
```

The path must be declared in pubspec.yaml inside the "flutter" clause.
Example:
```yaml
flutter:
    -- your configuration...

    shaders:
      - shaders/myshader.frag
```



In most shaders you basically just have to add this: 
```glsl
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;

void main() {
    vec2 fragCoord = FlutterFragCoord().xy;
	// ...
}
```


Here is an example of shader taken from [shadertoy](https://www.shadertoy.com/view/XlfGRj):

```glsl
#define iterations 17
#define formuparam 0.53

#define volsteps 20
#define stepsize 0.1

#define zoom   0.800
#define tile   0.850
#define speed  0.010 

#define brightness 0.0015
#define darkmatter 0.300
#define distfading 0.730
#define saturation 0.850

#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 iResolution;
uniform vec2 iMouse;
uniform float iTime;

void main()
{

    vec2 fragCoord = FlutterFragCoord().xy;
	//get coords and direction
	vec2 uv=fragCoord.xy/iResolution.xy-.5;
	uv.y*=iResolution.y/iResolution.x;
	vec3 dir=vec3(uv*zoom,1.);
	float time=iTime*speed+.25;

	//mouse rotation
	float a1 = .5;
	float a2 = .8;

	mat2 rot1=mat2(cos(a1),sin(a1),-sin(a1),cos(a1));
	mat2 rot2=mat2(cos(a2),sin(a2),-sin(a2),cos(a2));
	dir.xz*=rot1;
	dir.xy*=rot2;
	vec3 from=vec3(1.,.5,0.5);
	from+=vec3(time*2.,time,-2.);
	from.xz*=rot1;
	from.xy*=rot2;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust
	fragColor = vec4(v*.01,1.);	
}
```

so that you can use the values passed to the shader.
