# SWAPI Planets — Yuki Flutter Assessment

A Flutter app exploring Star Wars planets via [swapi.dev](https://swapi.dev).

## Architecture

```
lib/
├── core/
│   ├── base_bloc/        # BaseBloc<T> + sealed BaseState<T>
│   ├── di/               # GetIt service locator
│   ├── errors/           # Typed exception hierarchy
│   ├── navigation/       # GoRouter config
│   ├── net/              # Dio client, interceptors, ApiClient, URLs
│   ├── params/           # Request parameter base classes
│   ├── result/           # MyResult<T> sealed type
│   ├── theme/            # AppTheme (light + dark)
│   └── ui/
│       └── error_handling/   # ErrorStateWidget + SnackBarHelper
├── feature/
│   ├── planets/          # → added in feature branch
│   └── planet_detail/    # → added in feature branch
├── app.dart
└── main.dart
```

**State management:** BLoC / Cubit  
**DI:** GetIt  
**HTTP:** Dio  
**Navigation:** GoRouter  
**Code gen:** Freezed + json_serializable

## Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Tests

```bash
flutter test
```

## Key decisions

| Decision | Reason |
|---|---|
| `sealed BaseState<T>` | Exhaustive pattern matching — compiler catches missing cases |
| `MyResult<T>` | No exceptions crossing layer boundaries |
| `BaseBloc.performAction` | Retry wiring + cancellation handled once |
| `ApiClient._handleDioError` | All HTTP error mapping in one switch |
| `abstract final class` for URL/Config | Prevents instantiation of utility classes |
| GoRouter | Declarative, testable, deep-link ready |
