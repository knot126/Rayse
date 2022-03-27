/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Core ray tracing implementation
 */

import std.stdio;
import maths;
import bitmap;
import shape;
import scene;

/**
 * Configuration for the ray tracer.
 */
struct KI_Raytrace_Config {
	KI_Colour background;
	KI_Vec2 canvas;
	Real dist;
	KI_Vec2I res;
	KI_Colour ambient;
}

KI_Bitmap KI_Raytrace_Scene(KI_Scene scene, KI_Raytrace_Config config) {
	/**
	 * Ray trace a scene into an image file.
	 * 
	 * @param scene Scene to raytrace to a bitmap
	 * @param config Ray tracer configuration
	 * @return Bitmap containing the raytraced scene
	 */
	
	KI_Bitmap bitmap = KI_Bitmap(config.res);
	
	// Clear bitmap
	bitmap.Clear(config.background);
	
	// Trace rays
	for (size_t i = 0; i < config.res.y; i++) {
		// Find y position by (y / (height - 1)) then interpolating between -y and y 
		Real q = cast(Real)(i) / cast(Real)(config.res.y - 1);
		q = ((1.0 - q) * -config.canvas.y) + (q * config.canvas.y);
		
		for (size_t j = 0; j < config.res.x; j++) {
			// Find alongness of x
			Real p = cast(Real)(j) / cast(Real)(config.res.x - 1);
			p = ((1.0 - p) * -config.canvas.x) + (p * config.canvas.x);
			
			// Create direction vector
			KI_Vec3 dir = KI_Vec3(p, q, config.dist);
			
			// Create ray (does not need to be normalised)
			KI_Ray3 ray = KI_Ray3(KI_Vec3(0.0, 0.0, 0.0), dir);
			
			// Send a raycast to the scene
			KI_Ray_Hit hit = scene.Check_Ray_Closest(ray);
			
			// Draw pixel for closest object hit
			if (hit.shape != null) {
				KI_Colour fin = KI_Colour(0.0, 0.0, 0.0, 0.0);
				KI_Vec3 from = ray.Evaluate(hit.t);
				
				// Accumulate lights
				foreach (light; scene.lights) {
					// Vector pointing in the direction of the light from this point on the surface
					KI_Vec3 to_light = (light.position - from).Normalised();
					
					// The shape
					KI_Shape s = *(hit.shape);
					
					// Get the facing ratio
					Real angle = KI_Max!Real(to_light * s.Get_Normal(from), 0.0);
					
					// Accumulate colour
					fin = fin + (angle * hit.shape.material.colour);
				}
				
				// Ambient light
				fin = fin + config.ambient.Multiply_Each(hit.shape.material.colour);
				
				// Set the pixel to its final colour
				bitmap.Set_Pixel(KI_Vec2I(cast(Integer) j, cast(Integer) (config.res.y - i - 1)), fin.Clamp(0.0, 1.0));
			}
		}
	}
	
	return bitmap;
}
