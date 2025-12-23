# Flutter Design Playground

## Project Overview
A monolithic sandbox environment designed for rapid Flutter UI prototyping and design iterations. The project emphasizes isolation of design concepts while maintaining a shared "harness" for easy development and zero-friction iteration.

**Repository**: [github.com/rooshimadethis/flutter-design-tool](https://github.com/rooshimadethis/flutter-design-tool)

## Tech Stack
- **Framework**: Flutter (Dart)
- **Styling/Fonts**: `google_fonts`, `phosphor_flutter`
- **Animations**: `flutter_animate`
- **State Management**: Vanilla Flutter (StatefulWidget/ValueNotifier) or specific to individual prototypes.

## Architecture & Conventions

### Directory Structure
- `lib/main.dart`: The entry point and "Harness". Configures the active prototype or shows the main menu.
- `lib/prototypes/`: **Main Workspace**. Each design concept lives in its own isolated subdirectory (e.g., `lib/prototypes/expressive_anime/`).
    - **Isolation Rule**: Prototypes should act like mini-apps and minimize dependencies on other prototypes.
- `lib/common/`: Shared utilities (breakpoints, responsive helpers).

### Development Patterns
- **Direct Boot**: To focus on a specific design, set the `activePrototype` static variable in `lib/main.dart`. This bypasses the menu and boots directly into your widget, enabling "Zero-Friction Iteration".
- **Mobile-First**: Designs should primarily target mobile form factors but handle larger screens gracefully (e.g., via `Center` + `ConstrainedBox`).

## Important Commands
- **Run App**: `flutter run`
- **Analyze Code**: `flutter analyze`
- **Run Tests**: `flutter test`
