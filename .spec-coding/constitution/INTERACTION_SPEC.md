# INTERACTION_SPEC — PICO UI 交互状态机规范

> 版本: 1.0.0 | 创建: 2026-03-24 | 状态: 生效中

## 变更日志

| 日期 | 版本 | 变更内容 | 变更人 |
|------|------|---------|--------|
| 2026-03-24 | 1.0.0 | 初始版本 | Spec Coding Init |

---

## 状态定义

所有可交互 PICO UI 组件共享以下状态集：

| 状态 | 枚举值 | 说明 | 视觉表现 |
|------|--------|------|--------|
| **Normal** | 0 | 默认静息态 | 默认样式 |
| **Hovered** | 1 | 指针/射线悬停 | 高亮色、微放大 |
| **Pressed** | 2 | 按下中 | 深色、缩放 |
| **Focused** | 3 | 获取焦点（键盘/手柄导航） | 焦点环 |
| **Disabled** | 4 | 不可交互 | 半透明、灰度 |
| **Dragging** | 5 | 拖拽中（Slider 等） | 拖拽态样式 |
| **Selected** | 6 | 已选中（Toggle/Tab 等） | 选中高亮 |

## 状态机转换图

```
    Normal --PointerEnter--> Hovered --PointerDown--> Pressed
    Normal <--PointerExit-- Hovered <--PointerUp---- Pressed

    (any) --SetInteractable(false)--> Disabled
    Pressed --BeginDrag--> Dragging
    Normal/Hovered --Click--> Selected (Toggle components)
    (any) --Tab--> Focused
```

## 状态优先级

当多个状态同时成立时，按以下优先级决定视觉表现（高→低）：

1. **Disabled** — 最高优先级，覆盖一切
2. **Dragging** — 拖拽中
3. **Pressed** — 按下中
4. **Selected** — 已选中
5. **Focused** — 获取焦点
6. **Hovered** — 悬停
7. **Normal** — 默认

## 接口定义

```csharp
public enum PXR_InteractionState
{
    Normal   = 0,
    Hovered  = 1,
    Pressed  = 2,
    Focused  = 3,
    Disabled = 4,
    Dragging = 5,
    Selected = 6,
}

public interface IPXR_StateVisual
{
    void TransitionToState(PXR_InteractionState state, bool animate = true);
}
```

## XR 特殊规则

| 规则 | 说明 |
|------|------|
| 射线悬停延迟 | XR 射线 Hover 需要 150ms 驻留时间才触发 Hovered |
| 按压确认 | XR Controller Trigger > 0.7 才视为 Pressed |
| 拖拽阈值 | XR 拖拽起始需要 > 5mm 位移 |
| 手势交互 | Hand Tracking Pinch 映射为 Pressed, Pinch+Move 映射为 Dragging |

## VisualController 实现规范

```csharp
public class PXR_SliderVisualController : MonoBehaviour, IPXR_StateVisual
{
    [SerializeField] private PXR_UITheme _theme;

    public void TransitionToState(PXR_InteractionState state, bool animate = true)
    {
        var color = state switch
        {
            PXR_InteractionState.Normal   => _theme.Primary.Default,
            PXR_InteractionState.Hovered  => _theme.Primary.Hover,
            PXR_InteractionState.Pressed  => _theme.Primary.Pressed,
            PXR_InteractionState.Disabled => _theme.Primary.Disabled,
            _ => _theme.Primary.Default,
        };

        if (animate)
            StartCoroutine(AnimateColor(color, _theme.TransitionDuration));
        else
            ApplyColorImmediate(color);
    }
}
```