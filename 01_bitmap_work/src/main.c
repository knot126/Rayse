/**
 * Rayse - see licence for copyright information
 * =============================================
 * 
 * Main file
 */

#include "util/log.h"
#include "util/bitmap.h"
#include "util/rand.h"
#include "util/time.h"

#include "common.h"

void KI_Convex_Polygon_Test(DgBitmap *bmp) {
	for (size_t i = 0; i < 25; i++) {
		DgVec2 points[] = {
			{DgRandFloat(), DgRandFloat()},
			{DgRandFloat(), DgRandFloat()},
			{DgRandFloat(), DgRandFloat()}
		};
		DgBitmapDrawConvexPolygon(bmp, 3, points, &(DgVec4) {DgRandFloat(), DgRandFloat(), DgRandFloat(), 0.5f + 0.5f * DgRandFloat()});
	}
}

void KI_Triangle_Test(DgBitmap *bmp) {
	DgBitmapTriangle t[] = {
		(DgBitmapTriangle) {
			(DgBitmapVertex) {
				(DgVec3) {-1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 0.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {-1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 1.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 0.0f, 1.0f, 0.5f}
			}
		},
		(DgBitmapTriangle) {
			(DgBitmapVertex) {
				(DgVec3) {-1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 0.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 1.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 0.0f, 1.0f, 0.5f}
			}
		},
		(DgBitmapTriangle) {
			(DgBitmapVertex) {
				(DgVec3) {1.0f, 1.0f, 3.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 0.0f, 1.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 1.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 0.0f, 1.0f, 0.5f}
			}
		},
		(DgBitmapTriangle) {
			(DgBitmapVertex) {
				(DgVec3) {1.0f, 1.0f, 3.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 0.0f, 1.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 3.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 1.0f, 1.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 0.0f, 1.0f, 0.5f}
			}
		},
	};
	
	DgBitmapDrawTriangles(bmp, 4, &t);
}

int main(int argc, const char *argv[]) {
	DgLog(DG_LOG_INFO, "Hello, world!\n");
	
	DgInitTime();
	DgInitPaths(DG_PATH_FAIL_FATAL);
	
	DgBitmap bmp;
	
	if (DgBitmapInit(&bmp, 1280, 720, 3)) {
		return 1;
	}
	
	DgBitmapFill(&bmp, (DgVec4) {0.0f, 0.0f, 0.0f, 1.0f});
	
	DgBitmapSetFlags(&bmp, DG_BITMAP_DRAWING_ALPHA | DG_BITMAP_DRAWING_PERSPECTIVE);
	
	KI_Triangle_Test(&bmp);
	
	DgBitmapWritePPM(&bmp, "assets://image.ppm");
	DgBitmapFree(&bmp);
	
	return 0;
}
