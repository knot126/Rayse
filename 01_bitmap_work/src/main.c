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

int main(int argc, const char *argv[]) {
	DgLog(DG_LOG_INFO, "Hello, world!\n");
	
	DgInitTime();
	DgInitPaths(DG_PATH_FAIL_FATAL);
	
	DgBitmap bmp;
	
	if (DgBitmapInit(&bmp, 1280, 720, 3)) {
		return 1;
	}
	
	DgBitmapFill(&bmp, (DgVec4) {DgRandFloat(), DgRandFloat(), DgRandFloat(), 1.0f});
	
	DgBitmapSetFlags(&bmp, DG_BITMAP_DRAWING_ALPHA);
	
	for (size_t i = 0; i < 25; i++) {
		DgVec2 points[] = {
			{DgRandFloat(), DgRandFloat()},
			{DgRandFloat(), DgRandFloat()},
			{DgRandFloat(), DgRandFloat()}
		};
		DgBitmapDrawConvexPolygon(&bmp, 3, points, &(DgVec4) {DgRandFloat(), DgRandFloat(), DgRandFloat(), 0.5f + 0.5f * DgRandFloat()});
	}
	
	DgBitmapWritePPM(&bmp, "assets://image.ppm");
	DgBitmapFree(&bmp);
	
	return 0;
}
