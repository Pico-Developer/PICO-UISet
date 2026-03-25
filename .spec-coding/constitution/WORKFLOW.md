# Workflow

> 定义 Spec Coding 的 9 阶段工作流程。

## 工作流总览

```
需求输入 → Plan → Tasks → Implement → 测试 → 修复 → 文档输出 → 交付确认 → 归档评估
  ①       ②      ③       ④        ⑤     ⑥       ⑦         ⑧          ⑨
```

## 各阶段详细说明

### ① 需求输入
- **输入**: 需求描述（自然语言 / Figma 链接 / Issue）
- **输出**: REQ-{ID} 目录创建
- **检查点**: 需求已记录，有唯一 ID

### ② Plan
- **输入**: 需求描述 + Constitution 层约束 + Specify 层规范
- **输出**: `plan.md`（目标、范围、依赖、风险）
- **检查点**: Plan 已 review，范围明确
- **角色**: AI 负责起草，Human 确认

### ③ Tasks
- **输入**: `plan.md`
- **输出**: `tasks.md`（任务分解、优先级、依赖关系）
- **检查点**: 任务粒度合理（单任务 ≤ 2h），无循环依赖
- **角色**: AI 拆解，Human 确认优先级

### ④ Implement
- **输入**: `tasks.md` + Constitution/Specify 约束
- **输出**: 代码文件 + `implement.md`（变更清单）
- **检查点**: 代码符合 CODE_SPEC，层级符合 HIERARCHY_SPEC
- **角色**: AI 编码，Human review

### ⑤ 测试
- **输入**: 代码 + TEST_BASELINE
- **输出**: 测试用例 + 测试报告
- **检查点**: 覆盖率达标，无 FAIL case
- **角色**: AI 编写测试，CI 执行

### ⑥ 修复
- **输入**: 测试报告中的 FAIL 用例
- **输出**: 修复代码 + 更新 implement.md
- **检查点**: 所有 FAIL case 修复
- **角色**: AI 修复，Human 确认

### ⑦ 文档输出
- **输入**: 代码 + implement.md
- **输出**: 组件文档（按 DOC_TEMPLATE）
- **检查点**: API 文档完整，示例可运行
- **角色**: AI 生成，Human review

### ⑧ 交付确认
- **输入**: 所有产出物
- **输出**: MR 提交 + 版本标记
- **检查点**: MR 已 review，CI 通过，无未解决 TODO
- **角色**: Human 最终确认

### ⑨ 归档评估（可选）
- **输入**: 已交付的 REQ-{ID} 需求
- **输出**: `git mv` 需求目录到 `archive/v{version}/`
- **触发方式**: 人工决定，脚本执行（`scripts/archive-req.sh`）
- **归档条件**（需全部满足）:
  1. **需求已交付**: implement.md 自检全部 PASS，MR 已合入
  2. **无活跃引用**: 没有其他进行中的 REQ 依赖此需求
  3. **过冷却期**: 合入后至少经过 1 个版本周期（如 v0.0.2 → v0.0.3）
- **归档路径**: `.spec-coding/archive/v{version}/REQ-{ID}_{name}/`
- **角色**: Human 判断 + 脚本自动执行

## Checkpoint 矩阵

| 阶段 | 产出物 | 质量门 | 决策者 | 阻断 |
|------|---------|--------|--------|------|
| ① 需求 | REQ 目录 | ID 唯一 | Human | 是 |
| ② Plan | plan.md | 范围清晰 | Human | 是 |
| ③ Tasks | tasks.md | 粒度合理 | Human | 建议 |
| ④ Implement | 代码 + implement.md | CODE_SPEC 合规 | Human | 关键任务时 |
| ⑤ 测试 | 测试报告 | 覆盖率达标 | CI | 是 |
| ⑥ 修复 | 修复代码 | 全 PASS | CI | 是 |
| ⑦ 文档 | 组件文档 | 模板完整 | Human | 建议 |
| ⑧ 交付 | MR | CI 通过 | Human | 是 |
| ⑨ 归档 | archive/ 移动 | 3 项条件满足 | Human | 否 |

---

> **注意**: 每个阶段的产出物都存放在对应的 `requirements/REQ-{ID}_*/` 目录下。只有当前阶段的检查点通过后，才能进入下一阶段。阶段⑨为非阻断的可选阶段，不影响正常开发流程。
