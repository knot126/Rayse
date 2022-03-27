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
	
	KI_Vec2 opBinaryRight(string op)(Real other) if (op == "*") {
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
	
	Real Length_Squared() {
		/**
		 * Return the squared length of the vector (faster than the regular
		 * length since it avoids square root).
		 */
		
		return this.x * this.x + this.y * this.y;
	}
	
	Real Length() {
		/**
		 * Length of a vector
		 */
		
		return sqrt(this.Length_Squared());
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
	
	KI_Vec3 opBinaryRight(string op)(Real other) if (op == "*") {
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
	
	Real Length_Squared() {
		/**
		 * Return the squared length of the vector (faster than the regular
		 * length since it avoids square root).
		 */
		
		return this.x * this.x + this.y * this.y + this.z * this.z;
	}
	
	Real Length() {
		/**
		 * Length of a vector
		 */
		
		return sqrt(this.Length_Squared());
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
	
	KI_Vec4 opBinary(string op)(KI_Vec4 other) if (op == "+") {
		/**
		 * Vector addition
		 */
		
		return KI_Vec4(this.x + other.x, this.y + other.y, this.z + other.z, this.w + other.w);
	}
	
	KI_Vec4 opBinary(string op)(Real other) if (op == "*") {
		/**
		 * Vector and scalar multiplication
		 */
		
		return KI_Vec4(other * this.x, other * this.y, other * this.z, other * this.w);
	}
	
	KI_Vec4 opBinaryRight(string op)(Real other) if (op == "*") {
		/**
		 * Vector and scalar multiplication
		 */
		
		return KI_Vec4(other * this.x, other * this.y, other * this.z, other * this.w);
	}
	
	KI_Vec4 Multiply_Each(KI_Vec4 other) {
		/**
		 * Multiply each compontent with one another.
		 */
		
		return KI_Vec4(this.r * other.r, this.g * other.g, this.b * other.b, this.a * other.a);
	}
	
	KI_Vec4 Clamp(Real m, Real M) {
		return KI_Vec4(KI_Max!Real(KI_Min!Real(this.x, M), m), KI_Max!Real(KI_Min!Real(this.y, M), m), KI_Max!Real(KI_Min!Real(this.z, M), m), KI_Max!Real(KI_Min!Real(this.w, M), m));
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
 * 2D vector class
 */
struct KI_Vec2I {
	union {
		struct {
			Integer x, y;
		}
		
		struct {
			Integer u, v;
		}
		
		struct {
			Integer[2] data;
		}
	}
	
	alias data this;
	
	this(Integer x, Integer y) {
		this.x = x;
		this.y = y;
	}
	
	KI_Vec2I opUrnary(string op)() if (op == "-") {
		/**
		 * Opposite vector
		 */
		
		return KI_Vec2I(-this.x, -this.y);
	}
	
	KI_Vec2I opBinary(string op)(KI_Vec2I other) if (op == "+") {
		/**
		 * Vector addition
		 */
		
		return KI_Vec2I(this.x + other.x, this.y + other.y);
	}
	
	KI_Vec2I opBinary(string op)(KI_Vec2I other) if (op == "-") {
		/**
		 * Vector subtraction
		 */
		
		return KI_Vec2I(this.x - other.x, this.y - other.y);
	}
	
	KI_Vec2I opBinary(string op)(Real other) if (op == "*") {
		/**
		 * Vector scalar multiplication
		 */
		
		return KI_Vec2I(this.x * other, this.y * other);
	}
	
	KI_Vec2I opBinary(string op)(Real other) if (op == "/") {
		/**
		 * Vector scalar division
		 */
		
		Real m = 1.0 / other;
		return KI_Vec2I(this.x * m, this.y * m);
	}
	
	Real opBinary(string op)(KI_Vec2I other) if (op == "*") {
		/**
		 * Vector dot product
		 */
		
		return (this.x * other.x) + (this.y * other.y);
	}
	
	KI_Vec2I Cross() {
		/**
		 * Return a vector perpindicular to this one (basically the 2D cross
		 * product)
		 */
		
		return KI_Vec2I(this.y, -this.x);
	}
	
	Real Length() {
		/**
		 * Length of a vector
		 */
		
		return sqrt(cast(float)(this.x * this.x + this.y * this.y));
	}
	
	void Print() {
		/**
		 * Print a vector
		 */
		
		write("[ ", this.x, " ", this.y, " ]");
	}
}

struct KI_Vec4B {
	/**
	 * Single byte vector 4 class (mainly for colour storage)
	 */
	
	union {
		struct {
			char x, y, z, w;
		}
		
		struct {
			char r, g, b, a;
		}
		
		struct {
			char[4] data;
		}
	}
	
	alias data this;
	
	this(KI_Colour c) {
		this.r = cast(char)(c.r * 255.0);
		this.g = cast(char)(c.g * 255.0);
		this.b = cast(char)(c.b * 255.0);
		this.a = cast(char)(c.a * 255.0);
	}
	
	this(char x, char y, char z, char w) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
	
	KI_Vec4B opBinary(string op)(KI_Vec4B other) if (op == "+") {
		/**
		 * Vector addition
		 */
		
		return KI_Vec4B(this.x + other.x, this.y + other.y, this.z + other.z, this.w + other.w);
	}
	
	KI_Vec4B opBinary(string op)(KI_Vec4B other) if (op == "-") {
		/**
		 * Vector subtraction
		 */
		
		return KI_Vec4B(this.x - other.x, this.y - other.y, this.z - other.z, this.w - other.w);
	}
	
	KI_Vec4B opBinary(string op)(Real other) if (op == "*") {
		/**
		 * Vector scalar multiplication
		 */
		
		return KI_Vec4B(this.x * other, this.y * other, this.z * other, this.w * other);
	}
	
	KI_Vec4B opBinary(string op)(Real other) if (op == "/") {
		/**
		 * Vector scalar division
		 */
		
		Real m = 1.0 / other;
		return KI_Vec4B(this.x * m, this.y * m, this.z * m, this.w * m);
	}
	
	Real opBinary(string op)(KI_Vec4B other) if (op == "*") {
		/**
		 * Vector dot product
		 */
		
		return (this.x * other.x) + (this.y * other.y) + (this.z * other.z) + (this.w * other.w);
	}
	
	Real Length() {
		/**
		 * Length of a vector
		 */
		
		return sqrt(cast(float)(this.x * this.x + this.y * this.y + this.z * this.z + this.w * this.w));
	}
	
	void Print() {
		/**
		 * Print a vector
		 */
		
		write("[ ", this.x, " ", this.y, " ]");
	}
}

struct KI_Ray3 {
	/**
	 * 3D geometric ray
	 */
	
	KI_Vec3 origin, direction;
	
	this(KI_Vec3 origin, KI_Vec3 direction) {
		/**
		 * Create a ray given the origin and direction.
		 */
		
		this.origin = origin;
		this.direction = direction;
	}
	
	KI_Vec3 Evaluate(Real t) {
		/**
		 * Evaluate the coordinates of a point at O+(t*D).
		 */
		
		return this.origin + t * this.direction;
	}
}

KI_Vec2I KI_Get_Array2D_From_Index(KI_Vec2I size, size_t index) {
	/**
	 * Get a 2D array index given the size and index of an array.
	 * 
	 * @param size Size of the array
	 * @param index Index to convert
	 * @return 2D array indicies
	 */
	
	return KI_Vec2I(cast(Integer) index % size.x, cast(Integer) index / size.x);
}

size_t KI_Get_Index_From_Array2D(KI_Vec2I size, KI_Vec2I array) {
	/**
	 * Get a plain array index given the size and 2D array index.
	 * 
	 * @param size Size of the array
	 * @param array Array coordinates to convert
	 * @return Index of the array
	 */
	
	return (size.x * array.y) + array.x;
}

/**
 * Polynomials
 */

Real KI_Poly2_Det(Real a, Real b, Real c) {
	/**
	 * Calculate the determinate
	 */
	
	return (b * b) - 4.0 * a * c;
}

Real[] KI_Poly2_Roots(Real a, Real b, Real c) {
	/**
	 * Return a list of the roots of the 2nd degree polynomial with the given
	 * coefficents. Uses quadratic formula.
	 */
	
	Real[] roots;
	Real det = KI_Poly2_Det(a, b, c);
	
	if (det < 0.0) {
		return roots;
	}
	else if (det == 0.0) {
		roots ~= (-b) / (2.0 * a);
	}
	else {
		roots ~= (-b - sqrt(det)) / (2.0 * a);
		roots ~= (-b + sqrt(det)) / (2.0 * a);
	}
	
	return roots;
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

/**
 * Min/Max
 */

Type KI_Max(Type)(Type a, Type b) {
	return (a <= b) ? b : a;
}

Type KI_Min(Type)(Type a, Type b) {
	return (a >= b) ? b : a;
}
