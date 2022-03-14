/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * 3D and 2D Shape utilities and representations
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
			
			// Create ray
			KI_Ray3 ray = KI_Ray3(KI_Vec3(0.0, 0.0, 0.0), dir);
			
			// Send a raycast to the scene
			KI_Ray_Hit hit = scene.Check_Ray_Closest(ray);
			
			// Draw pixel for closest object hit
			if (hit.shape != null) {
// 				writeln("Hit!", hit.shape.material);
				bitmap.Set_Pixel(KI_Vec2I(cast(Integer) i, cast(Integer) j), hit.shape.material.colour);
			}
		}
	}
	
	return bitmap;
}
