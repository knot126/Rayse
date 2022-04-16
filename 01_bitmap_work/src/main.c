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
#include "util/alloc.h"
#include "util/fs.h"

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

void KI_Triangle_Test(DgBitmap *bmp, float time) {
	DgBitmapTriangle t[] = {
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
				(DgColour) {0.0f, 0.0f, 0.5f + (0.5f * DgSin(time)), 0.5f}
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
				(DgColour) {0.0f, 0.0f, 0.5f + (0.5f * DgSin(time)), 0.5f}
			}
		},
		(DgBitmapTriangle) {
			(DgBitmapVertex) {
				(DgVec3) {-1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.5f + (0.5f * DgCos(time)), 0.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {-1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 1.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 0.0f, 0.5f + (0.5f * DgCos(time)), 0.5f}
			}
		},
		(DgBitmapTriangle) {
			(DgBitmapVertex) {
				(DgVec3) {-1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.5f + (0.5f * DgCos(time)), 0.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, 1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {1.0f, 1.0f, 0.0f, 0.5f}
			},
			(DgBitmapVertex) {
				(DgVec3) {1.0f, -1.0f, 2.0f},
				(DgVec2) {0.0f, 0.0f},
				(DgColour) {0.0f, 0.0f, 0.5f + (0.5f * DgCos(time)), 0.5f}
			}
		},
	};
	
	DgBitmapDrawTriangles(bmp, 4, t);
}

typedef struct KI_Smash_Hit_Vertex {
	float x, y, z, u, v;
	char r, g, b, s;
} KI_Smash_Hit_Vertex;

void KI_Render_Smash_Hit_Segment(DgBitmap * restrict this, const char * restrict filename, float zoffset) {
	/**
	 * Not meant for drawing per frame!!!
	 */
	
	uint32_t size;
	
	// Open file stream
	DgFile f = DgFileOpen2(filename, DG_FILE_STREAM_READ);
	
	if (!f) {
		return;
	}
	
	// Read vertex data
	DgFileStreamReadUInt32(f, &size);
	KI_Smash_Hit_Vertex *sh_vertexes = DgAlloc(sizeof *sh_vertexes * size);
	
	if (!sh_vertexes) {
		DgLog(DG_LOG_ERROR, "Failed to allocate memory!");
		return;
	}
	
	DgFileStreamRead(f, sizeof *sh_vertexes * size, sh_vertexes);
	
	// Convert to proper format
	DgBitmapVertex *vertexes = DgAlloc(sizeof *vertexes * size);
	
	if (!vertexes) {
		DgLog(DG_LOG_ERROR, "Failed to allocate memory!");
		return;
	}
	
	for (size_t i = 0; i < size; i++) {
		vertexes[i].position.x = sh_vertexes[i].x;
		vertexes[i].position.y = sh_vertexes[i].y - 1.0f;
		vertexes[i].position.z = sh_vertexes[i].z;
		vertexes[i].texture.u = sh_vertexes[i].u;
		vertexes[i].texture.v = sh_vertexes[i].v;
		float shade = ((float)sh_vertexes[i].s) / 255.0f;
		shade *= shade;
		shade = 1.0f - shade;
		vertexes[i].colour.r = ((float)sh_vertexes[i].r * 2.0f) / 255.0f * shade;
		vertexes[i].colour.g = ((float)sh_vertexes[i].g * 2.0f) / 255.0f * shade;
		vertexes[i].colour.b = ((float)sh_vertexes[i].b * 2.0f) / 255.0f * shade;
		//vertexes[i].colour.r = DgRandFloat(); vertexes[i].colour.g = DgRandFloat(); vertexes[i].colour.b = DgRandFloat();
		vertexes[i].colour.a = 1.0f;
	}
	
	DgFree(sh_vertexes);
	
	// Read index data
	DgFileStreamReadUInt32(f, &size);
	DgBitmapIndex *indexes = DgAlloc(sizeof *indexes * size);
	
	if (indexes == NULL) {
		DgLog(DG_LOG_ERROR, "Failed to allocate memory!");
		return;
	}
	
	DgFileStreamRead(f, sizeof *indexes * size, indexes);
	
	// Close file
	DgFileStreamClose(f);
	
	// Draw to bitmap
	DgBitmapDrawTrianglesIndexed(this, size, indexes, vertexes);
	
	// Free file stream
	DgFree(vertexes);
	DgFree(indexes);
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
	
	DgBitmapSetFlags(&bmp, DG_BITMAP_DRAWING_ALPHA | DG_BITMAP_DRAWING_PERSPECTIVE | DG_BITMAP_DRAWING_NEGATE_Z);
	DgBitmapSetDepthBuffer(&bmp, true);
	
	// Initialise window
	if (DgWindowInit(&win, "Software Rendering", (DgVec2I) {1280, 720})) {
		return 1;
	}
	
	double frame_time = 0.0;
	
	// Main loop
	for (size_t i = 0;; i++) {
		frame_time = DgTime();
		
		DgBitmapFill(&bmp, (DgVec4) {0.0f, 0.1f, 0.1f, 1.0f});
		
		KI_Render_Smash_Hit_Segment(&bmp, "data.mesh", frame_time * 0.01f);
		
		uint32_t a = DgWindowUpdate(&win, &bmp);
		
		if (a < 0) {
			DgLog(DG_LOG_ERROR, "Failed to update window!");
		}
		else if (a > 0) {
			break;
		}
		
		frame_time = DgTime() - frame_time;
		
		DgLog(DG_LOG_INFO, "Frame time: %.5gms (%.3g fps)", frame_time * 1000.0, 1 / frame_time);
	}
	
	DgWindowFree(&win);
	DgBitmapFree(&bmp);
	
	return 0;
}
