# Visual Specification

> 本文档定义 PICO-UISet 的视觉 Design Tokens，作为所有组件视觉实现的唯一权威来源。
> 状态: 待 Figma 同步 | 当前为占位值

## 1. Colors

### Primary
| Token | Value | 用途 |
|-------|-------|------|
| `color.primary.default` | `#2B6EF6` | 主操作色（按钮、高亮） |
| `color.primary.hover` | `#1A5FE6` | Hover 状态 |
| `color.primary.pressed` | `#0E4FD6` | Pressed 状态 |
| `color.primary.disabled` | `#2B6EF680` | Disabled（50% 透明度） |

### Surface
| Token | Value | 用途 |
|-------|-------|------|
| `color.surface.background` | `#1A1A2E` | 全局背景 |
| `color.surface.panel` | `#25253E` | Panel/Card 背景 |
| `color.surface.elevated` | `#2F2F4A` | 悬浮层/Menu |
| `color.surface.overlay` | `#00000080` | 遮罩层 |

### Text
| Token | Value | 用途 |
|-------|-------|------|
| `color.text.primary` | `#FFFFFFEE` | 主文本 |
| `color.text.secondary` | `#FFFFFFAA` | 次要文本 |
| `color.text.disabled` | `#FFFFFF55` | 禁用文本 |
| `color.text.inverse` | `#1A1A2E` | 反色文本 |

### Border
| Token | Value | 用途 |
|-------|-------|------|
| `color.border.default` | `#FFFFFF1A` | 默认边框 |
| `color.border.focus` | `#2B6EF6` | Focus Ring |
| `color.border.error` | `#F5222D` | 错误状态 |

## 2. Typography

| Token | Size (px) | Weight | Line Height | 用途 |
|-------|-----------|--------|-------------|------|
| `typo.heading.xl` | 32 | Bold | 1.3 | 页面标题 |
| `typo.heading.lg` | 24 | Bold | 1.3 | 区域标题 |
| `typo.heading.md` | 20 | SemiBold | 1.4 | 卡片标题 |
| `typo.heading.sm` | 16 | SemiBold | 1.4 | 小标题 |
| `typo.body.lg` | 16 | Regular | 1.5 | 正文大 |
| `typo.body.md` | 14 | Regular | 1.5 | 正文默认 |
| `typo.caption.md` | 12 | Regular | 1.4 | 说明文字 |
| `typo.caption.sm` | 10 | Regular | 1.4 | 极小文字 |

## 3. Spacing

| Token | Value (px) | 用途 |
|-------|-----------|------|
| `spacing.xs` | 4 | 图标与文字间距 |
| `spacing.sm` | 8 | 组件内边距 |
| `spacing.md` | 12 | 元素间距 |
| `spacing.lg` | 16 | 区域间距 |
| `spacing.xl` | 24 | 大区块间距 |
| `spacing.xxl` | 32 | 页面边距 |

## 4. Corner Radius

| Token | Value (px) | 用途 |
|-------|-----------|------|
| `radius.sm` | 4 | 小元素（Tag, Badge） |
| `radius.md` | 8 | 中等元素（Button, Input） |
| `radius.lg` | 12 | 卡片/Panel |
| `radius.xl` | 16 | 弹窗/Dialog |
| `radius.full` | 9999 | 圆形元素 |

## 5. Elevation / Shadow

| Token | Value | 用途 |
|-------|-------|------|
| `elevation.none` | none | 默认平面 |
| `elevation.sm` | `0 2px 4px #00000040` | 轻微抬升 |
| `elevation.md` | `0 4px 12px #00000060` | 悬浮层 |
| `elevation.lg` | `0 8px 24px #00000080` | Modal/Dialog |

## 6. Motion / Transition

| Token | Duration | Easing | 用途 |
|-------|----------|--------|------|
| `motion.fast` | 100ms | ease-out | 状态反馈（hover） |
| `motion.normal` | 200ms | ease-in-out | 常规过渡 |
| `motion.slow` | 350ms | ease-in-out | 展开/收起 |
| `motion.spring` | 400ms | cubic-bezier(0.34,1.56,0.64,1) | 弹性动画 |

---

> **Figma 同步说明**: 以上值为初始占位。执行 `figma-to-specify` Skill 后将自动替换为 Figma 中的实际值。
