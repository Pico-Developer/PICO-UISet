# Environment Check

> 开发环境自检清单，确保 Spec Coding 工作流正常运行。

## 检查项总览

| ID | 检查项 | 要求 | 检查方式 |
|----|---------|------|----------|
| ENV_001 | Unity 版本 | 2022.3 LTS (2022.3.x) | `Application.unityVersion` |
| ENV_002 | 渲染管线 | URP | `GraphicsSettings.renderPipelineAsset` |
| ENV_003 | XR Interaction Toolkit | v2.0.0+ | Package Manager 检查 |
| ENV_004 | TextMeshPro | 已安装 | Package Manager 检查 |
| ENV_005 | .NET 目标 | .NET Standard 2.1 | Player Settings |
| ENV_006 | Color Space | Linear | Player Settings |
| ENV_007 | Target Platform | Android (Quest/PICO) | Build Settings |

## 详细说明

### ENV_001: Unity 版本
- **最低版本**: 2022.3.0f1
- **推荐版本**: 2022.3 最新 patch
- **检查逻辑**: 解析 `Application.unityVersion` 确认主版本号为 2022.3
- **失败处理**: 报错并终止，提示用户切换 Unity 版本

### ENV_002: 渲染管线
- **要求**: 必须使用 Universal Render Pipeline (URP)
- **检查逻辑**: 检查 `GraphicsSettings.currentRenderPipeline` 类型是否为 `UniversalRenderPipelineAsset`
- **失败处理**: 警告，部分功能可能异常

### ENV_003: XR Interaction Toolkit
- **最低版本**: 2.0.0
- **检查逻辑**: 通过 `UnityEditor.PackageManager.Client.List()` 检查 `com.unity.xr.interaction.toolkit`
- **失败处理**: XR 相关组件功能受限，警告提示

### ENV_004: TextMeshPro
- **检查逻辑**: 检查 `com.unity.textmeshpro` 包是否存在
- **失败处理**: 文本渲染功能异常，报错

### ENV_005: .NET 目标
- **要求**: .NET Standard 2.1 或 .NET Framework
- **检查逻辑**: `PlayerSettings.GetApiCompatibilityLevel()`
- **失败处理**: 警告，部分 API 可能不可用

### ENV_006: Color Space
- **要求**: Linear
- **检查逻辑**: `PlayerSettings.colorSpace == ColorSpace.Linear`
- **失败处理**: 警告，颜色表现可能与设计稿不一致

### ENV_007: Target Platform
- **要求**: Android (PICO/Quest XR 平台)
- **检查逻辑**: `EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android`
- **失败处理**: 仅警告，不阻断开发

## 自检脚本用法

```csharp
// 在 Editor 中执行:
// Menu: PICO UI > Spec Coding > Environment Check
[MenuItem("PICO UI/Spec Coding/Environment Check")]
public static void RunEnvCheck() {
    // TODO: 实现 ENV_001 ~ ENV_007 检查
}
```

## 自检执行时机

- Implement 阶段开始前 (AI 自动)
- 创建新 Prefab 时 (PICOUICreator 菜单)
- PlayMode 进入时 (RuntimeInitializeOnLoadMethod)
