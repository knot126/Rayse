/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * 3D and 2D Shape utilities and representations
 */

import maths;
import material;

interface KI_Subshape {
	bool Check_Point(KI_Vec3 point);
	KI_Vec3[] Check_Ray(KI_Ray3 ray);
}

class KI_Sphere : KI_Subshape {
	/**
	 * Sphere
	 */
	
	KI_Vec3 position;
	Real radius;
	
	bool Check_Point(KI_Vec3 point) {
		/**
		 * Check if a point is within the closed ball that has the same radius
		 * and position as the sphere.
		 */
		
		return (point - this.position).Length() <= this.radius;
	}
	
	KI_Vec3[] Check_Ray(KI_Ray3 ray) {
		/**
		 * Preform a raycast on the shape and return a list of points on the
		 * sphere.
		 */
		
		KI_Vec3[] points;
		
		Real a = ray.direction.Length_Squared();
		Real b = ray.direction * ray.origin;
		Real c = (ray.origin - this.position).Length_Squared();
		
		Real[] roots = KI_Poly2_Roots(a, b, c);
		
		foreach (root; roots) {
			if (root >= 0.0) {
				points[points.length++] = ray.Evaluate(root);
			}
		}
		
		return points;
	}
}

enum KI_Shape_Command_Type {
	/**
	 * The command for a shape object
	 */
	
	None = 0,
	Sphere = 1,
}

struct KI_Shape_Command {
	/**
	 * A shape command (CSG operation)
	 */
	
	KI_Shape_Command_Type type;
	KI_Subshape shape;
	
	this(KI_Shape_Command_Type type, KI_Subshape shape) {
		this.type = type;
		this.shape = shape;
	}
}

KI_Shape_Command_Type KI_Shape_Type_To_Enum(KI_Subshape shape) {
	/**
	 * Get a shape type enum given the type string
	 */
	
	switch (typeid(shape).toString()) {
		case "KI_Sphere":
			return KI_Shape_Command_Type.Sphere;
		default:
			return KI_Shape_Command_Type.None;
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
		
		KI_Shape_Command_Type type = KI_Shape_Type_To_Enum(shape);
		
		if (type == KI_Shape_Command_Type.None) {
			return;
		}
		
		this.commands[this.commands.length++] = KI_Shape_Command(type, shape);
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
	
	KI_Vec3[] Check_Ray(KI_Ray3 ray) {
		/**
		 * Check the shape against a ray.
		 */
		
		KI_Vec3[] points;
		
		foreach (cmd; commands) {
			points ~= cmd.shape.Check_Ray(ray);
		}
		
		return points;
	}
}

