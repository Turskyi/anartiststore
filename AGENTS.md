# AI Agent Guidelines

This document provides specific instructions and preferences for AI agents
working on this project.

## Coding Standards

### File Structure

- **One class per file**: Generally prefer creating one class per file to keep
  the codebase modular and easy to navigate.
- **Exceptions**:
    - **Stateful Widgets**: The `StatefulWidget` class and its associated
      `State` class should always be kept together in the same file.
    - **Enum-like classes**: Related classes that function together as a single
      unit, such as BLoC `Events` and `States`, or small sealed class
      hierarchies, should be grouped in one file.

### Widget Construction

- **Prefer Classes over Functions**: Avoid using helper methods that return a
  `Widget` (e.g., `Widget _buildHeader()`). Instead, create dedicated
  `StatelessWidget` or `StatefulWidget` classes. This improves performance
  (via `const` constructors), ensures proper lifecycle management, and makes
  the widget tree easier to debug in the Flutter Inspector.

### Theming

- **Avoid Constant Colors**: Do not hardcode specific colors using constants
  (e.g., `kAnArtistStoreTeal`) directly in widgets. Instead, use semantic
  colors from the application's theme (e.g.,
  `Theme.of(context).colorScheme.primary`). This ensures the UI automatically
  adapts to different themes, such as Dark Mode.

### Null Safety

- **Avoid the `!` operator**: Do not use the non-null assertion operator (`!`).
  Instead, use the `?` operator or create a local variable with an `if`
  condition to check for null before usage.

### Type Safety

- **Prefer `Object?` over `dynamic`**: Avoid using `dynamic` where possible.
  Use `Object?` for values of unknown types to ensure type safety through
  explicit type checks and promotion.
- **Safe Type Casting**: Avoid using the `as` operator. Use
  `if (something is Something)` or null checks to verify types; Dart will
  automatically promote the variable to the correct type, making the `as` cast
  unnecessary and redundant.

### Localization

- **No Hardcoded Strings**: Do not hardcode user-facing text directly in `Text`
  widgets or other UI components. Always use the application's localization
  mechanism (e.g., `translate('key')`) and add corresponding entries to the
  translation files.

## Document Maintenance

- **File Length**: This `AGENTS.md` file must not exceed 200 lines. The line
  where this rule is written should not be on line 201 or beyond. If adding a
  new rule would exceed this limit, identify and remove a less important rule
  to make space.
