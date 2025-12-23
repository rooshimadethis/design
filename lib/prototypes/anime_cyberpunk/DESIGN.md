# Anime Tracker: Project "Neon Soul"

> **Target Platform**: Mobile-First (Base: iPhone 14 / Pixel 7)

## 🎨 Visual Identity
A futuristic, "Hacker/Cyberpunk" aesthetic. High contrast, data-dense, neon accents.

### Color Tokens
| Token | Hex | Usage |
| :--- | :--- | :--- |
| `bg_dark` | `#050510` | Main background (void black) |
| `card_bg` | `#0f0f1f` | Surface/Containers |
| `neon_pink` | `#ff00bf` | Primary Actions / Attention |
| `neon_cyan` | `#00ffff` | Secondary / Info |
| `neon_green` | `#00ff41` | Success / Online Status |
| `matrix_dim` | `#003b00` | Subtle background grids |

### Typography
*   **Font**: `JetBrains Mono` or `Share Tech Mono` (via Google Fonts) for headers/data.
*   **Font**: `Inter` or `Roboto` for long form body text (readability).

## 🧩 Components
*   **`CyberCard`**: Container with cut 45-degree corners and a thin border.
*   **`GlitchText`**: Text that occasionally "shifts" pixels (using `flutter_animate`).
*   **`HoloButton`**: Outlined button with inner glow.

## 📦 Dependencies
*   `google_fonts`
*   `flutter_animate`
*   `phosphor_flutter` (Icons)

## 🚀 Feature Roadmap

### Priority 1: Media Discovery & Search (Core)
- **Advanced Search**: Genre, tags, year, season, format, status filters.
- **Trending & Popular**: Seasonal trends and all-time popular media.
- **Details Page**: Descriptions, countdowns, relations, studios, recommendations, and reviews.

### Priority 2: User List Management (Tracking)
- **Personal List Sync**: View Current, Planning, Completed, etc.
- **Progress Updates**: Episode increments, status changes, and scoring.

### Priority 3: Global Discovery (Future)
- **Global Activity Feed**: Community-wide watching updates.
