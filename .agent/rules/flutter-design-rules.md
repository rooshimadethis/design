---
trigger: always_on
description: Create distinctive, production-grade Flutter interfaces with high design quality. Use this when the user asks to build UI, widgets, or prototypes.
---

This rule guides the creation of distinctive, production-grade Flutter interfaces that avoid generic "Material Default" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

## Design Thinking in Flutter

Before coding `Widgets`, commit to a BOLD aesthetic direction:

*   **Purpose**: What is this screen for? Who is it for?
*   **Tone**: Pick an extreme. Brutalist? Soft/Organic? Cyberpunk? Glassmorphic?
*   **Differentiation**: What makes this UNFORGETTABLE?

**CRITICAL**: Avoid `Material 2` defaults (standard `AppBar`, `Card`, `FloatingActionButton` with default elevations). Instead, compose custom layouts using `AnimatedContainer`, `CustomPaint`, `BackdropFilter`, and explicit `BoxDecoration`.

## Flutter Aesthetics Guidelines

### 1. Typography
*   **Don't use default fonts.** Use `GoogleFonts` (package: `google_fonts`).
*   **Pairing**: Pair a distinctive display font (headings) with a clean, readable body font.
*   **Type Scale**: Use exaggerated scale. Huge headers (96px+) or varying weights (Extralight vs Black) create drama.
*   **TextTheme**: Always define a custom `TextTheme` in your `ThemeData`.

### 2. Color & Theme
*   **ThemeData**: Define a coherent `ColorScheme`.
    *   `primary`: The brand voice.
    *   `surface` & `background`: Don't just use white/black. Use slight tints (e.g., `Color(0xFF0F1215)` for dark mode).
*   **Gradients > Solids**: Use `LinearGradient` or `RadialGradient` in `BoxDecoration` to add depth.
*   **Elevation**: Avoid standard shadow arrays. Use colored shadows (`BoxShadow(color: primary.withOpacity(0.3), blurRadius: 20)`) for a glow effect.

### 3. Motion & Interaction
*   **Flutter Animate**: Use `flutter_animate` for declarative, chained animations.
*   **Implicit Animations**: Use `AnimatedContainer`, `AnimatedOpacity`, `AnimatedPositioned` for state changes.
*   **Feedback**: Every tap should have a reaction. Use `InkWell` (with custom splashes) or `GestureDetector` with scale animations.
*   **Transitions**: Use `Hero` widgets even for subtle connections between elements.

### 4. Spatial Composition
*   **Slivers**: Use `CustomScrollView` + `SliverAppBar` + `SliverList` for sophisticated scrolling behaviors.
*   **Stacking**: Use `Stack` + `Positioned` to break the grid. Let elements overlap.
*   **SafeArea**: Be intentional about where you disregard `SafeArea` (e.g., background images extending to edge) vs where you respect it.

### 5. Visual Details
*   **Glassmorphism**: `BackdropFilter(filter: ImageFilter.blur(...))` with semi-transparent white/black overlays.
*   **Borders**: Use `BorderSide` details—maybe just a top border, or a gradient border.
*   **Noise/Texture**: Consider using an `IgnorePointer` with a noise image asset overlaid on the background for texture.

## Anti-Patterns (What to Avoid)
*   Standard `AppBar` with a solid color and simple text title.
*   Default `Card` widget with default elevation.
*   Standard `ListTile` without customization.
*   "Blue" as the default primary color.
*   Loading states that are just a `CircularProgressIndicator` in the center. (Use Skeleton loaders or Shimmer).

## Implementation Strategy
1.  **Define Theme**: Start by creating a `ThemeData` variable that captures the vibe.
2.  **Build Atoms**: Create small, reusable styling widgets (e.g., `GlassCard`, `NeonButton`).
3.  **Compose**: specialized layouts using `Row`/`Column` aren't enough—use `Stack` and `CustomMultiChildLayout` for unique positioning.