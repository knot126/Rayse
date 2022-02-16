/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * 3D and 2D Shape utilities and representations
 */

import maths;
import material;

class KI_Sphere {
	/**
	 * Sphere
	 */
	
	KI_Vec3 position;
	Real radius;
}

class KI_Box {
	/**
	 * Box
	 */
	
	KI_Vec3 position;
	KI_Vec3 size;
}

class KI_Triangle {
	/**
	 * Triangle
	 */
	
	KI_Vec3[3] points;
}

enum KI_Shape_Command_Type {
	/**
	 * The command for a shape object
	 */
	
	Box = 1,
	Triangle = 2,
}

struct KI_Shape_Command {
	/**
	 * A shape command (CSG operation)
	 */
	
	KI_Shape_Command_Type type;
	Object shape;
}

struct KI_Shape {
	/**
	 * A shape object, like an SVG path in some ways. This bears resemblance to
	 * a CSG representation of an object.
	 */
	
	KI_Shape_Command[] commands;
	KI_Material *material;
	
	this(KI_Shape_Command[] commands, KI_Material *material) {
		this.commands = commands;
		this.material = material;
	}
}

