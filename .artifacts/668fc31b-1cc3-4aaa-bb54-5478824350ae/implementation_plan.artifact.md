# Unified Dashboard Implementation Plan

Refactor the app's secondary navigation by consolidating the "Info" screen content and new settings (Language, Currency, Theme, Favourites) into the Backdrop's back layer (the menu).

## User Review Required

> [!IMPORTANT]
> The "i" icon in the top-right corner will be removed. All its content (About, Legal, Support) will move to the menu accessible from the top-left icon.

## Proposed Changes

### [Backdrop]

#### [MODIFY] [backdrop.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/backdrop/backdrop.dart)
- Remove the `info_outline` IconButton from the `AppBar` actions.

### [Menu & Navigation]

#### [MODIFY] [group_menu_page.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/group/group_menu_page.dart)
- Rename the class to `MenuPage` (and keep the filename for now or rename if preferred, but I'll stick to updating the class content).
- Structure the menu into sections:
    - **Catalog**: Categories (Art) + Favourites placeholder.
    - **Preferences**: Language, Currency, Theme placeholders.
    - **Support**: Links from `InfoPage`.
    - **Legal**: Links from `InfoPage`.
- Use a `ListView` with `ListTile`s and custom widgets for a cleaner look.

#### [MODIFY] [an_artist_store_app.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/an_artist_store_app.dart)
- Update the `Backdrop` instantiation to use the new `MenuPage` logic (if class name changed).

### [Resources]

#### [MODIFY] [en.json](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/assets/i18n/en.json)
- Add new keys for the menu sections: `preferences`, `favourites`, `language`, `currency`, `theme`, `catalog`.

#### [MODIFY] [uk.json](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/assets/i18n/uk.json)
- Add new keys for the menu sections: `preferences`, `favourites`, `language`, `currency`, `theme`, `catalog`.

## Verification Plan

### Manual Verification
1.  Open the app and verify the "i" icon is gone from the top-right.
2.  Tap the top-left menu icon to reveal the backdrop.
3.  Verify the new sections:
    - Catalog (Art, Favourites)
    - Preferences (Language, Currency, Theme)
    - Support (About, Press Kit, Contact, Report Problem)
    - Legal (Terms, Privacy)
4.  Verify that tapping the links in the menu works as expected (launches URLs or feedback).
5.  Verify the "Art" category still filters products correctly.
