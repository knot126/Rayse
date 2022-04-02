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
#include "util/window.h"
#include "util/thread.h"

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
	
	DgBitmapDrawTriangles(bmp, 4, t);
}

int main(int argc, const char *argv[]) {
	DgLog(DG_LOG_INFO, "Hello, world!\n");
	
	DgInitTime();
	DgInitPaths(DG_PATH_FAIL_FATAL);
	
	DgBitmap bmp;
	DgWindow win;
	
	// Initialise bitmap
	if (DgBitmapInit(&bmp, 1280, 720, 3)) {
		return 1;
	}
	
	DgBitmapSetFlags(&bmp, DG_BITMAP_DRAWING_ALPHA | DG_BITMAP_DRAWING_PERSPECTIVE);
	DgBitmapSetDepthBuffer(&bmp, true);
	
	// Initialise window
	if (DgWindowInit(&win, "Software Rendering", (DgVec2I) {1280, 720})) {
		return 1;
	}
	
	double frame_time = 0.0;
	
	// Main loop
	for (size_t i = 0;; i++) {
		frame_time = DgTime();
		
		DgBitmapFill(&bmp, (DgVec4) {0.0f, 0.0f, 0.0f, 1.0f});
		
// 		for (size_t j = 0; j < i; j++) {
// 			DgBitmapDrawPoint(&bmp, (float)j / 100.0f, 0.93f, 0.01f, (DgColour4) {DgRandFloat(), DgRandFloat(), DgRandFloat(), 1.0f});
// 		}
		
		//KI_Triangle_Test(&bmp);
		
		DgBitmapDrawLine(&bmp, (DgVec2){0.1f, 0.5f}, (DgVec2){0.9f, 0.5f + (DgSin(0.1f * frame_time) * 0.4f)}, &(DgColour){0.7f, 0.3f, 0.8f, 1.0f});
		DgBitmapDrawLine(&bmp, (DgVec2){0.1f, 0.5f + (DgCos(0.1f * frame_time) * 0.4f)}, (DgVec2){0.9f, 0.5f}, &(DgColour){0.6f, 0.8f, 0.4f, 1.0f});
		
		uint32_t a = DgWindowUpdate(&win, &bmp);
		
		if (a < 0) {
			DgLog(DG_LOG_ERROR, "Failed to update window!");
		}
		else if (a > 0) {
			break;
		}
		
		frame_time = DgTime() - frame_time;
		
		DgLog(DG_LOG_INFO, "Frame time: %.5gms", frame_time * 1000.0);
	}
	
	DgWindowFree(&win);
	DgBitmapFree(&bmp);
	
	return 0;
}
