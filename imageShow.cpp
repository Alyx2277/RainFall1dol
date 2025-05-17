#define _CRT_SECURE_NO_WARNINGS
#define STB_IMAGE_IMPLEMENTATION
#include "imageShow.h"
#include "stb_image.h"
#include "macroQueue.h"

// TODO: 窗口布局和美术的优化
//   - 优先级: 中
//   - 负责人: 2277
//   - 备注: 可能需要设计人员帮助

#define imageNum 107 //总图片数

// 关闭按钮，关闭全部窗口
bool close_open = true;
// 全局变量，用于控制窗口的最小化状态
bool is_minimized = false;

std::vector<ImTextureID> textures(imageNum); // 替换为实际的图片纹理数据
std::vector <std::string> keyMapL = {
    "Q+1","Q+2","Q+3","Q+4","Q+5","Q+F1","Q+F2","Q+F3","Q+F4",
    "W+X","W+1","W+2","W+3","W+4","W+5","W+F1","W+F2","W+F3","W+F4",
    "E+X","E+1","E+2","E+3","E+4","E+5","E+F1","E+F2","E+F3","E+F4",
    "R+X","R+1","R+2","R+3","R+4","R+5","R+F1","R+F2","R+F3","R+F4",
    "T+X","T+1","T+2","T+3","T+4","T+5","T+F1","T+F2","T+F3","T+F4",
    "A+X","A+1","A+2","A+3","A+4","A+5","A+F1","A+F2","A+F3","A+F4",
    "S+X","S+1","S+2","S+3","S+4","S+5","S+F1","S+F2","S+F3","S+F4",
    "D+X","D+1","D+2","D+3","D+4","D+5","D+F1","D+F2","D+F3","D+F4",
    "F+X","F+1","F+2","F+3","F+4","F+5","F+F1","F+F2","F+F3","F+F4",
    "G+X","G+1","G+2","G+3","G+4","G+5","G+F1","G+F2","G+F3","G+F4",
    "Z+X","Z+1","Z+2","Z+3","Z+4","Z+5","Z+F1","Z+F2"
};
std::vector <std::string> keyMapR = {
    "Y+F5","Y+F6","Y+F7","Y+F8","Y+F9","Y+6","Y+7","Y+8","Y+9",
    "U+0","U+F5","U+F6","U+F7","U+F8","U+F9","U+6","U+7","U+8","U+9",
    "I+0","I+F5","I+F6","I+F7","I+F8","I+F9","I+6","I+7","I+8","I+9",
    "O+0","O+F5","O+F6","O+F7","O+F8","O+F9","O+6","O+7","O+8","O+9",
    "P+0","P+F5","P+F6","P+F7","P+F8","P+F9","P+6","P+7","P+8","P+9",
    "H+0","H+F5","H+F6","H+F7","H+F8","H+F9","H+6","H+7","H+8","H+9",
    "J+0","J+F5","J+F6","J+F7","J+F8","J+F9","J+6","J+7","J+8","J+9",
    "K+0","K+F5","K+F6","K+F7","K+F8","K+F9","K+6","K+7","K+8","K+9",
    "L+0","L+F5","L+F6","L+F7","L+F8","L+F9","L+6","L+7","L+8","L+9",
    "M+0","M+F5","M+F6","M+F7","M+F8","M+F9","M+6","M+7","M+8","M+9",
    "N+0","N+F5","N+F6","N+F7","N+F8","N+F9","N+6","N+7"
};
bool LeftOrRight = 0; // 0是左手，1是右手

//ImTextureID textures;
static bool show_new_window = false;
// 定义输入框的内容
static char input_text1[256] = ""; // 秒数
int tempI;


void LoadAllImages(ID3D11Device* g_pd3dDevice)
{
    static std::unordered_map<std::string, ImTextureID> textureCache;

    char file_name[256];
    for (int i = 0; i < imageNum; ++i) {
        snprintf(file_name, sizeof(file_name), "./images/image%d.png", i+1 );

        // 检查纹理是否已经加载
        if (textureCache.find(file_name) != textureCache.end()) {
            textures[i] = textureCache[file_name];
            continue;
        }

        ID3D11ShaderResourceView* out_srv = nullptr;
        int out_width = 400;
        int out_height = 400;
        // 加载纹理
        textures[i] = LoadTextureFromFile(file_name, &out_srv, &out_width, &out_height, g_pd3dDevice);

        if (!textures[i])
        {
            std::cerr << "Failed to load texture: " << file_name << std::endl;
            continue;
        }

        // 缓存纹理
        textureCache[file_name] = textures[i];

    }
}

void ShowImageGrid(ID3D11Device* g_pd3dDevice)
{
    if (!close_open) std:exit(0);
    // 设置窗口属性
    ImGui::Begin("108image", &close_open, ImGuiWindowFlags_None);


    // 计算每张图片的宽度和高度
    float imageWidth = 400;
    float imageHeight = imageWidth; // 假设图片是正方形的

    ImGui::Checkbox("left or right", &LeftOrRight);

    ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(2.0f, 2.0f)); // 固定边框大小为4
    // 定义图片的UV坐标
    ImVec2 uv0 = ImVec2(0.0f, 0.0f); // 图片的左上角UV坐标
    ImVec2 uv1 = ImVec2(1.0f, 1.0f); // 图片的右下角UV坐标

    // 定义背景颜色和着色颜色
    ImVec4 bg_col = ImVec4(1.0f, 1.0f, 1.0f, 1.0f); // 背景颜色（透明）
    ImVec4 tint_col = ImVec4(1.0f, 1.0f, 1.0f, 1.0f); // 着色颜色（白色）

    // 开始两列布局
    ImGui::Columns(3, "image_text_columns", true); // true 表示显示列之间的边框

    for (int i = 0; i < imageNum; ++i) {
        // 为每个图片按钮生成唯一的 ID
        std::string button_id = "image_button_" + std::to_string(i);

        // TODO:这里改成鼠标方式显示tips
        if (ImGui::ImageButton(button_id.c_str(), textures[i], ImVec2(imageWidth, imageHeight), uv0, uv1, bg_col, tint_col)) {
            // 如果图片被点击，执行相关操作
            std::cout << "Image " << i + 1 << " clicked! Keymap: " << keyMapL[i] << std::endl;
        }
        
        // 检测双击事件
        if (ImGui::IsItemHovered() && ImGui::IsMouseDoubleClicked(0)) { // 0 表示鼠标左键
            // 创建新窗口的标识符
            tempI = i;
            show_new_window = true;
        }
        // 检测右键点击事件
        if (ImGui::IsItemHovered() && ImGui::IsMouseClicked(1)) { // 1 表示鼠标右键
            tempI = i;
            ImGui::OpenPopup("image_popup");
        }

        // 在同一行显示图片对应的按键映射
        if (!LeftOrRight) 
        {
            ImGui::Text("Keymap: %s", keyMapL[i].c_str());
        }
        else 
        {
            ImGui::Text("Keymap: %s", keyMapR[i].c_str());
        }
        
        ImGui::NextColumn();

        if((i%3) == 0)
            ImGui::Separator();
        
        // 换行显示下一张图片
        //ImGui::NewLine();
    }

    // 结束列布局
    ImGui::Columns(1);

    // 确定添加宏窗口
    if (show_new_window) {
        ImGui::Begin("New Window", &show_new_window, ImGuiWindowFlags_AlwaysAutoResize);
        // 添加第一个输入框
        ImGui::Text("seconds"); // 文本说明
        ImGui::SameLine(); // 将文本和输入框放在同一行
        ImGui::InputText(" ", input_text1, IM_ARRAYSIZE(input_text1), ImGuiInputTextFlags_CharsDecimal); // 输入框
        ImGui::Text("please enter the seconds you want to maintain"); // 文本说明
        if (ImGui::Button("true"))
        {
            if (strlen(input_text1) != 0) 
            {
                std::cout << "tempI is :" << tempI << std::endl;
                if (!LeftOrRight)
                {
                    std::cout << "keyMap[tempI] is :" << keyMapL[tempI] << std::endl;
                    AddItem(keyMapL[tempI], std::stoi(input_text1));
                }
                else
                {
                    std::cout << "keyMap[tempI] is :" << keyMapR[tempI] << std::endl;
                    AddItem(keyMapR[tempI], std::stoi(input_text1));
                }
            }
            show_new_window = false;
        }
        ImGui::End();
    }

    // 显示悬浮菜单
    if (ImGui::BeginPopup("image_popup")) {
        if (ImGui::MenuItem("add item")) {
            // 如果选择了“添加”选项，执行相关操作
            std::cout << "Add option selected!" << std::endl;
            show_new_window = true;
            // 在这里添加“添加”选项的处理逻辑
        }
        ImGui::EndPopup();
    }

    // 恢复默认边框大小
    ImGui::PopStyleVar();
    // 结束窗口
    ImGui::End();
}

// file_name: 这是要加载的图片文件的路径。
// out_srv : 这是一个指向 ID3D11ShaderResourceView 指针的指针，用于存储生成的纹理资源视图。这个视图可以用来在 Direct3D 11 中渲染纹理。
// out_width和out_height : 这两个指针用于返回加载的图片的宽度和高度。
// g_pd3dDevice : 这是 Direct3D 11 设备对象，用于创建纹理资源。
ImTextureID LoadTextureFromFile(const char* file_name, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height, ID3D11Device* g_pd3dDevice)
{
    // 1.打开文件
    FILE* f = fopen(file_name, "rb");
    if (f == NULL)
    {
        fclose(f);
        return false;
    }
    // 获取文件大小
    fseek(f, 0, SEEK_END);
    size_t file_size = (size_t)ftell(f);
    if (file_size == -1)
        return false;
    // 读取文件内容
    fseek(f, 0, SEEK_SET);
    void* file_data = IM_ALLOC(file_size);
    fread(file_data, 1, file_size, f);
    // 从内存加载图片纹理
    bool ret = LoadTextureFromMemory(file_data, file_size, out_srv, out_width, out_height, g_pd3dDevice);
    //释放内存
    IM_FREE(file_data);

    if (!ret)
    {
        std::cerr << "Failed to load texture from memory: " << file_name << std::endl;
    }
    fclose(f);
    return (ImTextureID)*out_srv;
}

// Simple helper function to load an image into a DX11 texture with common settings
bool LoadTextureFromMemory(const void* data, size_t data_size, ID3D11ShaderResourceView** out_srv, int* out_width, int* out_height, ID3D11Device* g_pd3dDevice)
{
    // Load from disk into a raw RGBA buffer
    int image_width = 0;
    int image_height = 0;
    unsigned char* image_data = stbi_load_from_memory((const unsigned char*)data, (int)data_size, &image_width, &image_height, NULL, 4);
    if (image_data == NULL)
        return false;
    // Create texture
    D3D11_TEXTURE2D_DESC desc;
    ZeroMemory(&desc, sizeof(desc));
    desc.Width = image_width;
    desc.Height = image_height;
    desc.MipLevels = 1;
    desc.ArraySize = 1;
    desc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    desc.SampleDesc.Count = 1;
    desc.Usage = D3D11_USAGE_DEFAULT;
    desc.BindFlags = D3D11_BIND_SHADER_RESOURCE;
    desc.CPUAccessFlags = 0;
    ID3D11Texture2D* pTexture = NULL;
    D3D11_SUBRESOURCE_DATA subResource;
    subResource.pSysMem = image_data;
    subResource.SysMemPitch = desc.Width * 4;
    subResource.SysMemSlicePitch = 0;
    g_pd3dDevice->CreateTexture2D(&desc, &subResource, &pTexture);

    // Create texture view
    D3D11_SHADER_RESOURCE_VIEW_DESC srvDesc;
    ZeroMemory(&srvDesc, sizeof(srvDesc));
    srvDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    srvDesc.ViewDimension = D3D11_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MipLevels = desc.MipLevels;
    srvDesc.Texture2D.MostDetailedMip = 0;
    g_pd3dDevice->CreateShaderResourceView(pTexture, &srvDesc, out_srv);
    pTexture->Release();
    *out_width = image_width;
    *out_height = image_height;
    stbi_image_free(image_data);

    return true;
}
