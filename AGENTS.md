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
    - **Private Helpers**: Small private classes or widgets (`_MyPrivateHelper`)
      that are only relevant to the main class in the file may be kept there to
      avoid unnecessary file fragmentation.

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
