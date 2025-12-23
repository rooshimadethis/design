---
description: Design and build a specific screen or feature for an existing prototype. Usage /design-feature
---

# Design Feature Workflow

This workflow guides the design and implementation of a single feature (e.g., "Settings Page", "Profile Header") within an existing prototype. It assumes the prototype foundation (Theme/Shell) is already set.

## Step 1: Context Load
Before asking questions, understand the current state.

1.  **Identify Prototype**: Ask the user which prototype to work on (if not obvious from current file).
2.  **Read Context**:
    -   `view_file .agent/rules/flutter_design_rules.md` (Design Principles)
    -   `view_file lib/prototypes/<name>/theme.dart` (Visual Language)
    -   `view_file lib/prototypes/<name>/models/` (Existing Data)

## Step 2: Shape Interview
Define *what* to build.

1.  **Ask**: "What feature or screen are we designing today? What data does it need?"
2.  **Refine**:
    -   *Input*: "I want a profile page."
    -   *Agent*: "Got it. Should it be a modal or a full screen? Does it need edit capabilities or just view? What specific stats should we show?"

## Step 3: Data Modeling
If the feature needs new data, model it first.

1.  **Check Models**: Does `UserProfile` or `Settings` model exist?
2.  **Generate Mocks**:
    -   If needed, extend `MockDataService` or create a local mock list.
    -   *Example*: `final List<Achievement> mockAchievements = [...]`
    -   **Constraint**: Keep data logic simple. This is a prototype. Hardcoded lists are fine.

## Step 4: Screen Design
Implement the UI.

1.  **Create File**: `lib/prototypes/<name>/screens/<feature_name>.dart`.
2.  **Implement**:
    -   Use `Scaffold` (or `Sliver` setup if inside a shell).
    -   **Apply Theme**: strictly use fields from `theme.dart` (e.g., `Theme.of(context).textTheme.displayLarge`).
    -   **Apply Rules**: Use `AnimatedContainer`, glassmorphism, or custom layouts as per strict design rules.
    -   **NO GENERIC WIDGETS**: Avoid `ListTile` default styling. Build custom rows.

## Step 5: Integration
Connect it to the app.

1.  **Update Shell**: Add a navigation entry in `layout_shell.dart` or a button in `home.dart` to open this new screen.
2.  **Verify**: Ask the user to run the app and navigate to the new feature.

## Completion
"Feature `<name>` is implemented. Review the design and let me know if we need to iterate on the aesthetics or interaction."