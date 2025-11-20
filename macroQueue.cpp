#include "macroQueue.h"
#include "keyboardSimulate.h"

// 数据结构：使用 std::queue 存储列表项
std::queue<std::pair<std::string,int>> itemQueue;
bool isButtonDisabled = false;
std::chrono::steady_clock::time_point disableStartTime;
std::atomic<bool> done = false;

// 添加列表项的函数
void AddItem(const std::string& item,int duration) {
    std::cout << item << " " << duration << std::endl;
    itemQueue.push(std::make_pair(item,duration));
}

// 删除列表项的函数
void RemoveItem() {
    if (!itemQueue.empty()) {
        itemQueue.pop();
    }
}

// 暂时没用的，算等待时间
int AllTimeWait(std::queue<std::pair<std::string, int>>& itemQueue)
{
    auto copyTempQueue = itemQueue;
    int waitTime = 1;
    while (!copyTempQueue.empty())
    {
        waitTime += copyTempQueue.front().second;
        copyTempQueue.pop();
    }
    return waitTime;
}

// 显示列表页面的函数
void ShowMacroQueue() {
    static bool isButtonDisabled = false; // 控制按钮是否禁用
    
    // 开始一个 ImGui 窗口
    ImGui::Begin("List Page");

    // 显示当前列表项
    ImGui::Text("List Items:");
    ImGui::Separator();

    // 遍历队列并显示每一项
    std::queue<std::pair<std::string, int>> tempQueue = itemQueue; // 复制队列以避免修改原队列
    while (!tempQueue.empty()) {
        ImGui::Text("%s", tempQueue.front().first.c_str());
        ImGui::SameLine();
        ImGui::Text("%d", tempQueue.front().second);
        tempQueue.pop();
    }

    // 控制按钮是否禁用的开关
    //ImGui::Checkbox("Disable Button", &isButtonDisabled);

    if (done) {
        isButtonDisabled = false;
        done = false;
    }
    // 这里检测是否
    // 开始禁用
    if (isButtonDisabled) {
        ImGui::BeginDisabled();
    }
    // 运行队列的按钮
    ImGui::Button("run macro");
 
    // 结束禁用
    if (isButtonDisabled) {
        ImGui::EndDisabled();
    }
    if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(0)) {
        std::cout << "when click button isButtonDisabled is " << isButtonDisabled << std::endl;
        isButtonDisabled = true;
        auto tempThreadQueue = itemQueue; // 复制队列以避免修改原队列
        std::thread macroThread(RunMacro, std::ref(itemQueue), std::ref(done)); 
        if (macroThread.joinable()) {
            macroThread.detach();
        }
        json j = transQueueToJSON(tempThreadQueue);
        std::ofstream file("hotkey.json");
        file << j << std::endl;

        bool result = createNamePip();
        if (result) std::cout << "connect csharp success";
        else std::cout << "connect csharp failed";
    }

    // 删除项的按钮 
    if (ImGui::Button("Remove Item")) {
        RemoveItem();
    }

    // 结束 ImGui 窗口
    ImGui::End();
}

json transQueueToJSON(std::queue<std::pair<std::string, int>>& queue)
{
    std::vector<std::pair<std::string, int>> tempVector;

    while (!queue.empty()) {
        tempVector.push_back(queue.front());
        queue.pop();
    }

    json j;
    j["items"] = tempVector;
    return j;
}

void exeHotkey()
{

}

bool createNamePip()
{
    // 创建命名管道
    // 创建命名管道
    HANDLE hPipe = CreateNamedPipe(TEXT("\\\\.\\pipe\\MyPipe"),
        PIPE_ACCESS_OUTBOUND,
        PIPE_TYPE_BYTE | PIPE_WAIT,
        1, 0, 0, 0, NULL);

    if (hPipe == INVALID_HANDLE_VALUE) {
        std::cerr << "Failed to create named pipe. Error: " << GetLastError() << std::endl;
        return false;
    }

    // 等待客户端连接
    std::cout << "Waiting for client connection..." << std::endl;
    if (ConnectNamedPipe(hPipe, NULL)) {
        const char* message = "Hello from C++";
        DWORD bytesWritten;
        if (WriteFile(hPipe, message, strlen(message) + 1, &bytesWritten, NULL)) {
            std::cout << "Message sent to client." << std::endl;
        }
        else {
            std::cerr << "Failed to write to pipe. Error: " << GetLastError() << std::endl;
        }
    }
    else {
        std::cerr << "Failed to connect to named pipe. Error: " << GetLastError() << std::endl;
    }

    // 关闭管道句柄
    CloseHandle(hPipe);
    return true;
}
