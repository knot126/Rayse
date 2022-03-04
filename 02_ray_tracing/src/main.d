/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Main file
 */

import std.stdio;

import maths;
import shape;
import material;
import bitmap;
import raytrace;

void main() {
	KI_Bitmap bmp = KI_Bitmap(KI_Vec2I(960, 720));
	bmp.Clear(KI_Colour(0.0, 0.0, 0.0, 1.0));
	bmp.Write_PPM("./image.ppm");
}
