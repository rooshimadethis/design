# Implementation Plan - Flutter Design Playground

## Goal
Create a Flutter application that serves as a flexible container for rapid UI prototyping and design iterations. The structure must allow for:
1.  **Isolation**: Each design concept (e.g., "Cyberpunk Anime App") should be self-contained in its own directory.
2.  **Zero-Friction Iteration**: During active development of a specific design, the app should boot directly into that screen, bypassing the main list.
3.  **Exportability**: Code for a design can be copied to another project with minimal dependency entanglement.
4.  **Mobile-First, Adaptable**: Priority is mobile-optimized designs that gracefully handle larger screens (Desktop/Web).

## Architecture

### Why this approach?
We are building a **Monolithic Sandbox**.
*   **Pros**: Shared dependencies (only install `flutter_animate` once), instant context switching, single `build` process.
*   **Cons**: Potential for "spaghetti" if we accidentally import code from Project A into Project B.
*   **Mitigation**: We will be disciplined. Each folder in `prototypes/` should act like a mini-app.

### Directory Structure
```
lib/
  main.dart         // Application Entry. Change `home` here to "focus" a project.
  common/           // Shared utilities
    breakpoints.dart // Standardized breakpoints (Mobile/Tablet/Desktop)
    responsive.dart  // Helper widget for platform-specific layouts
  prototypes/       // Where the magic happens
    anime_cyberpunk/
      ...
```

### The "Harness" (`main.dart`)
- **Default State**: A `ListView` of available prototypes.
- **Dev Mode**: We will have a clearly marked variable `Widget? activePrototype = CyberpunkMain();`. If set, the app boots straight there.
    - *Solves Hot Reload/Restart friction*: You stay exactly where you are.

### Responsive Strategy
We will use a **Mobile-First Approach**:
- **Baseline**: Design for 375x812 (Standard Mobile).
- **Graceful Scaling**: Use `Center` and `ConstrainedBox` (e.g., max-width: 600) to ensure the mobile layout stays readable on Desktop.
- **Adaptive Layers**: Only add "Desktop-only" components (sidebars, multi-column layouts) as an optional second step.
- **Testing**: Primary testing on Simulator/Emulator; Secondary on Web/Desktop to ensure it looks "okay" there too.

### Design Module: Anime Cyberpunk
- **Theme**: High contrast, neon colors (Pink/Cyan/Green) on dark background. Glitch effects, angular borders.
- **Widgets**:
  - `CyberCard`: Custom container with cut corners.
  - `NeonText`: Text with glow shadows.
  - `HackerScaffold`: Background with grid lines or digital rain effect (simplified).

## Steps
1.  **Scaffold**: Run `flutter create .` (since we are in the `design` dir, or creating a subfolder).
2.  **Setup Harness**: Create `main.dart` with the "Direct Boot" toggle logic.
3.  **Implement Request**: Create `prototypes/anime_cyberpunk` and start building the requested UI.

## Export & Handoff Strategy
To ensure smooth integration by other agents:
1.  **Self-Contained Modules**: The folder `lib/prototypes/anime_cyberpunk` will be physically copy-pasteable. It will *not* import from `../ecommerce_minimal`.
2.  **The `DESIGN.md`**: Each prototype folder will contain a markdown file documenting:
    *   **Target Platform**: Mobile-First, Web-First, or Desktop.
    *   **Tokens**: Color palette (Hex codes), Typography (Font families, weights).
    *   **Components**: Usage guide for custom widgets (e.g., `CyberButton(required: "label")`).
    *   **Dependencies**: A list of packages used (e.g., `google_fonts`, `flutter_animate`).
    *   **Assets**: We will store images in a self-contained `assets/` folder *inside* the prototype if possible, or clearly document global asset needs.

## Verification
- Verify that setting the "Active Prototype" variable bypasses the menu.
- Verify "Cyberpunk" look and feel.
