# Theme Configuration Mapping

> 将 Design Tokens 映射到 Unity ScriptableObject `PXR_UITheme` 的结构定义。

## 1. ScriptableObject 结构

```
PXR_UITheme : ScriptableObject
├── ColorGroup colors
│   ├── PrimaryColors primary   // default, hover, pressed, disabled
│   ├── SurfaceColors surface   // background, panel, elevated, overlay
│   ├── TextColors text         // primary, secondary, disabled, inverse
│   └── BorderColors border     // default, focus, error
├── TypographyGroup typography
│   ├── TypographyStyle headingXL  // fontSize, fontWeight, lineHeight
│   ├── TypographyStyle headingLG
│   ├── TypographyStyle headingMD
│   ├── TypographyStyle headingSM
│   ├── TypographyStyle bodyLG
│   ├── TypographyStyle bodyMD
│   ├── TypographyStyle captionMD
│   └── TypographyStyle captionSM
├── SpacingGroup spacing
│   ├── float xs, sm, md, lg, xl, xxl
└── RadiusGroup radius
    ├── float sm, md, lg, xl
    └── float full
```

## 2. 结构体定义

### ColorGroup
```csharp
[System.Serializable]
public struct PrimaryColors {
    public Color @default;
    public Color hover;
    public Color pressed;
    public Color disabled;
}

[System.Serializable]
public struct SurfaceColors {
    public Color background;
    public Color panel;
    public Color elevated;
    public Color overlay;
}

[System.Serializable]
public struct TextColors {
    public Color primary;
    public Color secondary;
    public Color disabled;
    public Color inverse;
}

[System.Serializable]
public struct BorderColors {
    public Color @default;
    public Color focus;
    public Color error;
}
```

### TypographyStyle
```csharp
[System.Serializable]
public struct TypographyStyle {
    public float fontSize;
    public FontWeight fontWeight;
    public float lineHeight; // multiplier, e.g. 1.5
}
```

### SpacingGroup / RadiusGroup
```csharp
[System.Serializable]
public struct SpacingGroup {
    public float xs, sm, md, lg, xl, xxl;
}

[System.Serializable]
public struct RadiusGroup {
    public float sm, md, lg, xl, full;
}
```

## 3. Token 导入管线

```
tokens/*.json  ─── ThemeImporter (Editor) ───▶ PXR_UITheme.asset
```

### 导入流程
1. **读取 JSON**: 解析 `tokens/colors.json`, `typography.json`, `spacing.json`
2. **映射 Token**: 按 Token path 对应到 struct 字段
3. **颜色转换**: Hex string → `ColorUtility.TryParseHtmlString` → `Color`
4. **生成 Asset**: `ScriptableObject.CreateInstance<PXR_UITheme>()` → `AssetDatabase.CreateAsset`
5. **校验**: 检查所有必填字段是否已赋值

### 约束
- 颜色值必须为 `#RRGGBB` 或 `#RRGGBBAA` 格式
- fontSize 单位为 px，导入后直接作为 Unity UI fontSize 使用
- spacing/radius 单位为 px
- 每次导入生成新 asset，不覆盖已有自定义
