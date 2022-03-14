/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * 3D and 2D Shape utilities and representations
 */

import std.stdio;
import maths;
import shape;

/**
 * Data for an intersection between a ray and a shape
 */
struct KI_Ray_Hit {
	KI_Shape *shape;
	Real t;
	
	this(KI_Shape *shape, Real t) {
		this.shape = shape;
		this.t = t;
	}
}

struct KI_Scene {
	KI_Shape[] shapes;
	
	void Add_Shape(ref KI_Shape shape) {
		/**
		 * Add a shape to the scene
		 */
		
		this.shapes ~= shape;
	}
	
	KI_Ray_Hit[] Check_Ray(KI_Ray3 ray) {
		/**
		 * Check a shape's collision against the scene, returning every hit.
		 */
		
		KI_Ray_Hit[] hits;
		
		foreach (shape; this.shapes) {
			Real[] points = shape.Check_Ray(ray);
			
			foreach (t; points) {
				hits[hits.length++] = KI_Ray_Hit(&shape, t);
			}
		}
		
		return hits;
	}
	
	KI_Ray_Hit Check_Ray_Closest(KI_Ray3 ray) {
		/**
		 * Check a shape's collision against the scene, returning lowest
		 * nonnegative hit. If there is no hit, then shape will be NULL.
		 */
		 
		KI_Ray_Hit hit = KI_Ray_Hit(null, -1.0);
		
		foreach (shape; this.shapes) {
			Real[] points = shape.Check_Ray(ray);
			
			foreach (t; points) {
				writeln("Hit at t ", t);
				
				if (t <= hit.t || hit.shape == null) {
					hit.t = t;
					hit.shape = &shape;
				}
			}
		}
		
		return hit;
	}
}
