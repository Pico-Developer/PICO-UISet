# Test Baseline

> 测试金字塔、覆盖率标准与基线用例定义。

## 1. 测试金字塔

```
           ┌───────────────┐
           │ Visual Reg.  │  ← 截图对比 (可选)
           ├───────────────┤
           │ XR Integr.  │  ← XR Mock 环境
        ┌──┴───────────────┴──┐
        │  Component Tests   │  ← PlayMode
     ┌──┴───────────────────┴──┐
     │     Unit Tests         │  ← EditMode
     └───────────────────────┘
```

## 2. 覆盖率标准

| 层级 | 最低覆盖 | 目标覆盖 | 说明 |
|------|----------|----------|------|
| Unit (EditMode) | 80% | 90% | 纯逻辑、属性、边界值 |
| Component (PlayMode) | 60% | 80% | 生命周期、交互流程 |
| XR Integration | - | 关键路径 | Mock XRI 交互 |
| Visual Regression | - | 可选 | 截图对比 |

## 3. 测试目录结构

```
Tests/
├── EditMode/
│   ├── Slider/
│   │   ├── SliderValueTests.cs
│   │   └── SliderRangeTests.cs
│   └── Switch/
│       └── SwitchToggleTests.cs
├── PlayMode/
│   ├── Slider/
│   │   └── SliderInteractionTests.cs
│   └── Switch/
│       └── SwitchAnimationTests.cs
└── XRIntegration/
    └── XRSliderTests.cs
```

## 4. EditMode 基线用例

| ID | 组件 | 用例 | 期望 |
|----|------|------|------|
| UT_001 | Slider | 设置 value=0.5，读取 | value == 0.5 |
| UT_002 | Slider | 设置 value=1.5 (max=1) | value clamped to 1.0 |
| UT_003 | Slider | 设置 wholeNumbers=true, value=0.7 | value rounded to 1 |
| UT_004 | Switch | 调用 Toggle() | isOn 取反 |
| UT_005 | Switch | Disabled 状态下 Toggle() | isOn 不变 |

## 5. PlayMode 基线用例

| ID | 组件 | 用例 | 期望 |
|----|------|------|------|
| PT_001 | Slider | 拖拽 Handle 到 50% | OnValueChanged 触发, value ≈ 0.5 |
| PT_002 | Slider | 点击 Track 中点 | Handle 动画移动到点击位置 |
| PT_003 | Switch | 点击 Switch | Thumb 动画播放 + isOn 切换 |
| PT_004 | TabBar | 点击第 2 个 Tab | Indicator 滑动动画 + 内容切换 |
| PT_005 | Menu | 点击外部区域 | Menu 关闭动画 |

## 6. XR Integration 基线用例

| ID | 组件 | 用例 | 期望 |
|----|------|------|------|
| XR_001 | Slider | XR Ray 悬停在 Handle | Hover 状态触发 |
| XR_002 | Slider | XR Pinch + Drag | Handle 跟随手势移动 |
| XR_003 | Switch | XR Poke 点击 | Toggle 状态切换 |
| XR_004 | Menu | XR Ray + Trigger | Menu Item 选中 |

## 7. Visual Regression 规则

- **基线图管理**: `Tests/VisualBaselines/{Component}/{State}.png`
- **差异阈值**: 像素差异 < 0.5%
- **更新流程**: 视觉变更时手动更新基线图，随 MR 提交
- **环境要求**: 固定分辨率 1920x1080，Linear 色彩空间
