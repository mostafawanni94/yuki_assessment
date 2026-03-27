# SWAPI Planets — Yuki Flutter Assessment

A Star Wars planets explorer built with Flutter, consuming [swapi.dev](https://swapi.dev).

---

## Screens

| Screen | Features |
|---|---|
| **Planets List** | Paginated planet list (10/page), planet name, film titles resolved from URLs, shimmer loading, pull-to-refresh, scroll-to-load-more, error + retry |
| **Planet Detail** | All SWAPI planet fields, film titles, resident names resolved concurrently, Hero animation from list orb |

---

## Run

```bash
# 1. Clone
git clone https://github.com/mostafawanni94/yuki_assessment.git
cd yuki_assessment
git checkout feat/ui-polish   # latest branch

# 2. Install
flutter pub get

# 3. Run
flutter run
```

> No `.env` files, API keys, or build steps required. `flutter pub get && flutter run` is all you need.

---

## Tests

```bash
flutter test
```

22 unit tests across 4 files:

| File | Tests | Covers |
|---|---|---|
| `datasource_test` | 8 | URL stripping, HTTP method, error passthrough |
| `repository_test` | 9 | Film deduplication, graceful degradation, concurrent resolution |
| `planets_bloc_test` | 7 | Pagination, reset, failure+retry wiring |
| `planet_detail_bloc_test` | 4 | Load, error, resolved data, retry callback |

All tests use hand-written `Fake` implementations — no `build_runner` or Mockito code generation needed.

---

## Architecture

```
lib/
├── core/
│   ├── base_bloc/        # BaseBloc<T> + sealed BaseState<T> (init/loading/success/failure)
│   ├── di/               # GetIt service locator
│   ├── errors/           # 12 typed exceptions (const, immutable)
│   ├── l10n/             # AppStrings — all UI strings centralised (i18n-ready)
│   ├── navigation/       # GoRouter
│   ├── net/              # Dio + ApiClient + error mapping
│   ├── result/           # MyResult<T> sealed type (IsSuccess / IsError)
│   ├── theme/            # AppColorScheme + ThemeCubit + 3 themes
│   └── ui/               # Shared widgets + ErrorStateWidget
├── feature/
│   ├── planets/
│   │   ├── data/datasource/    # IPlanetsDatasource + PlanetsDatasource
│   │   ├── domain/model/       # PlanetModel + PlanetsPageModel
│   │   ├── domain/repository/  # IPlanetsRepository + PlanetsRepository
│   │   └── presentation/       # PlanetsBloc + PlanetsListScreen + widgets
│   └── planet_detail/
│       └── presentation/       # PlanetDetailBloc + PlanetDetailScreen
├── app.dart
└── main.dart
```

**Layers:** Datasource → Repository → BLoC → UI. Each layer depends only on the abstraction below it (interfaces), never on concrete implementations.

---

## Key Decisions

| Decision | Reason |
|---|---|
| `sealed BaseState<T>` | Compiler-enforced exhaustive `when()` — impossible to forget loading or error cases |
| `MyResult<T>` (IsSuccess/IsError) | No exceptions crossing layer boundaries — all errors are typed values |
| `BaseBloc.performAction` | Retry wiring + cancellation handled once for all BLoCs |
| Film/resident URL resolution | Concurrent `Future.wait` per planet — graceful fallback on individual failures |
| `PlanetsBloc` extends Cubit directly | Pagination accumulates pages — `BaseBloc` replaces state per action |
| `AppColorScheme` + `ThemeCubit` | Adding a new theme = one constant, zero widget changes |
| No code generation | Zero `build_runner` dependency — `flutter pub get && flutter run` works immediately |
| `AppStrings` for all UI text | Phase 2 i18n = replace `AppStrings.xxx` with `context.l10n.xxx` — no widget changes |
| 404 on last page = end of list | SWAPI has exactly 60 planets (6 pages) — page 7 returns 404 which is not an error |

---

## Themes

Three built-in themes, toggled via the moon/sun/flame icon in the AppBar:

| Theme | Description |
|---|---|
| 🌑 Space | Deep space dark, gold accent (default) |
| ☀️ Light | Clean white, blue accent |
| 🔥 Sith | Dark red, crimson accent |

Adding a new theme = add one `AppColorScheme` constant to `app_colors.dart` and append it to `availableThemes`. Zero other changes.
