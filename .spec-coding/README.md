# .spec-coding — PICO UI Spec Coding 工作区

> 本目录是 PICO-UISet 项目的 **Specification-driven AI Development** 工作区。
> AI 在执行任何开发任务前，必须先加载此目录中的规范文件。

## 目录结构

```
.spec-coding/
├── README.md                              ← 本文件
├── constitution/                          🔒 基本法（极少修改）
│   ├── CODE_SPEC.md                         编码规范 CODE_001~008
│   ├── HIERARCHY_SPEC.md                    组件层级标准（Root/Handle/Visual/Group）
│   ├── INTERACTION_SPEC.md                  交互状态机规范
│   ├── ENV_CHECK.md                         环境自检清单 ENV_001~007
│   ├── DOC_TEMPLATE.md                      文档输出模板
│   └── WORKFLOW.md                          8阶段工作流定义
│
├── specify/                               📐 项目级技术规格（随设计系统演进）
│   ├── VISUAL_SPEC.md                       视觉规格（Design Tokens 映射）
│   ├── LAYOUT_SPEC.md                       布局与自适应规则
│   ├── THEME_CONFIG.md                      主题配置（ScriptableObject 映射）
│   ├── TEST_BASELINE.md                     测试基线与覆盖率标准
│   ├── token_mapping.json                   Figma 节点名 → Token 语义名映射
│   └── tokens/                              Design Tokens 源文件
│       ├── colors.json
│       ├── typography.json
│       └── spacing.json
│
├── requirements/                          📋 需求维度（按需求编号组织）
│   └── REQ-000_spec-coding-init/
│       ├── plan.md                          技术方案
│       ├── tasks.md                         任务列表
│       └── implement.md                     实施记录
│
└── archive/                               🗄️ 已交付需求归档
    └── .gitkeep
```

## 使用方式

### 对 AI 的指令

在向 AI 提出开发需求时，使用以下格式：

```
新需求: {需求描述}
Figma: {Figma 文件链接, 可选}
编号: REQ-{xxx}
```

AI 将自动执行以下流程：
1. 加载 `constitution/*` 全部规范（只读引用）
2. 检查 `specify/*` 是否需要同步更新
3. 在 `requirements/` 下创建新需求目录
4. 按 WORKFLOW.md 定义的 8 阶段执行

### 各层修改规则

| 层级 | 谁能改 | 怎么改 | 什么时候改 |
|------|--------|--------|-----------|
| `constitution/` | 仅人工审批后 | 修改后必须更新变更日志 | 重大技术决策变更时 |
| `specify/` | AI + 人工 Review | 原地更新，记录 diff | Figma 设计系统更新时 |
| `requirements/` | AI 自动创建 | 每需求一组 Plan/Tasks/Implement | 每个新需求 |
| `archive/` | AI 交付后移入 | 整目录迁移 | 需求交付确认后 |

## 待决策项

| # | 决策项 | 当前假设 | 备注 |
|---|--------|---------|------|
| D1 | 命名空间方案 | `ByteDance.PICO.UI` | 需确认是否与其他 PICO SDK 包冲突 |
| D2 | Design Token 权威源 | Figma (通过 MCP 或 Tokens Studio) | 需确认设计团队工作流 |
| D3 | Handle 实现方式 | 透明 Image + Raycast Target | 需验证 XR 射线兼容性 |
| D4 | XR Interaction Toolkit 版本 | >= 2.0.0 (package.json 已声明) | 需确认是否升级到 3.x |
| D5 | 测试覆盖率标准 | Unit 80%, Component 60% | 需确认团队接受度 |
| D6 | 文档语言 | 中文为主 | 需确认是否需要英文版 |
| D7 | Phase 0 破坏性变更容忍度 | 允许（加命名空间等） | 需确认对下游使用者的影响 |

## Figma 同步

使用 `figma-to-specify` Skill 可自动完成 Figma → Design Tokens → Markdown 的同步：

```
/figma-to-specify <fileKey> [--node <nodeId>] [--diff]
```

首次同步后会生成 `token_mapping.json`，需人工 review 确认命名映射。