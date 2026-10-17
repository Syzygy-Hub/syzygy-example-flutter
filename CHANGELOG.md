# Changelog

All notable changes to `syzygy-example-flutter` are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-10-18

### Added
- Release workflow `.github/workflows/release.yml` from the Hub's app release template. It fires on strict bare-semver tags and calls `app-release.yml@main`.
- Library compatibility table in the README.
- The demo login is documented as shipping in all build types, including release builds.

### Changed
- CI caller aligned with the Hub's Flutter app CI template. Flutter 3.35.0 is pinned in CI. Build smoke jobs are off. Triggers are push-only with tags excluded.
- README analyze command matches what CI runs: `flutter analyze --fatal-warnings`.
- README rewritten to the v3.0.0 facts. The one-time rename steps are removed.
- `version` 3.0.0+1 in `pubspec.yaml`.

## [1.0.0] - 2026-10-16

### Added
- Home screen showing the signed-in state, with buttons to open Features and to sign out
- Features screen (`/features`) demonstrating each layer with public APIs and no keys: Foundation (`SyzygyID`), Core (`ConfigRegistry`, `FeatureFlag`), Services (`StorageProvider`), AI (`LLMProvider` with an offline provider written in the app) and UI (`PrimaryButton`, `CardView`, `ProgressBar`)
- Offline `LLMProvider` implementation in the app (`OfflineLLMProvider`)

### Changed
- Syzygy packages pinned to exactly 3.0.0 in `pubspec.yaml` (Foundation, Core, Services, AI, UI)
- App renamed from SyzygyBase to Syzygy Example (package `syzygy_example`, application ID `com.syzygyhub.example`)

