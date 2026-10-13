# Stockroom

Offline inventory and sales management for small retailers (Android, Flutter).
One business, one device, one local database — no account, no network needed.
See `AGENTS.md` for the full product contract and `docs/decisions/` for
build decisions.

## Quick start

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Verify

```sh
dart format lib test
flutter analyze
flutter test
flutter build apk --debug    # integration check incl. native plugins
flutter build apk --release  # release check before publishing
```

## Manual release pass

Follow `docs/release-checklist.md` on a physical Android device in
airplane mode before any release.
