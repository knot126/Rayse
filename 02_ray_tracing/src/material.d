/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Points and materials
 */

import maths;

struct KI_Material {
	/**
	 * Material information
	 */
	
	KI_Colour colour;       // each component in [0, 1]
	
	this(KI_Colour *colour) {
		this.colour = *colour;
	}
	
	KI_Colour *Get_Colour() {
		return &colour;
	}
}
