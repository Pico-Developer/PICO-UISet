# CODE_SPEC — PICO UI 编码规范

> 版本: 1.0.0 | 创建: 2026-03-24 | 状态: 生效中

## 变更日志

| 日期 | 版本 | 变更内容 | 变更人 |
|------|------|---------|--------|
| 2026-03-24 | 1.0.0 | 初始版本 | Spec Coding Init |

---

## CODE_001: 命名空间

所有运行时代码必须位于 `ByteDance.PICO.UI` 命名空间下，编辑器代码位于 `ByteDance.PICO.UI.Editor`。

```csharp
// Runtime
namespace ByteDance.PICO.UI
{
    public class PXR_SliderVisualController : MonoBehaviour { }
}

// Editor
namespace ByteDance.PICO.UI.Editor
{
    public class PICOUICreator { }
}
```

## CODE_002: 文件命名

| 类型 | 规则 | 示例 |
|------|------|------|
| MonoBehaviour | `PXR_{ComponentName}{Role}.cs` | `PXR_SliderVisualController.cs` |
| ScriptableObject | `PXR_{Name}Config.cs` / `PXR_{Name}Theme.cs` | `PXR_UITheme.cs` |
| Editor 脚本 | `PXR_{Name}Editor.cs` / `PXR_{Name}Creator.cs` | `PICOUICreator.cs` |
| Interface | `IPXR_{Name}.cs` | `IPXR_Interactable.cs` |
| Enum | 定义在所属类内部或 `PXR_UIEnums.cs` 中 | — |

## CODE_003: 组件标注

所有可在 Inspector 中配置的公共组件必须使用以下特性：

```csharp
[AddComponentMenu("PICO UI/Slider")]
[HelpURL("https://pico-ui-docs/slider")]
[DisallowMultipleComponent]
public class PXR_Slider : PXR_UIInputHandler
{
    [Header("Value")]
    [SerializeField, Range(0f, 1f)] private float _value = 0f;

    [Header("Visual")]
    [SerializeField] private PXR_SliderVisualController _visual;
}
```

## CODE_004: 序列化字段规范

- 所有序列化字段使用 `[SerializeField] private` + 公共属性暴露
- 禁止使用 `public` 字段
- 必须使用 `[Header]` 分组、`[Tooltip]` 说明用途
- 数值字段必须使用 `[Range]` 或 `[Min]` 约束范围

```csharp
// ✅ 正确
[SerializeField, Tooltip("滑块当前值"), Range(0f, 1f)]
private float _value = 0f;
public float Value
{
    get => _value;
    set => SetValue(value);
}

// ❌ 错误
public float value;
```

## CODE_005: 事件与回调

- 使用 `UnityEvent<T>` 暴露 Inspector 可配置的回调
- 使用 C# `event Action<T>` 暴露代码层回调
- 命名规范: `On{Action}{Past}` (如 `OnValueChanged`)

```csharp
[Header("Events")]
[SerializeField] private UnityEvent<float> _onValueChanged;

public event Action<float> OnValueChanged;

private void SetValue(float newValue)
{
    _value = Mathf.Clamp01(newValue);
    _onValueChanged?.Invoke(_value);
    OnValueChanged?.Invoke(_value);
}
```

## CODE_006: Null Safety

- 所有 `GetComponent` / `Find` 操作必须进行 null 检查
- Editor 脚本使用 `TryGetComponent` 替代 `GetComponent`
- 对外部引用使用 `[SerializeField]` + `OnValidate` 检查

```csharp
private void OnValidate()
{
    if (_visual == null)
        Debug.LogWarning($"[{gameObject.name}] PXR_Slider: Visual controller is not assigned.", this);
}
```

## CODE_007: 日志规范

使用统一前缀格式：`[PICO UI/{Component}]`

```csharp
Debug.Log($"[PICO UI/Slider] Value changed to {_value}");
Debug.LogWarning($"[PICO UI/Slider] Visual controller is null.", this);
Debug.LogError($"[PICO UI/Slider] Failed to initialize: {e.Message}", this);
```

- `Debug.Log` — 仅在开发/调试时使用，发布时通过宏控制
- `Debug.LogWarning` — 可恢复的问题
- `Debug.LogError` — 不可恢复的错误

## CODE_008: 注释规范

所有公共 API 必须使用 XML Doc 注释：

```csharp
/// <summary>
/// 设置滑块的当前值。
/// </summary>
/// <param name="value">目标值，范围 [0, 1]。</param>
/// <param name="animate">是否播放过渡动画。</param>
/// <remarks>
/// 值会被 Clamp 到 [0, 1] 范围内。
/// 触发 <see cref="OnValueChanged"/> 事件。
/// </remarks>
public void SetValue(float value, bool animate = false) { }
```