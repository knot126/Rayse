/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * 3D and 2D Shape utilities and representations
 */

import std.stdio;
import maths;
import material;

enum KI_Shape_Type {
	/**
	 * The type of a shape
	 */
	
	None = 0,
	Sphere = 1,
}

interface KI_Subshape {
	bool Check_Point(KI_Vec3 point);
	Real[] Check_Ray(KI_Ray3 ray);
	KI_Shape_Type Get_Type();
}

class KI_Sphere : KI_Subshape {
	/**
	 * Sphere
	 */
	
	KI_Vec3 position;
	Real radius;
	
	this(KI_Vec3 position, Real radius) {
		this.position = position;
		this.radius = radius;
	}
	
	bool Check_Point(KI_Vec3 point) {
		/**
		 * Check if a point is within the closed ball that has the same radius
		 * and position as the sphere.
		 */
		
		return (point - this.position).Length() <= this.radius;
	}
	
	Real[] Check_Ray(KI_Ray3 ray) {
		/**
		 * Preform a raycast on the shape and return a list of t-values of where
		 * the ray intersects.
		 */
		
		Real[] points;
		
// 		Real a = ray.direction.Length_Squared();
// 		Real b = ray.direction * ray.origin;
// 		Real c = (ray.origin - this.position).Length_Squared();
		Real a = ray.direction.Length_Squared();
		Real b = 2.0 * (ray.direction * (ray.origin - this.position));
		Real c = (ray.origin - this.position).Length_Squared() - (this.radius * this.radius);
		
		Real[] roots = KI_Poly2_Roots(a, b, c);
		
		foreach (root; roots) {
			writeln("Root ", root);
			
			if (root >= 0.0) {
				points[points.length++] = root;
			}
		}
		
		return points;
	}
	
	KI_Shape_Type Get_Type() {
		/**
		 * Get the type of the shape
		 */
		
		return KI_Shape_Type.Sphere;
	}
}

struct KI_Shape_Command {
	/**
	 * A shape command (CSG operation)
	 */
	
	KI_Subshape shape;
	
	this(KI_Subshape shape) {
		this.shape = shape;
	}
}

struct KI_Shape {
	/**
	 * A shape object is just an aribtrary shape. It could be represented in any
	 * way, like being some B-spline patches, an implict surface or a triangle
	 * mesh, or any combination of these.
	 */
	
	KI_Shape_Command[] commands;
	KI_Material *material;
	
	this(KI_Shape_Command[] commands, KI_Material *material) {
		this.commands = commands;
		this.material = material;
	}
	
	void Push(KI_Subshape shape) {
		/**
		 * Push a shape to the shape command array.
		 */
		
		this.commands ~= KI_Shape_Command(shape);
	}
	
	bool Check_Point(KI_Vec3 point) {
		/**
		 * Check the shape against a ray.
		 */
		
		foreach (cmd; commands) {
			if (cmd.shape.Check_Point(point)) {
				return true;
			}
		}
		
		return false;
	}
	
	Real[] Check_Ray(KI_Ray3 ray) {
		/**
		 * Check the shape against a ray.
		 */
		
		Real[] points;
		
		foreach (cmd; commands) {
			points ~= cmd.shape.Check_Ray(ray);
		}
		
		//writeln(points);
		
		return points;
	}
}

