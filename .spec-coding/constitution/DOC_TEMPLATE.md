# Document Templates

> 所有 Spec Coding 输出文档的标准模板。

## 1. Plan 模板

```markdown
# REQ-{ID}: {Title}

## Plan

- **需求 ID**: REQ-{ID}
- **标题**: {Title}
- **状态**: Draft | In Progress | Completed
- **创建时间**: {YYYY-MM-DD}

### 目标
{描述需求目标}

### 范围
1. {功能范围点 1}
2. {功能范围点 2}

### 依赖
- {列出前置依赖}

### 风险
- {列出潜在风险}
```

## 2. Tasks 模板

```markdown
# REQ-{ID}: Tasks

| ID | 任务 | 状态 | 负责 |
|----|------|------|------|
| T1 | {任务描述} | Todo | {AI/Human} |
| T2 | {任务描述} | Todo | {AI/Human} |

## 任务详情

### T1: {标题}
- **输入**: {依赖什么}
- **输出**: {产出什么}
- **验收**: {完成标准}
```

## 3. Implement 模板

```markdown
# REQ-{ID}: Implementation Record

## 变更清单

| # | 文件 | 操作 | 说明 |
|---|------|------|------|
| 1 | {path} | Add/Modify/Delete | {说明} |

## 自检结果

| 检查项 | 结果 | 备注 |
|---------|------|------|
| {检查项} | PASS/FAIL | |

## 遗留事项

1. {待解决问题}
```

## 4. Component 文档模板

```markdown
# {ComponentName}

## 概述
{组件功能描述}

## API

### Properties
| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| {name} | {type} | {default} | {描述} |

### Events
| 事件 | 参数 | 触发时机 |
|------|------|----------|
| {name} | {type} | {描述} |

### Methods
| 方法 | 参数 | 返回值 | 说明 |
|------|------|--------|------|
| {name} | {params} | {return} | {描述} |

## 层级结构
{ComponentName}
├── Handle/
├── Visual/
└── Group/

## 状态机
| 状态 | 视觉变化 | 触发条件 |
|------|----------|----------|
| Normal | {描述} | 默认状态 |
| Hovered | {描述} | Pointer Enter |

## 使用示例
// C# 示例代码
```

---

> **使用说明**: 新建需求时，复制对应模板到 `requirements/REQ-{ID}_{name}/` 目录下，填充具体内容。
