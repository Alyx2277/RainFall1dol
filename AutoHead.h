#pragma once
#include "imconfig.h"
#include "imgui.h"
#include "imgui_impl_dx11.h"
#include "imgui_impl_win32.h"
#include "imgui_internal.h"
#include "imstb_rectpack.h"
#include "imstb_textedit.h"
#include "imstb_truetype.h"
#include "IconsFontAwesome4.h"
#include "windows.h"

#include <d3d11.h>
#include <algorithm>
#include <atomic>
#include <vector>
#include <cinttypes>
#include <mutex>
#include <array>
#include <span>
#include <unordered_map>
#include <assert.h>
#include <iostream>
#include <utility>
#include <string>
#include <chrono>

#pragma comment(lib, "d3d11.lib")