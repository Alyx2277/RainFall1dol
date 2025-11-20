#pragma once
#include "AutoHead.h"
#include <queue>
#include <thread>
#include <functional>
#include <vector>
#include "json.hpp"
#include <fstream>

using json = nlohmann::json;

void ShowMacroQueue();
void RemoveItem();
void AddItem(const std::string& item,int duration);
int AllTimeWait(std::queue<std::pair<std::string, int>> &itemQueue);
json transQueueToJSON(std::queue<std::pair<std::string, int>> &queue);
void exeHotkey();
bool createNamePip();