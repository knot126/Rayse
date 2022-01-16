/**
 * Rayse - see licence for copyright information
 * =============================================
 * 
 * Main file
 */

#include "util/log.h"
#include "util/bitmap.h"
#include "util/rand.h"

#include "common.h"

int main(int argc, const char *argv[]) {
	DgLog(DG_LOG_INFO, "Hello, world!\n");
	
	DgInitPaths(DG_PATH_FAIL_FATAL);
	
	DgBitmap bmp;
	
	if (DgBitmapInit(&bmp, 1280, 720, 3)) {
		return 1;
	}
	
	DgBitmapFill(&bmp, (DgVec4) {0.0f, 0.0f, 0.0f, 1.0f});
	DgVec2 points[3] = { {0.3f, 0.6f}, {0.6f, 0.7f}, {0.7f, 0.3f} };
	DgBitmapDrawConvexPolygon(&bmp, 3, points, &(DgVec4) {0.1, 0.3f, 0.7f, 1.0f});
	DgBitmapWritePPM(&bmp, "assets://image.ppm");
	
	DgBitmapFree(&bmp);
	
	return 0;
}
