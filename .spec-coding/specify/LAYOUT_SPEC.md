# Layout Specification

> 定义全局布局规则与各组件的布局规范。

## 1. 全局布局规则

### 基础分辨率
- **设计基准**: 1920 x 1080 px（平面 UI 渲染）
- **XR World Space**: 1 Unity Unit = 1 meter，UI Panel 默认尺寸 0.4m x 0.3m
- **安全边距**: 左右 24px / 上下 16px

### 栅格系统
- **基础单元**: 8px（所有尺寸必须为 8 的倍数）
- **列数**: 12 列（可自适应折叠）
- **列间距**: 16px

### 自适应规则
| 宽度区间 | 列数 | 边距 | 场景 |
|-----------|------|------|------|
| < 480px | 4 | 16px | 小 Panel |
| 480-960px | 8 | 20px | 中 Panel |
| > 960px | 12 | 24px | 大 Panel / Overlay |

## 2. 组件布局规范

### 2.1 Slider
- **Track 高度**: 4px
- **Handle 尺寸**: 24 x 24 px
- **点击热区**: Handle 周围扩展 8px（实际 40 x 40 px）
- **最小宽度**: 120px
- **Label 位置**: Handle 正上方，间距 8px

### 2.2 Switch
- **尺寸**: 48 x 28 px
- **Thumb 直径**: 20px（off）/ 24px（on）
- **Thumb 位移**: 20px（左右滑动）
- **点击热区**: 周围扩展 4px
- **Label 间距**: 右侧 12px

### 2.3 TabBar
- **Tab Item 最小宽度**: 64px
- **Tab Item 高度**: 48px
- **Indicator 高度**: 2px
- **水平间距**: 0px（紧密排列）
- **溢出处理**: 水平滚动 + 渐变遮罩

### 2.4 SideNavigation
- **宽度**: 240px（展开）/ 56px（收起）
- **Nav Item 高度**: 40px
- **左侧图标尺寸**: 20 x 20 px
- **缩进层级**: 每层 +16px paddingLeft
- **分组间距**: 8px divider + 8px margin

### 2.5 PanelLayout
- **Header 高度**: 56px
- **内容区 Padding**: 24px
- **Footer 高度**: 48px（可选）
- **圆角**: radius.lg (12px)
- **最小尺寸**: 280 x 200 px
- **最大尺寸**: 跟随父容器

### 2.6 Menu
- **最小宽度**: 160px
- **最大宽度**: 320px
- **Menu Item 高度**: 36px
- **Padding**: 上下 4px
- **分割线**: 1px, 上下 margin 4px
- **子菜单偏移**: 右侧 4px

### 2.7 ToolBar
- **高度**: 48px
- **工具按钮尺寸**: 32 x 32 px
- **按钮间距**: 4px
- **分组 Divider**: 1px width, 上下 padding 8px
- **溢出处理**: 折叠到 "more" 按钮

### 2.8 List
- **Item 高度**: 48px（单行）/ 68px（双行）
- **左侧图标区**: 40px 宽
- **右侧操作区**: 自适应宽度
- **分割线**: Inset 56px（跳过图标区）
- **滚动处理**: 可回收 VirtualizedList

---

> **注意**: 所有 px 值为平面 UI 设计值。World Space 中需按 Panel 分辨率比例转换。
