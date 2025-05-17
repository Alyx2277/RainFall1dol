#pragma once
#include <iostream>
#include <queue>
#include "AutoHead.h"
#include <windows.h>

// ���������Ľṹ��
struct MacroAction {
    std::string keyCombination; // ������ϣ����� "Ctrl+C"��
    int waitTime;               // �ȴ�ʱ�䣨���룩
};

// ģ����̰��º��ͷ�
// downOrUp��ʾ���»����ͷŲ���
// 1�ǰ��£�0���ɿ�
void SimulateKeyPress(const std::string& key,bool downOrUp) {
    // ���ַ���ת��Ϊ�������
    BYTE vkCode = 0;
    if (key == "Q") {
        vkCode = 'Q';
    }
    else if (key == "1") {
        vkCode = 0x31;
    }
    else if (key == "2") {
        vkCode = 0x32;
    }
    else if (key == "3") {
        vkCode = 0x33;
    }
    else if (key == "4") {
        vkCode = 0x34;
    }
    else if (key == "5") {
        vkCode = 0x35;
    }
    else if (key == "F1") {
        vkCode = VK_F1;
    }
    else if (key == "F2") {
        vkCode = VK_F2;
    }
    else if (key == "F3") {
        vkCode = VK_F3;
    }
    else if (key == "F4") {
        vkCode = VK_F4;
    }
    else if (key == "W") {
        vkCode = 'W';
    }
    else if (key == "E") {
        vkCode = 'E';
    }
    else if (key == "R") {
        vkCode = 'R';
    }
    else if (key == "A") {
        vkCode = 'A';
    }
    else if (key == "S") {
        vkCode = 'S';
    }
    else if (key == "D") {
        vkCode = 'D';
    }
    else if (key == "F") {
        vkCode = 'F';
    }
    else if (key == "G") {
        vkCode = 'G';
    }
    else if (key == "Z") {
        vkCode = 'Z';
    }
    else if (key == "F5") {
        vkCode = VK_F5;
    }
    else if (key == "F6") {
        vkCode = VK_F6;
    }
    else if (key == "F7") {
        vkCode = VK_F7;
    }
    else if (key == "F8") {
        vkCode = VK_F8;
    }
    else if (key == "F9") {
        vkCode = VK_F9;
    }
    else if (key == "7") {
        vkCode = 0x37; // '7' ���������
    }
    else if (key == "8") {
        vkCode = 0x38; // '8' ���������
    }
    else if (key == "9") {
        vkCode = 0x39; // '9' ���������
    }
    else if (key == "0") {
        vkCode = 0x30; // '0' ���������
    }
    else if (key == "Y") {
        vkCode = 'Y';
    }
    else if (key == "U") {
        vkCode = 'U';
    }
    else if (key == "I") {
        vkCode = 'I';
    }
    else if (key == "O") {
        vkCode = 'O';
    }
    else if (key == "P") {
        vkCode = 'P';
    }
    else if (key == "H") {
        vkCode = 'H';
    }
    else if (key == "J") {
        vkCode = 'J';
    }
    else if (key == "K") {
        vkCode = 'K';
    }
    else if (key == "L") {
        vkCode = 'L';
    }
    else if (key == "M") {
        vkCode = 'M';
    }
    else if (key == "N") {
        vkCode = 'N';
    }
    // ��Ӹ������ӳ��...
    
    // ģ�ⰴ�º��ͷ�
    if(downOrUp) keybd_event(vkCode, 0, 0, 0); // ����
    else keybd_event(vkCode, 0, KEYEVENTF_KEYUP, 0); // �ͷ�
}

// ִ�м������
void ExecuteKeyCombination(const std::string& combination) {
    // ������ϼ������� "Ctrl+C"��
    size_t plusPos = combination.find('+');
    if (plusPos != std::string::npos) {
        std::string modifier = combination.substr(0, plusPos); // ���μ������� "Ctrl"��
        std::string key = combination.substr(plusPos + 1);     // ���������� "Space"��

        // �������μ�
        SimulateKeyPress(modifier,1);

        // ��������
        SimulateKeyPress(key,1);

        // �ͷ�����
        SimulateKeyPress(key,0);

        // �ͷ����μ�
        SimulateKeyPress(modifier,0);
    }
    else {
        // ��������
        SimulateKeyPress(combination,1);
        SimulateKeyPress(combination, 0);
    }
}

void RunMacro(std::queue<std::pair<std::string, int>> & tempThreadQueue, std::atomic<bool> &done)
{
    // ִ�к����
    auto copyQueue = tempThreadQueue;
    while (!copyQueue.empty()) {
        MacroAction action;
        action.keyCombination = copyQueue.front().first;
        action.waitTime = copyQueue.front().second;
        copyQueue.pop();

        // ִ�м������
        std::cout << "Executing: " << action.keyCombination << std::endl;
        ExecuteKeyCombination(action.keyCombination);

        // �ȴ�ָ��ʱ��
        std::cout << "Waiting for " << action.waitTime << "s..." << std::endl;
        Sleep(action.waitTime*1000);
        printf("wait end\n");
    }
    printf("marco end!!!!!!!!\n");
    done = true;
}
