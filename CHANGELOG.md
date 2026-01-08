# Changelog

All notable changes to this project (from the Godot 4.5 fork onwards) will be documented in this file.

## [v1.0-godot4] - 2026-01-08

### Added
- **Draggable Edit Window**: The "Edit Room" dialog can now be dragged by its background.
- **Minimum Window Size**: Enforced a minimum size of 900px for the edit dialog to prevent layout issues.
- **Godot 4.x Support**: Full port of the codebase to Godot 4.x API.

### Changed
- **Z-Order Handling**: Converted `FormSceneData` from `Popup` to `Control` to ensure it always renders on top of the editor grid.
- **API Updates**:
    - Replaced `File` with `FileAccess`.
    - Replaced `Directory` with `DirAccess`.
    - Replaced `Tween` nodes with `create_tween()`.
- **Project Configuration**: Updated `project.godot` to version 5.

### Fixed
- **Crash on Color Selection**: Added null checks to prevent crashes when loading legacy save data with mismatched colors.
- **Parse Errors**: Fixed `get_global_mouse_position()` usage on non-Control nodes.
- **Icon Visibility**: Refactored `room_panel.tscn` so icons are visible in Godot 4.

### Credits
- Original Plugin by **Danny Garay**.
- Godot 4 Port by **KirNova**.
