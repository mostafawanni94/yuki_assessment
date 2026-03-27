# SWAPI Planets — Yuki Flutter Assessment

Star Wars planets explorer built with Flutter, consuming [swapi.dev](https://swapi.dev).

---

## Run

```bash
git clone https://github.com/mostafawanni94/yuki_assessment.git
cd yuki_assessment
git checkout feat/clean-architecture   # latest

flutter pub get
flutter run
```

No API keys, no `.env` files, no build steps. `flutter pub get && flutter run`.

---

## Tests

```bash
flutter test
```

| File | Tests | Fakes |
|---|---|---|
| `datasource_test` | 8 | `_FakeApiClient` |
| `repository_test` | 9 | `_FakeDatasource` |
| `planets_bloc_test` | 5 | `_FakeGetPlanetsUseCase` |
| `planet_detail_bloc_test` | 4 | `_FakeGetDetailUseCase` |

Each test layer fakes only the **layer directly below** — mirrors the production dependency graph.

---

## Architecture

```
lib/
├── core/
│   ├── base_bloc/         # BaseBloc<T> + sealed BaseState<T>
│   ├── di/                # InjectionContainer (root DI)
│   ├── errors/            # 12 typed exceptions (const, immutable)
│   ├── l10n/              # AppStrings — all UI strings (i18n-ready)
│   ├── navigation/        # GoRouter
│   ├── net/               # Dio, ApiClient, interceptors
│   ├── result/            # MyResult<T> sealed (IsSuccess / IsError)
│   ├── theme/             # AppColorScheme, ThemeCubit, 3 themes
│   ├── ui/                # ErrorStateWidget, GlowingPlanetOrb, StarField
│   └── usecase/           # UseCase<O,I> + UseCaseParams base
│
└── feature/planets/
    ├── data/
    │   ├── datasource/    # IPlanetsDatasource + PlanetsDatasource
    │   ├── mapper/        # PlanetMapper (DTO → Entity)
    │   ├── model/         # PlanetDto, PlanetsPageDto (JSON only)
    │   └── repository/    # PlanetsRepository (impl, uses mapper)
    │
    ├── di/
    │   └── planets_injection.dart   # Feature DI module
    │
    ├── domain/
    │   ├── entity/        # Planet (pure Dart, no JSON/Flutter)
    │   ├── repository/    # IPlanetsRepository (interface only)
    │   └── usecase/       # GetPlanetsUseCase, GetPlanetDetailUseCase
    │
    └── presentation/
        ├── bloc/          # PlanetsBloc, PlanetDetailBloc
        ├── screen/        # PlanetsListScreen, PlanetDetailScreen
        └── widgets/       # PlanetListItem, PlanetsLoadingShimmer
```

### Data flow

```
UI → BLoC → UseCase → IRepository → Repository → Datasource → API
                                       ↓
                                  PlanetMapper
                                       ↓
                              Planet (entity) ← returned up the chain
```

---

## Key Decisions

| Decision | Reason |
|---|---|
| `UseCase<O,I>` layer | BLoC never imports repository — enforces 4-layer boundary |
| `Planet` entity vs `PlanetDto` | DTO = JSON shape; Entity = business object. Mapper converts between layers |
| Repository impl in `data/` | Domain layer stays pure (no implementation details) |
| `PlanetsInjection` module | Each feature owns its own registrations — root DI just calls `register(sl)` |
| `sealed BaseState<T>` | Compiler-enforced exhaustive `when()` — impossible to miss loading/error |
| `MyResult<T>` (IsSuccess/IsError) | No exceptions crossing layer boundaries |
| Film deduplication in repository | One HTTP call per unique film URL across all planets on the page |
| 404 on last page = end of list | SWAPI has 60 planets (6 pages); page 7 is 404, not an error |
| No code generation | Zero `build_runner` — `flutter pub get && flutter run` is all you need |
| `AppColorScheme` + `ThemeCubit` | Adding a theme = 1 constant in `app_colors.dart`, zero widget changes |
| `AppStrings` for all UI text | i18n phase 2 = replace `AppStrings.xxx` → `context.l10n.xxx`, no widget changes |

---

## Themes

Toggle via moon / sun / flame icon in the AppBar:

| | Theme | Palette |
|---|---|---|
| 🌑 | Space | Dark bg, gold accent |
| ☀️ | Light | White bg, blue accent |
| 🔥 | Sith | Dark red bg, crimson accent |

Adding a new theme: add one `AppColorScheme` constant to `app_colors.dart` + append to `availableThemes[]`.
