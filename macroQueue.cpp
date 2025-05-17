#include "macroQueue.h"
#include "keyboardSimulate.h"


// ���ݽṹ��ʹ�� std::queue �洢�б���
std::queue<std::pair<std::string,int>> itemQueue;
bool isButtonDisabled = false;
std::chrono::steady_clock::time_point disableStartTime;
std::atomic<bool> done = false;

// ����б���ĺ���
void AddItem(const std::string& item,int duration) {
    std::cout << item << " " << duration << std::endl;
    itemQueue.push(std::make_pair(item,duration));
}

// ɾ���б���ĺ���
void RemoveItem() {
    if (!itemQueue.empty()) {
        itemQueue.pop();
    }
}

// ��ʱû�õģ���ȴ�ʱ��
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


// ��ʾ�б�ҳ��ĺ���
void ShowMacroQueue() {
    static bool isButtonDisabled = false; // ���ư�ť�Ƿ����
    
    // ��ʼһ�� ImGui ����
    ImGui::Begin("List Page");

    // ��ʾ��ǰ�б���
    ImGui::Text("List Items:");
    ImGui::Separator();

    // �������в���ʾÿһ��
    std::queue<std::pair<std::string, int>> tempQueue = itemQueue; // ���ƶ����Ա����޸�ԭ����
    while (!tempQueue.empty()) {
        ImGui::Text("%s", tempQueue.front().first.c_str());
        ImGui::SameLine();
        ImGui::Text("%d", tempQueue.front().second);
        tempQueue.pop();
    }

    // ���ư�ť�Ƿ���õĿ���
    //ImGui::Checkbox("Disable Button", &isButtonDisabled);

    if (done) {
        isButtonDisabled = false;
        done = false;
    }
    // �������Ƿ�
    // ��ʼ����
    if (isButtonDisabled) {
        ImGui::BeginDisabled();
    }
    // ���ж��еİ�ť
    ImGui::Button("run macro");
 
    // ��������
    if (isButtonDisabled) {
        ImGui::EndDisabled();

    }
    if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(0)) {
        std::cout << "when click button isButtonDisabled is " << isButtonDisabled << std::endl;
        isButtonDisabled = true;
        //std::queue<std::pair<std::string, int>> tempThreadQueue = itemQueue; // ���ƶ����Ա����޸�ԭ����
        std::thread macroThread(RunMacro, std::ref(itemQueue), std::ref(done));
        if (macroThread.joinable()) {
            macroThread.detach();
        }
    }

    // ɾ����İ�ť
    if (ImGui::Button("Remove Item")) {
        RemoveItem();
    }

    // ���� ImGui ����
    ImGui::End();
}
