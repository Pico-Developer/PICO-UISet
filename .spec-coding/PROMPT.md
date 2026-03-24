# Spec Coding 启动 Prompt

> 每次启动新需求时，让 Mira 读取本文件作为 system prompt。
> 用法：对 Mira 说 "读取 `.spec-coding/PROMPT.md`，开始 REQ-{ID} {名称}"

---

你正在为 **PICO-UISet** 项目执行 Spec Coding 工作流。

## 启动前

1. 读取 `.spec-coding/constitution/` 下所有文件，作为**不可违反**的约束
2. 读取 `.spec-coding/specify/` 下所有文件，作为当前视觉/布局/测试基线
3. 确认需求 ID（REQ-{ID}），创建 `requirements/REQ-{ID}_{name}/` 目录
4. 执行 ENV_CHECK.md 中的环境检查（首次 Implement 前）

## 执行流程

严格按 WORKFLOW.md 定义的 **9 阶段**顺序执行：

```
① 需求输入 → ② Plan → ③ Tasks → ④ Implement → ⑤ 测试 → ⑥ 修复 → ⑦ 文档输出 → ⑧ 交付确认 → ⑨ 归档评估
```

## 每阶段必须

- 输出对应文件（plan.md / tasks.md / implement.md）
- 通过 Checkpoint 检查后才能进入下一阶段
- **需要人工确认的阶段（①②③⑧），必须等待用户明确说"继续"**
- 阶段⑨为可选，需满足归档条件后由人工触发

## 约束清单

| 规范 | 约束内容 |
|------|----------|
| CODE_SPEC.md | 命名空间 `ByteDance.PICO.UI`，文件命名，序列化，事件，空安全，日志，XML 注释 |
| HIERARCHY_SPEC.md | Root / Handle / Visual / Group 四层结构 |
| INTERACTION_SPEC.md | 7 状态机 (Normal, Hovered, Pressed, Focused, Disabled, Dragging, Selected) |
| ENV_CHECK.md | Unity 2022.3 LTS, URP, XRI 2.0+, TMP, .NET Standard 2.1, Linear, Android |
| TEST_BASELINE.md | Unit 80%+, Component 60%+, XR 关键路径 |

## Feature 分支规范

- 分支命名: `feat/REQ-{ID}-{short-name}`
- 从 `release/v{current}` 创建
- MR 目标: `release/v{current}`（不是 master）

## 产出物校验

提交 MR 前，确认 `.spec-coding/scripts/validate.py` 检查通过。
