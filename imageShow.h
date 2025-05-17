#pragma once
#include "AutoHead.h"
#include <vector>

void LoadAllImages(ID3D11Device* g_pd3dDevice);
void ShowImageGrid(ID3D11Device* g_pd3dDevice);
ImTextureID LoadTextureFromFile(const char* file_name, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height, ID3D11Device* g_pd3dDevice);
bool LoadTextureFromMemory(const void* data, size_t data_size, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height, ID3D11Device* g_pd3dDevice);