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
import scene;

void main() {
	KI_Scene scene;
	KI_Sphere sphere = new KI_Sphere(KI_Vec3(0.0, 0.0, 3.0), 1.0);
	KI_Shape shape = KI_Shape();
	KI_Material material;
	KI_Raytrace_Config config;
	
	material.colour = KI_Colour(0.0, 1.0, 0.0, 1.0);
	shape.material = &material;
	shape.Push(sphere);
	scene.Add_Shape(shape);
	
	config.background = KI_Colour(0.0, 0.0, 0.0, 1.0);
	config.canvas = KI_Vec2(1.0, 1.0);
	config.dist = 1.0;
	config.res = KI_Vec2I(800, 800);
	
	KI_Bitmap bitmap = KI_Raytrace_Scene(scene, config);
	
	bitmap.Write_PPM("./scene.ppm");
}

void bitmap_test() {
	KI_Bitmap bmp = KI_Bitmap(KI_Vec2I(960, 720));
	bmp.Clear(KI_Colour(0.0, 0.0, 0.0, 1.0));
	bmp.Write_PPM("./image.ppm");
}
