# ENV_CHECK — PICO UI 环境自检清单

> 版本: 1.0.0 | 创建: 2026-03-24 | 状态: 生效中

## 变更日志

| 日期 | 版本 | 变更内容 | 变更人 |
|------|------|---------|--------|
| 2026-03-24 | 1.0.0 | 初始版本 | Spec Coding Init |

---

## 自检项清单

ENV_001~ENV_007 详细定义见此文件完整版。

### ENV_001: Canvas 存在性 (P0)
检查场景中是否存在 Canvas。失败时自动创建。

### ENV_002: CanvasScaler 配置 (P0)
检查 UIScaleMode = ScaleWithScreenSize, referenceResolution = (1920, 1080)。

### ENV_003: GraphicRaycaster (P0)
检查 Canvas 上是否挂载 GraphicRaycaster。

### ENV_004: EventSystem 存在性 (P0)
检查场景中是否存在 EventSystem。当前 PICOUICreator.cs 缺失此检查。

### ENV_005: TextMeshPro 资源 (P1)
检查 TMP Essential Resources 是否已导入。

### ENV_006: XR Interaction Toolkit (P1)
检查 com.unity.xr.interaction.toolkit >= 2.0.0。

### ENV_007: Canvas RenderMode (P2)
检查 Canvas.renderMode 是否与当前平台匹配。

## 自检执行时机

- Implement 阶段开始前 (AI 自动)
- 创建新 Prefab 时 (PICOUICreator 菜单)
- PlayMode 进入时 (RuntimeInitializeOnLoadMethod)