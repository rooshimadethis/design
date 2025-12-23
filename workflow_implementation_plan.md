# Design System Integration Plan

I will create a comprehensive set of workflows and rules to implement the "Design OS" methodology in this Flutter repository. The process is split into "Foundation" (Phase 1) and "Feature Design" (Phase 2), mapped to specific workflows.

## User Review Required

> [!NOTE]
> **Phase 2 Integration**: I have added a `design-feature` workflow for Phase 2. It is separate from initialization because you will run it multiple times per prototype.
>
> **Export (Phase 3)**: Excluded for now. Since this is a playground, "export" corresponds to just manually copying the files to your main app later.

## Proposed Changes

### [New Rule] Flutter Design Guidelines
#### [NEW] [.agent/rules/flutter_design_rules.md](file:///Users/rooshi/.gemini/antigravity/brain/b6b0e03c-9ba4-4dd6-bd17-587ecd33a337/.agent/rules/flutter_design_rules.md)
*   **Source**: Adapted from [octolist-design/.claude/skills/frontend-design/SKILL.md](file:///Users/rooshi/Documents/programming/design/octolist-design/.claude/skills/frontend-design/SKILL.md).
*   **Content**:
    *   **Philosophy**: "Bold", "Non-Generic", "Intentional".
    *   **Flutter Specifics**: Theme usage, `CustomPainter`, `BackdropFilter`, etc.

### [New Workflow] Phase 1: New Prototype
#### [NEW] [.agent/workflows/new-prototype.md](file:///Users/rooshi/.gemini/antigravity/brain/b6b0e03c-9ba4-4dd6-bd17-587ecd33a337/.agent/workflows/new-prototype.md)
*   **Goal**: Go from "Empty Folder" to "Running Prototype with Theme".
*   **Steps**:
    1.  **Vision Interview**: Interactive Q&A to define App Goal and Vibe.
    2.  **Scaffold**: Create `lib/prototypes/<name>/` and `main.dart`.
    3.  **Concept Playground**: Generate `design_playground.dart` (a widget to test 3 distinct aesthetic concepts with Toggleable themes).
    4.  **Foundation**: Generate `theme.dart` (color/typo) and `layout_shell.dart` (scaffold/nav).

### [New Workflow] Phase 2: Design Feature
#### [NEW] [.agent/workflows/design-feature.md](file:///Users/rooshi/.gemini/antigravity/brain/b6b0e03c-9ba4-4dd6-bd17-587ecd33a337/.agent/workflows/design-feature.md)
*   **Goal**: Design a specific section/screen within an existing prototype.
*   **Steps**:
    1.  **Context Load**: Reads [vision.md](file:///Users/rooshi/Documents/programming/design/octolist-design/.claude/commands/design-os/product-vision.md) and `theme.dart` to stay on-brand.
    2.  **Shape Interview**: Asks "What screen/feature are we building?" (Requirements gathering).
    3.  **Data Modeling**: Generates JSON mock data (integrating with `MockDataService` pattern).
    4.  **Screen Design**: Implements the widget file (e.g., `home_page.dart`).
    5.  **Integration**: Wires the new screen into the `layout_shell.dart`.

## Verification Plan
1.  **Verify Rules**: Check `.agent/rules/flutter_design_rules.md`.
2.  **Verify Workflows**: Read through the markdown files to ensure the prompts are logical and the tool usage is correct.
3.  **Simulate**: I will assume the persona of a user and "mentally run" the workflow to check for dead ends.
