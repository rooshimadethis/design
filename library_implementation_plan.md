# Implementation Plan - Library Page

The goal is to implement a full "Library" page for the user's anime collection, categorized by status (Watching, Planning, Completed, etc.).

## User Review Required

> [!IMPORTANT]
> **Data Consolidation**: I will update [MockDataService](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/services/mock_data_service.dart#19-141) to use [viewer_data.json](file:///Users/rooshi/Documents/programming/design/assets/anilist_data/viewer_data.json) for both User Profile and Library information, as it now contains consolidated data.

> [!NOTE]
> **Design Choice**: I am planning a **Dynamic Tabbed Interface**. Instead of hardcoding tabs, I will generate them dynamically from all lists found in [viewer_data.json](file:///Users/rooshi/Documents/programming/design/assets/anilist_data/viewer_data.json) (Watching, Planning, Completed, and any **Custom Lists** the user has created).

## Proposed Changes

### Logic & Data
#### [MODIFY] [mock_data_service.dart](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/services/mock_data_service.dart)
- Update [getUserProfile()](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/services/mock_data_service.dart#20-27) to read from [viewer_data.json](file:///Users/rooshi/Documents/programming/design/assets/anilist_data/viewer_data.json) under `data.Viewer`.
- Update [getWatchingList()](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/services/mock_data_service.dart#28-52) to read from [viewer_data.json](file:///Users/rooshi/Documents/programming/design/assets/anilist_data/viewer_data.json) under `data.MediaListCollection`.
- Add [getLibraryLists()](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/services/mock_data_service.dart#53-76) method to return all lists from [viewer_data.json](file:///Users/rooshi/Documents/programming/design/assets/anilist_data/viewer_data.json).

### UI Implementation
#### [NEW] [library_page.dart](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/screens/library_page.dart)
- **Scaffold**: Uses the app's white/black theme.
- **Header**: Big "LIBRARY" title with `GoogleFonts.teko`.
- **Tabs**: `TabBar` with custom `GoogleFonts.teko` styling.
- **Views**:
    - **Grid View**: For "Planning" and "Completed" (Cover + Title + Score).
    - **List View**: For "Watching" (reusing the detailed [WatchingCard](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/expressive_home.dart#588-603) or a variation).
    - **Empty State**: Custom "No Anime Found" widget with loose manga style.

#### [MODIFY] [expressive_home.dart](file:///Users/rooshi/Documents/programming/design/lib/prototypes/expressive_anime/expressive_home.dart)
- Update the `NavigationBar` "LIBRARY" destination to switch the `IndexedStack` to the new `LibraryPage` instead of the placeholder text.

## Verification Plan

### Automated Tests
- `flutter test` (if applicable, though UI is mostly visual).
- I will run `flutter analyze` to ensure no linting errors.

### Manual Verification
1.  **Navigation**: Tap "LIBRARY" in the bottom nav.
2.  **Tabs**: Swipe between "Watching", "Planning", etc.
3.  **Content**: Verify "Planning" shows the Akira card (from JSON). Verify "Watching" shows the current watching list.
4.  **Style**: Check if fonts and colors match the "Expressive" theme (Teko font, black/white high contrast).
