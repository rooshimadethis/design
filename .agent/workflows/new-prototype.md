---
description: Create a new prototype with a unique design identity. Usage new-prototype
---

# New Prototype Workflow

This workflow guides the creation of a new, isolated prototype in `lib/prototypes/`. It enforces the "Design OS" philosophy: defining vision and aesthetics *before* implementation.

## Step 1: Vision Interview
Load the context and start a conversation to define the prototype.

1.  Read the Design Rules:
    `view_file .agent/rules/flutter_design_rules.md`
2.  Ask the user for the "Product Vision" (Goal, Vibe, Name).
    -   *Prompt*: "I'm ready to scaffold a new prototype. What are we building? What's the 'Vibe' (e.g., Cyberpunk, Minimal, Organic)? Do you have a name in mind?"
    -   *Action*: Discuss until you have a clear **Name** (snake_case, e.g., `retro_music_player`) and **Vibe Description**.

## Step 2: Scaffold
Create the basic structure.

1.  Create the directory: `lib/prototypes/<name>/`.
2.  Create `lib/prototypes/<name>/main.dart`:
    -   A simple `void main() => runApp(PrototypeApp());`
    -   `PrototypeApp` should be a `MaterialApp` with a placeholder home.

## Step 3: Concept Generation (The Playground)
Instead of guessing colors, create a tool for the user to choose.

1.  **Generate `design_playground.dart`**:
    -   Create a `StatefulWidget` named `DesignPlayground`.
    -   **Concept Data**: Define a `List<ThemeData>` with 3 contrasting concepts based on the "Vibe".
        -   *Example*: If "Retro", generate "Neon Synthwave", "Faded Polaroid", and "Arcade Bit".
        -   Each Theme must have distinct `ColorScheme` (primary/surface), `GoogleFonts` (headings/body), and `Shape` (rounded vs sharp).
    -   **UI**:
        -   A split screen or tab view.
        -   Top/Left: A "showcase" area displaying a Card, a Button, a Header, and some Body text using the *current* theme.
        -   Bottom/Right: Buttons to toggle between the 3 concepts.
    -   *Goal*: The user should run this, click the buttons, and see which vibe fits best.

2.  **Run the Playground**:
    -   Instruct the user: "I've created a Design Playground. Please run `lib/prototypes/<name>/main.dart` and tell me which Concept (1, 2, or 3) you prefer, or if we should mix them."

## Step 4: Finalize Foundation
Once the user selects a concept (or gives feedback):

1.  **Refine Vision**: Update the choice based on feedback.
2.  **Generate `theme.dart`**:
    -   Extract the winning `ThemeData` into a standalone file `lib/prototypes/<name>/theme.dart`.
    -   Make sure it exports a `ThemeData theme` variable.
3.  **Generate `layout_shell.dart`**:
    -   Create a `Scaffold` wrapper with a logical structure (AppBar, Drawer, BottomNav) fitting the vision.
    -   This will be the root widget identifying this prototype.

## Completion
Notify the user that the prototype is ready for Feature Design.
"Prototype `<name>` is initialized with the `<concept>` theme. You can now use the `/design-feature` workflow to build specific screens."
