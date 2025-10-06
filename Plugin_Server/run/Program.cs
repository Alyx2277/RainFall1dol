using Microsoft.Extensions.Hosting;
using VTS.Core;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace VTSBatchHotkeySender
{
    // 热键任务模型：与JSON配置文件结构对应
    public class HotkeyTask
    {
        [JsonProperty("hotkeyId")]
        public string HotkeyId { get; set; }

        [JsonProperty("delaySeconds")]
        public double DelaySeconds { get; set; }

        [JsonProperty("description")]
        public string Description { get; set; } // 可选：热键描述，用于日志显示
    }

    class Program
    {
        // 配置文件路径（可根据需要修改）
        private const string CONFIG_FILE_PATH = "hotkeys_config.json";

        static async Task Main(string[] args)
        {
            // 创建主机构建器保持程序运行
            HostApplicationBuilder builder = Host.CreateApplicationBuilder(args);

            // 初始化控制台日志（使用具体实现类而非接口）
            ConsoleVTSLoggerImpl logger = new ConsoleVTSLoggerImpl();
            logger.Log("VTS批量热键发送工具启动...");

            // 加载热键配置（从JSON文件或使用默认配置）
            List<HotkeyTask> hotkeyTasks = LoadHotkeyConfig(logger);
            if (hotkeyTasks == null || hotkeyTasks.Count == 0)
            {
                logger.LogWarning("未加载到有效热键配置，程序将退出");
                return;
            }

            // 初始化VTS插件核心
            //CoreVTSPlugin plugin = new CoreVTSPlugin(
            //    logger: logger,
            //    reconnectIntervalMs: 1000,
            //    pluginName: "BatchHotkeySender",
            //    pluginDeveloper: "YourName",
            //    pluginIcon: ""
            //);
            CoreVTSPlugin plugin = new(logger, 100, "My simple plugin", "Perfect Programmer", "");
            try
            {
                // 初始化插件连接
                await plugin.InitializeAsync(
                    new WebSocketImpl(logger),
                    new NewtonsoftJsonUtilityImpl(),
                    new TokenStorageImpl(""),
                    () => logger.LogWarning("Disconnected!"));
                logger.Log("Connected!");

                // 显示VTS和模型信息
                var apiState = await plugin.GetAPIState();
                logger.Log($"当前VTS版本: {apiState.data.vTubeStudioVersion}");

                var currentModel = await plugin.GetCurrentModel();
                logger.Log($"当前模型: {currentModel.data.modelName}");

                // 执行热键任务
                await ExecuteHotkeyTasks(plugin, logger, hotkeyTasks);
                logger.Log("所有热键任务已执行完成");
            }
            catch (VTSException ex)
            {
                logger.LogError($"VTS操作异常: {ex.Message})");
            }
            catch (Exception ex)
            {
                logger.LogError($"系统异常: {ex.Message}");
            }

            // 保持程序运行
            var host = builder.Build();
            await host.RunAsync();
        }

        /// <summary>
        /// 从JSON配置文件加载热键任务列表
        /// </summary>
        private static List<HotkeyTask> LoadHotkeyConfig(ConsoleVTSLoggerImpl logger)
        {
            try
            {
                // 检查配置文件是否存在
                if (!File.Exists(CONFIG_FILE_PATH))
                {
                    logger.LogWarning($"配置文件 {CONFIG_FILE_PATH} 不存在，将创建默认配置文件");
                    return CreateDefaultConfigFile(logger);
                }

                // 读取并解析JSON文件
                string jsonContent = File.ReadAllText(CONFIG_FILE_PATH);
                var tasks = JsonConvert.DeserializeObject<List<HotkeyTask>>(jsonContent);

                if (tasks == null)
                {
                    logger.LogWarning("配置文件解析结果为空，使用默认配置");
                    return GetDefaultTasks();
                }

                logger.Log($"成功从 {CONFIG_FILE_PATH} 加载 {tasks.Count} 个热键任务");
                return tasks;
            }
            catch (JsonException ex)
            {
                logger.LogError($"配置文件格式错误: {ex.Message}，使用默认配置");
                return GetDefaultTasks();
            }
            catch (Exception ex)
            {
                logger.LogError($"加载配置文件失败: {ex.Message}，使用默认配置");
                return GetDefaultTasks();
            }
        }

        /// <summary>
        /// 创建默认配置文件
        /// </summary>
        private static List<HotkeyTask> CreateDefaultConfigFile(ConsoleVTSLoggerImpl logger)
        {
            try
            {
                var defaultTasks = GetDefaultTasks();
                string json = JsonConvert.SerializeObject(defaultTasks, Formatting.Indented);
                File.WriteAllText(CONFIG_FILE_PATH, json);
                logger.Log($"已创建默认配置文件: {CONFIG_FILE_PATH}");
                return defaultTasks;
            }
            catch (Exception ex)
            {
                logger.LogError($"创建默认配置文件失败: {ex.Message}");
                return GetDefaultTasks();
            }
        }

        /// <summary>
        /// 获取默认热键任务列表
        /// </summary>
        private static List<HotkeyTask> GetDefaultTasks()
        {
            return new List<HotkeyTask>
            {
                new HotkeyTask
                {
                    HotkeyId = "anim_wave",
                    DelaySeconds = 1.0,
                    Description = "挥手动画"
                },
                new HotkeyTask
                {
                    HotkeyId = "expr_smile",
                    DelaySeconds = 2.0,
                    Description = "微笑表情"
                },
                new HotkeyTask
                {
                    HotkeyId = "move_left",
                    DelaySeconds = 1.5,
                    Description = "向左移动"
                }
            };
        }

        /// <summary>
        /// 执行热键任务列表
        /// </summary>
        private static async Task ExecuteHotkeyTasks(
            CoreVTSPlugin plugin,
            ConsoleVTSLoggerImpl logger,
            List<HotkeyTask> tasks)
        {
            logger.Log($"开始执行热键任务，共 {tasks.Count} 个任务");

            for (int i = 0; i < tasks.Count; i++)
            {
                var task = tasks[i];
                try
                {
                    // 显示任务信息（带序号）
                    string taskInfo = $"任务 {i + 1}/{tasks.Count}: {task.Description ?? task.HotkeyId}";
                    logger.Log($"{taskInfo} - 等待 {task.DelaySeconds} 秒");

                    // 等待延迟时间
                    await Task.Delay(TimeSpan.FromSeconds(task.DelaySeconds));

                    // 触发热键
                    var response = await plugin.TriggerHotkey(task.HotkeyId);
                    //logger.Log($"{taskInfo} - 触发成功 (响应: {response.status})");
                }
                catch (VTSException ex)
                {
                    logger.LogError(
                        $"任务 {i + 1}/{tasks.Count} 失败: {ex.Message} " +
                        $"(热键ID: {task.HotkeyId})"
                    );
                }
            }
        }
    }
}
