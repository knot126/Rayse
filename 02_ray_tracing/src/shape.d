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
	Real Check_Point_Distance(KI_Vec3 point);
	Real[] Check_Ray(KI_Ray3 ray);
	KI_Vec3 Get_Normal(KI_Vec3 point);
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
	
	Real Check_Point_Distance(KI_Vec3 point) {
		/**
		 * Get the distance from a point to the surface.
		 */
		
		return (point - this.position).Length() - this.radius;
	}
	
	Real[] Check_Ray(KI_Ray3 ray) {
		/**
		 * Preform a raycast on the shape and return a list of t-values of where
		 * the ray intersects.
		 */
		
		Real[] points;
		
		Real a = ray.direction.Length_Squared();
		Real b = 2.0 * (ray.direction * (ray.origin - this.position));
		Real c = (ray.origin - this.position).Length_Squared() - (this.radius * this.radius);
		
		Real[] roots = KI_Poly2_Roots(a, b, c);
		
		foreach (root; roots) {
// 			writeln("Root ", root);
			
			if (root >= 0.0) {
				points ~= root;
			}
		}
		
		return points;
	}
	
	KI_Vec3 Get_Normal(KI_Vec3 point) {
		/**
		 * Get the normal of the surface at a point on the surface
		 */
		
		return (point - this.position) / this.radius;
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
	 * A shape
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
	
	KI_Vec3 position;
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
		
		foreach (cmd; this.commands) {
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
		
		foreach (cmd; this.commands) {
			points ~= cmd.shape.Check_Ray(ray);
		}
		
		return points;
	}
	
	KI_Vec3 Get_Normal(KI_Vec3 point) {
		/**
		 * Retrive the normal for a shape at a given point.
		 */
		
		foreach (cmd; this.commands) {
			if (cmd.shape.Check_Point_Distance(point) <= 0.001) {
				return cmd.shape.Get_Normal(point);
			}
		}
		
		return KI_Vec3(0.0, 0.0, 0.0);
	}
}

