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

typedef struct KI_Smash_Hit_Mesh {
	DgBitmapIndex *indexes;
	DgBitmapVertex *vertexes;
	uint32_t index_count;
} KI_Smash_Hit_Mesh;

int32_t KI_Smash_Hit_Mesh_Load(KI_Smash_Hit_Mesh * restrict mesh, const char * restrict filename, float zoffset) {
	/**
	 * Not meant for drawing per frame!!!
	 */
	
	uint32_t size;
	
	// Open file stream
	DgFile f = DgFileOpen2(filename, DG_FILE_STREAM_READ);
	
	if (!f) {
		return -1;
	}
	
	// Read vertex data
	DgFileStreamReadUInt32(f, &size);
	KI_Smash_Hit_Vertex *sh_vertexes = DgAlloc(sizeof *sh_vertexes * size);
	
	if (!sh_vertexes) {
		DgLog(DG_LOG_ERROR, "Failed to allocate memory!");
		return -1;
	}
	
	DgFileStreamRead(f, sizeof *sh_vertexes * size, sh_vertexes);
	
	// Convert to proper format
	mesh->vertexes = DgAlloc(sizeof *mesh->vertexes * size);
	
	if (!mesh->vertexes) {
		DgLog(DG_LOG_ERROR, "Failed to allocate memory!");
		return -1;
	}
	
	for (size_t i = 0; i < size; i++) {
		mesh->vertexes[i].position.x = sh_vertexes[i].x;
		mesh->vertexes[i].position.y = sh_vertexes[i].y - 1.0f;
		mesh->vertexes[i].position.z = sh_vertexes[i].z;
		mesh->vertexes[i].texture.u = sh_vertexes[i].u;
		mesh->vertexes[i].texture.v = sh_vertexes[i].v;
		float shade = ((float)sh_vertexes[i].s) / 255.0f;
		shade *= shade;
		shade = 1.0f - shade;
		mesh->vertexes[i].colour.r = ((float)sh_vertexes[i].r * 2.0f) / 255.0f * shade;
		mesh->vertexes[i].colour.g = ((float)sh_vertexes[i].g * 2.0f) / 255.0f * shade;
		mesh->vertexes[i].colour.b = ((float)sh_vertexes[i].b * 2.0f) / 255.0f * shade;
		//vertexes[i].colour.r = DgRandFloat(); vertexes[i].colour.g = DgRandFloat(); vertexes[i].colour.b = DgRandFloat();
		mesh->vertexes[i].colour.a = 1.0f;
	}
	
	DgFree(sh_vertexes);
	
	// Read index data
	DgFileStreamReadUInt32(f, &size);
	mesh->index_count = size;
	mesh->indexes = DgAlloc(sizeof *mesh->indexes * size);
	
	if (mesh->indexes == NULL) {
		DgLog(DG_LOG_ERROR, "Failed to allocate memory!");
		return -1;
	}
	
	DgFileStreamRead(f, sizeof *mesh->indexes * size, mesh->indexes);
	
	// Close file
	DgFileStreamClose(f);
	
	return 0;
}

void KI_Smash_Hit_Mesh_Render(KI_Smash_Hit_Mesh * restrict mesh, DgBitmap * restrict bitmap) {
	// Draw to bitmap
	DgBitmapDrawTrianglesIndexed(bitmap, mesh->index_count, mesh->indexes, mesh->vertexes);
}

void KI_Smash_Hit_Mesh_Free(KI_Smash_Hit_Mesh * restrict this) {
	// Free data
	DgFree(this->vertexes);
	DgFree(this->indexes);
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
	
	// Load segment
// 	KI_Smash_Hit_Mesh mesh;
// 	
// 	if (KI_Smash_Hit_Mesh_Load(&mesh, "data.mesh", 0.0f)) {
// 		return 1;
// 	}
	
	double frame_time = 0.0;
	
	DgBitmapFill(&bmp, (DgVec4) {0.0f, 0.0f, 0.0f, 1.0f});
	
	// Main loop
	for (size_t i = 0;; i++) {
		frame_time = DgTime();
		
		DgBitmapFill(&bmp, (DgVec4) {0.0f, 0.1f, 0.1f, 1.0f});
		
		DgVec2 cursor = DgWindowGetMouseLocation(&win);
		
		//DgBitmapDrawPoint(&bmp, cursor.x, cursor.y, 0.1f, (DgVec4) {DgRandFloat(), DgRandFloat(), DgRandFloat(), DgRandFloat()});
		
		DgBitmapDrawQuadraticBezier(&bmp, (DgVec2) {0.3f, 0.7f}, cursor, (DgVec2) {0.7f, 0.3f}, &(DgVec4) {1.0f, 1.0f, 1.0f, 1.0f});
		
		DgBitmapDrawPoint(&bmp, 0.3f, 0.7f, 0.01f, (DgVec4) {1.0f, 1.0f, 1.0f, 0.5f});
		DgBitmapDrawPoint(&bmp, cursor.x, cursor.y, 0.01f, (DgVec4) {1.0f, 1.0f, 1.0f, 0.5f});
		DgBitmapDrawPoint(&bmp, 0.7f, 0.3f, 0.01f, (DgVec4) {1.0f, 1.0f, 1.0f, 0.5f});
		
		DgBitmapDrawLine(&bmp, (DgVec2) {0.3f, 0.7f}, cursor, &(DgVec4) {1.0f, 1.0f, 1.0f, 0.4f});
		DgBitmapDrawLine(&bmp, cursor, (DgVec2) {0.7f, 0.3f}, &(DgVec4) {1.0f, 1.0f, 1.0f, 0.4f});
		
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
	
// 	KI_Smash_Hit_Mesh_Free(&mesh);
	
	DgWindowFree(&win);
	DgBitmapFree(&bmp);
	
	return 0;
}
