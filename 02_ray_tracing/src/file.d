/**
 * Copyright (C) 2022 Knot126
 * See LICENCE for details.
 * =============================================================================
 * 
 * Most mathematical functions
 */

import std.stdio;

struct KI_File {
	/**
	 * Handle to a file in the filesystem
	 */
	
	File base;
	alias base this;
}
