#pragma once
#include "AutoHead.h"
#include <queue>
#include <thread>
#include <functional>

void ShowMacroQueue();
void RemoveItem();
void AddItem(const std::string& item,int duration);
int AllTimeWait(std::queue<std::pair<std::string, int>> &itemQueue);

