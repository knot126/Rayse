import std.stdio;

import maths;
import shape;
import material;
import bitmap;

void KI_Vector_Test() {
	KI_Vec2 v = KI_Vec2(1.0, 2.0);
	KI_Vec2 a = KI_Vec2(3.0, 0.0);
	KI_Vec2 b = KI_Vec2(-1.0, 7.0);
	KI_Vec2 c = KI_Vec2(0.5, 0.0);
	
	write("v = ");
	v.Print();
	writeln();
	
	write("a = ");
	a.Print();
	writeln();
	
	write("b = ");
	b.Print();
	writeln();
	
	write("c = ");
	c.Print();
	writeln();
	
	(a + b).Print(); writeln();
	(a - b).Print(); writeln();
	writeln(a * b);
	(a.Cross()).Print(); writeln();
	writeln(b.Length());
}

void KI_Shape_Test() {
	
}

void main() {
	KI_Bitmap bmp = KI_Bitmap(KI_Vec2I(960, 720));
	bmp.Clear(KI_Colour(0.0, 0.0, 0.0, 1.0));
	bmp.Write_PPM("./image.ppm");
}
