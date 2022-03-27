/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Representation of a light source
 */

import maths;

struct KI_Light {
	KI_Vec3 position;
	KI_Colour colour;
	
	this(KI_Vec3 position, KI_Colour colour) {
		this.position = position;
		this.colour = colour;
	}
}
