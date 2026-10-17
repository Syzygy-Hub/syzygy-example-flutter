[![Flutter](https://img.shields.io/badge/Flutter-Dart-7F77DD?style=flat)](https://flutter.dev/) [![Dart](https://img.shields.io/badge/Dart-3.9-1D9E75?logo=dart&logoColor=white&style=flat)](https://dart.dev) [![CI](https://img.shields.io/github/actions/workflow/status/Syzygy-Hub/syzygy-example-flutter/ci.yml?label=ci&style=flat)](https://github.com/Syzygy-Hub/syzygy-example-flutter/actions/workflows/ci.yml) [![Version](https://img.shields.io/badge/version-3.0.0-D85A30?style=flat)](https://github.com/Syzygy-Hub/syzygy-example-flutter/releases) [![License](https://img.shields.io/badge/License-MIT-green?style=flat)](LICENSE)

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-dark-1200.png">
  <img src="https://raw.githubusercontent.com/Syzygy-Hub/.github/main/brand/assets/banners/syzygy-banner-light-1200.png" alt="Syzygy" width="600">
</picture>

# syzygy-example-flutter

A Flutter example app (Dart) that composes all five Syzygy layers and Base through one Core DI Container, with a demo login.

> This is an example application. It is **not published** to any package registry. Its only release artefact is a GitHub Release.

## Purpose

This example shows how to compose the Syzygy layers in a Flutter app: one DI container, one GoRouter configuration and a demo login that lets a reader reach every screen. It is a reference for wiring Foundation, Core, Services, AI and UI together on iOS and Android.

## Layers demonstrated

| Layer | Where it is shown | Status |
|---|---|---|
| Foundation | Features screen: `SyzygyID.generate<T>()` | Implemented |
| UI | Features screen: `PrimaryButton`, `CardView`, `ProgressBar`. Theme: `SyzygyThemeProvider` | Implemented |
| Core | Features screen: `ConfigRegistry.get(ConfigKey)`, `InMemoryFeatureFlagProvider.value(FeatureFlag)`. Container: `lib/di/app_module.dart` | Implemented |
| Services | Features screen: `StorageProvider.set` / `get` (`InMemoryStorageProvider`), `StateError`. Auth and storage registered in `lib/di/app_module.dart` | Implemented |
| AI | Features screen: `LLMProvider.complete`, `LLMRequest`, `LLMResponse`, `AIError`, with an offline provider in the app | Implemented |
| Base | Composition root in `lib/di/app_module.dart`, `initDI()` in `lib/main.dart`, and the auth redirect in `lib/navigation/app_router.dart` | Implemented |

## Example screens

Login, Home and Features are routes in one GoRouter configuration.

- **Login** signs in with the demo account (see Demo login). Wrong credentials show an error.
- **Home** shows the signed-in state, with **Open Features** and **Sign out**.
- **Features** (`/features`) demonstrates each layer with public APIs only and no API keys. The AI demo uses the offline provider at `lib/features/features/data/offline_llm_provider.dart`.
- **Sign out** clears the session and returns to Login. The router redirects any signed-out route to Login.

## Demo login

This example is not connected to a backend. The demo login ships in all build types, including release builds. It is not real authentication: it accepts one fixed account and keeps the session in memory only. It is the only working login path in this release.

| Field | Value |
|---|---|
| Email | `demo@syzygy.example` |
| Password | `demo-password` |

These are demo values only, not secrets. The flag is `useDemoLogin` in `lib/di/app_module.dart`, read from `--dart-define=SYZYGY_DEMO_LOGIN`. Its default is `true`, which selects the demo login.

## Not included

- A backend. The demo login is the only working login path in this release. Registration, token refresh and real API calls are not implemented.
- A production AI provider. The AI demo answers from the offline provider in the app.
- UI tests, instrumented tests and native smoke builds. They are not part of this release's CI runs.

## Requirements

- Flutter 3.35.0 or later
- Dart 3.9 or later
- iOS 15.0 or later, as set in `ios/Podfile`, and Xcode 16 or later
- Android: the minimum SDK from Flutter's default (`flutter.minSdkVersion`), and Android Studio

## How to run

1. Clone the repository:
   ```sh
   git clone https://github.com/Syzygy-Hub/syzygy-example-flutter.git
   cd syzygy-example-flutter
   ```
2. Fetch dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```
4. Run the checks:
   ```sh
   flutter analyze --fatal-warnings
   flutter test
   ```

## Library compatibility

This release is built against Syzygy 3.0.0. The five layers (`syzygy_foundation_flutter`, `syzygy_core_flutter`, `syzygy_services_flutter`, `syzygy_ai_flutter`, `syzygy_ui_flutter`) are pinned to exactly 3.0.0 in `pubspec.yaml`. The `depends_on` constraints in `syzygy.yml` are `>=3.0.0`. The compatibility table is in [example-apps-standard.md](https://github.com/Syzygy-Hub/.github/blob/main/engineering/standards/example-apps-standard.md#4-compatibility-table).

| Example release | Foundation | Core | Services | AI | UI | Status |
|---|---|---|---|---|---|---|
| 3.0.0 | 3.0.0 | 3.0.0 | 3.0.0 | 3.0.0 | 3.0.0 | Current |
| 1.0.0 | 3.0.0 | 3.0.0 | 3.0.0 | 3.0.0 | 3.0.0 | Previous release |

## Versioning and release

This example versions independently of the Syzygy libraries. Releases are tagged with bare strict semver, for example `3.0.0`, with no `v` prefix. The release workflow creates a GitHub Release from the matching CHANGELOG section. Nothing is published to a registry.

## Contributing

Follow the [Syzygy contribution guide](https://github.com/Syzygy-Hub/.github/blob/main/CONTRIBUTING.md). Open a pull request against `main`.

## Security

Report security issues through the [Syzygy security policy](https://github.com/Syzygy-Hub/.github/blob/main/SECURITY.md).

## License

MIT. Copyright (c) 2026 Ayush Kumar Sethi. See [LICENSE](LICENSE).
