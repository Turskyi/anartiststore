# Implementation Plan - Local Favourites Feature

Implement a local favourites feature using `shared_preferences` for persistence, a repository pattern for data access, and `ProductsBloc` for state management.

## User Review Required

> [!IMPORTANT]
> - New dependency `shared_preferences` will be added to `pubspec.yaml`.
> - UI changes include adding a toggleable heart icon to all product cards.
> - The favorites list is stored locally and will be lost if the app's local storage is cleared.

## Proposed Changes

### [Dependencies]

#### [MODIFY] [pubspec.yaml](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/pubspec.yaml)
- Add `shared_preferences: ^2.5.2` to dependencies.

---

### [Data Layer]

#### [NEW] [favourites_repository.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/model/favourites_repository.dart)
- Define `FavouritesRepository` interface with `getFavouriteIds()`, `addFavourite(id)`, `removeFavourite(id)`, and `isFavourite(id)`.

#### [NEW] [shared_preferences_favourites_repository.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/data/repositories/shared_preferences_favourites_repository.dart)
- Implement `FavouritesRepository` using `shared_preferences`.
- Store IDs as a list of strings.

---

### [State Management]

#### [MODIFY] [products_event.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/bloc/products_event.dart)
- Add `ToggleFavouriteEvent(String productId)`.
- Add `LoadFavouritesEvent()`.

#### [MODIFY] [products_state.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/bloc/products_state.dart)
- Add `Set<String> favouriteIds` to `ProductsState`.
- Update all state subclasses to include `favouriteIds`.

#### [MODIFY] [products_bloc.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/bloc/products_bloc.dart)
- Update constructor to accept `FavouritesRepository`.
- Handle `LoadFavouritesEvent` to populate `favouriteIds`.
- Handle `ToggleFavouriteEvent` to update repository and state.
- Update `_showGroup` to filter products by `favouriteIds` when `Group.favourites` is selected.

---

### [UI Implementation]

#### [NEW] [favourite_button.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/ui/favourite_button.dart)
- Create a reusable `FavouriteButton` widget that handles the heart icon toggle and animation.
- Uses `Theme.of(context).colorScheme.primary` for the filled heart.

#### [MODIFY] [backdrop.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/backdrop/backdrop.dart)
- Add `FavouriteButton` to `_SearchProductCard`.
- Update `_buildGridCards` to handle the empty favorites state by showing `EmptyFavourites` widget.

#### [MODIFY] [mobile_product_card.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/supplemental/mobile_product_card.dart)
- Add `FavouriteButton` to the card layout.

#### [NEW] [empty_favourites.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/ui/empty_favourites.dart)
- Create a friendly empty state widget with "Go to Catalog" button as requested.

---

### [Application Setup]

#### [MODIFY] [an_artist_store_app.dart](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/lib/an_artist_store_app.dart)
- Initialize `SharedPreferencesFavouritesRepository`.
- Pass it to `ProductsBloc` constructor.
- Dispatch `LoadFavouritesEvent` on initialization.

---

### [Localization]

#### [MODIFY] [en.json](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/assets/i18n/en.json)
- Add strings: `favourites_empty_title`, `favourites_empty_message`, `go_to_catalog`.

#### [MODIFY] [uk.json](file:///Users/dmytro/development/multiplatform/Flutter/personal/production_projects/anartiststore/assets/i18n/uk.json)
- Add corresponding Ukrainian translations.

## Verification Plan

### Automated Tests
- N/A (Unit tests for Bloc could be added if infrastructure exists, but focus is on implementation).

### Manual Verification
- Open the app and navigate to the catalog.
- Tap the heart icon on a product; verify it fills with color and animates.
- Navigate to "Favourites" in the menu; verify the favorited product appears.
- Tap the heart icon again to remove it; verify it disappears from the Favourites list.
- Verify the empty state shows when no products are favorited.
- Verify the "Go to Catalog" button in the empty state navigates back to "All" products.
- Restart the app and verify favorites are persisted.
