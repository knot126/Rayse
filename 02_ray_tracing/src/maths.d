/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Most mathematical functions
 */

import std.stdio;
import std.math;

alias Real = float;
alias Integer = int;

/**
 * 2D vector class
 */
struct KI_Vec2 {
	union {
		struct {
			Real x, y;
		}
		
		struct {
			Real u, v;
		}
		
		struct {
			Real[2] data;
		}
	}
	
	alias data this;
	
	this(Real x, Real y) {
		this.x = x;
		this.y = y;
	}
	
	KI_Vec2 opUrnary(string op)() if (op == "-") {
		/**
		 * Opposite vector
		 */
		
		return KI_Vec2(-this.x, -this.y);
	}
	
	KI_Vec2 opBinary(string op)(KI_Vec2 other) if (op == "+") {
		/**
		 * Vector addition
		 */
		
		return KI_Vec2(this.x + other.x, this.y + other.y);
	}
	
	KI_Vec2 opBinary(string op)(KI_Vec2 other) if (op == "-") {
		/**
		 * Vector subtraction
		 */
		
		return KI_Vec2(this.x - other.x, this.y - other.y);
	}
	
	KI_Vec2 opBinary(string op)(Real other) if (op == "*") {
		/**
		 * Vector scalar multiplication
		 */
		
		return KI_Vec2(this.x * other, this.y * other);
	}
	
	KI_Vec2 opBinary(string op)(Real other) if (op == "/") {
		/**
		 * Vector scalar division
		 */
		
		Real m = 1.0 / other;
		return KI_Vec2(this.x * m, this.y * m);
	}
	
	Real opBinary(string op)(KI_Vec2 other) if (op == "*") {
		/**
		 * Vector dot product
		 */
		
		return (this.x * other.x) + (this.y * other.y);
	}
	
	KI_Vec2 Cross() {
		/**
		 * Return a vector perpindicular to this one (basically the 2D cross
		 * product)
		 */
		
		return KI_Vec2(this.y, -this.x);
	}
	
	Real Length() {
		/**
		 * Length of a vector
		 */
		
		return sqrt(this.x * this.x + this.y * this.y);
	}
	
	KI_Vec2 Normalised() {
		/**
		 * Return a vector in the same direction with length 1.
		 */
		
		return this / this.Length();
	}
	
	void Print() {
		/**
		 * Print a vector
		 */
		
		write("[ ", this.x, " ", this.y, " ]");
	}
}

/**
 * 3D vector class
 */
struct KI_Vec3 {
	union {
		struct {
			Real x, y, z;
		}
		
		struct {
			Real r, g, b;
		}
		
		struct {
			Real[3] data;
		}
	}
	
	alias data this;
	
	this(Real x, Real y, Real z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
	
	KI_Vec3 opUrnary(string op)() if (op == "-") {
		/**
		 * Opposite vector
		 */
		
		return KI_Vec3(-this.x, -this.y, -this.z);
	}
	
	KI_Vec3 opBinary(string op)(KI_Vec3 other) if (op == "+") {
		/**
		 * Vector addition
		 */
		
		return KI_Vec3(this.x + other.x, this.y + other.y, this.z + other.z);
	}
	
	KI_Vec3 opBinary(string op)(KI_Vec3 other) if (op == "-") {
		/**
		 * Vector subtraction
		 */
		
		return KI_Vec3(this.x - other.x, this.y - other.y, this.z - other.z);
	}
	
	KI_Vec3 opBinary(string op)(Real other) if (op == "*") {
		/**
		 * Vector scalar multiplication
		 */
		
		return KI_Vec3(this.x * other, this.y * other, this.z * other);
	}
	
	KI_Vec3 opBinary(string op)(Real other) if (op == "/") {
		/**
		 * Vector scalar division
		 */
		
		Real m = 1.0 / other;
		return KI_Vec3(this.x * m, this.y * m, this.z * m);
	}
	
	Real opBinary(string op)(KI_Vec3 other) if (op == "*") {
		/**
		 * Vector dot product
		 */
		
		return (this.x * other.x) + (this.y * other.y) + (this.z * other.z);
	}
	
	KI_Vec3 Cross(KI_Vec3 other) {
		/**
		 * Return a vector perpindicular to both given vectors (cross product)
		 */
		
		return KI_Vec3(
			this.y * other.z - this.z * other.y,
			this.z * other.x - this.x * other.z,
			this.x * other.y - this.y * other.x
		);
	}
	
	Real Length() {
		/**
		 * Length of a vector
		 */
		
		return sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
	}
	
	KI_Vec3 Normalised() {
		/**
		 * Return a vector in the same direction with length 1.
		 */
		
		return this / this.Length();
	}
	
	void Print() {
		/**
		 * Print a vector
		 */
		
		write("[ ", this.x, " ", this.y, " ", this.z, " ]");
	}
}

/**
 * 4D vector class
 */
struct KI_Vec4 {
	union {
		struct {
			Real x, y, z, w;
		}
		
		struct {
			Real r, g, b, a;
		}
		
		struct {
			Real[4] data;
		}
	}
	
	alias data this;
	
	this(Real x, Real y, Real z, Real w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
}

alias KI_Colour = KI_Vec4;

/**
 * 4x4 vector class
 */
struct KI_Mat4 {
	union {
		struct {
			Real[4][4] data;
		}
		
		struct {
			KI_Vec4[4] as_vectors;
		}
	}
	
	this(Real h) {
		data[0][0] = h;
		data[0][1] = 0.0;
		data[0][2] = 0.0;
		data[0][3] = 0.0;
		
		data[1][0] = 0.0;
		data[1][1] = h;
		data[1][2] = 0.0;
		data[1][3] = 0.0;
		
		data[2][0] = 0.0;
		data[2][1] = 0.0;
		data[2][2] = h;
		data[2][3] = 0.0;
		
		data[3][0] = 0.0;
		data[3][1] = 0.0;
		data[3][2] = 0.0;
		data[3][3] = h;
	}
}

/**
 * Interpolation
 */

Type KI_Lerp(Type)(Real t, Type a, Type b) {
	/**
	 * Linear interpolate between two values.
	 */
	
	return ((1.0 - t) * a) + (t * b);
}
