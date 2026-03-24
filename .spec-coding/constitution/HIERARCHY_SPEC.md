# HIERARCHY_SPEC — PICO UI 组件层级标准

> 版本: 1.0.0 | 创建: 2026-03-24 | 状态: 生效中

## 变更日志

| 日期 | 版本 | 变更内容 | 变更人 |
|------|------|---------|--------|
| 2026-03-24 | 1.0.0 | 初始版本 | Spec Coding Init |

---

## 标准层级结构

所有 PICO UI 组件必须遵循以下 4 层标准结构：

```
ComponentRoot (PXR_{Component})          ← 挂载主控脚本 + RectTransform
├── Handle                               ← 交互热区（IPointer* 事件接收）
├── Visual                               ← 视觉表现层
│   ├── Background                       ← 底色/底板
│   ├── Icon_Leading                     ← 前置图标（可选）
│   ├── Content                          ← 内容区
│   │   ├── Title                        ← 主文本 (TMP)
│   │   └── Subtitle                     ← 副文本 (TMP, 可选)
│   ├── Trailing_Accessories             ← 尾部附件区（Badge/Arrow 等）
│   └── Divider                          ← 分割线（可选）
└── Group                                ← 子组件容器（可选，用于复合组件）
    └── ChildItem[n]                     ← 子项
```

## 各层职责

### ComponentRoot

| 属性 | 要求 |
|------|------|
| 必挂组件 | `RectTransform` (通过 `[RequireComponent]`) |
| 主控脚本 | `PXR_{Component}Controller` 或继承自 `PXR_UIInputHandler` |
| 职责 | 状态管理、对外 API、事件分发 |

### Handle

| 属性 | 要求 |
|------|------|
| 职责 | 定义交互热区，接收指针/射线事件 |
| 尺寸规则 | XR 模式下最小 40x40 (满足 Fitts' Law) |
| 实现方式 | 透明 `Image` + `Raycast Target = true` |
| 特殊要求 | Handle 的尺寸可以大于 Visual，用于扩大可点击范围 |

### Visual

| 属性 | 要求 |
|------|------|
| 职责 | 纯视觉渲染，不包含交互逻辑 |
| Raycast | 所有子节点 `Raycast Target = false`（避免事件拦截） |
| 状态驱动 | 通过 `VisualController` 接收状态变更，刷新外观 |
| Design Token | 所有颜色/尺寸/字体引用必须来自 Theme (ScriptableObject) |

### Group

| 属性 | 要求 |
|------|------|
| 职责 | 容纳子组件（如 TabBar 的 Tab 项、SideNav 的菜单项） |
| 布局 | 使用 `HorizontalLayoutGroup` / `VerticalLayoutGroup` / `GridLayoutGroup` |
| 子项类型 | 每个子项自身也遵循 ComponentRoot 结构（递归适用） |

## 命名规范

| 节点 | 命名规则 | 示例 |
|------|---------|------|
| Root | `PXR_{Component}` | `PXR_Slider` |
| Handle | `Handle` 或 `Handle_{Part}` | `Handle`, `Handle_Thumb` |
| Visual 子节点 | `{Role}` | `Background`, `Icon_Leading`, `Title` |
| Group | `Group` 或 `Group_{Type}` | `Group`, `Group_Tabs` |
| 子项 | `Item_{Index}` 或语义名 | `Item_0`, `Tab_Home` |

## 组件类型分类

| 类型 | 特征 | 有 Handle? | 有 Group? | 示例 |
|------|------|-----------|-----------|------|
| 原子组件 | 不可再分 | ✅ | ❌ | Switch, Slider |
| 复合组件 | 包含子组件 | ✅ (根级) | ✅ | TabBar, SideNav |
| 布局组件 | 管理子项排列 | ❌ | ✅ | PanelLayout, ToolBar |

## Prefab 交付标准

- Prefab 根节点必须挂载主控脚本
- 所有内部引用必须在 Prefab 内完成（不允许外部引用断裂）
- 必须包含默认 Theme 引用
- 必须在 `OnValidate()` 中验证必要子节点存在