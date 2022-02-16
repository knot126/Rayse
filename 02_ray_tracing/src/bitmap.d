/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Bitmap image
 */

import std.conv;

import maths;
import file;

struct KI_Bitmap {
	/**
	 * A bitmap image which represents descritised colour values.
	 * 
	 * This internally uses a single demensional array, even though it could have
	 * used multi-demensional arrays, for simplicity.
	 */
	
	KI_Colour[] data;
	KI_Vec2I size;
	
	this(KI_Vec2I size) {
		/**
		 * Initialise the bitmap
		 */
		
		this.size = size;
		this.data = new KI_Colour[size.x * size.y];
	}
	
	KI_Colour Get_Pixel(KI_Vec2I coords) {
		/**
		 * Get the colour of a pixel from the bitmap
		 */
		
		size_t index = KI_Get_Index_From_Array2D(this.size, coords);
		return data[index];
	}
	
	void Set_Pixel(KI_Vec2I coords, KI_Colour colour) {
		/**
		 * Draw a pxiel to the bitmap
		 */
		
		size_t index = KI_Get_Index_From_Array2D(this.size, coords);
		data[index] = colour;
	}
	
	void Clear(KI_Colour colour) {
		/**
		 * Fill the bitmap with pixels of a single colour
		 */
		
		size_t max = this.size.x * this.size.y;
		
		for (size_t i = 0; i < max; i++) {
			this.data[i] = colour;
		}
	}
	
	void Write_PPM(string name) {
		/**
		 * Write a PPM type 6 image of the bitmap.
		 */
		
		KI_File file;
		
		file.open(name, "wb");
		file.writeln("P6");
		file.writeln(to!string(this.size.x) ~ " " ~ to!string(this.size.y));
		file.writeln("255");
		file.writeln();
		
		size_t max = this.size.x * this.size.y;
		
		for (size_t i = 0; i < max; i++) {
			KI_Vec4B c = KI_Vec4B(this.data[i]);
			file.writeln(c.r);
			file.writeln(c.g);
			file.writeln(c.b);
		}
		
		file.close();
	}
}
