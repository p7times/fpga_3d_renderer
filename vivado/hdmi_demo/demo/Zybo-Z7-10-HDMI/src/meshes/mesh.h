#ifndef MESH_H
#define MESH_H

#define MAX_FACE_VERTS 8

typedef struct {
    float x, y, z;
} Vertices;

typedef struct {
    int count;
    int indices[MAX_FACE_VERTS];
} Face;

typedef struct {
    const Vertices* vertices;
    int vertex_count;

    const Face* faces;
    int face_count;
} Mesh;

#endif
