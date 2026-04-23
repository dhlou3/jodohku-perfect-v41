---
description: Build and Deploy the Jodohku Flutter App
---

Follow these steps to generate a production-ready build of Jodohku.

1. **Clean Workspace**
// turbo
```powershell
flutter clean
```

2. **Retrieve Dependencies**
// turbo
```powershell
flutter pub get
```

3. **Verify Branding**
Check `lib/main.dart` and `pubspec.yaml` to ensure the name is `jodohku_malaysia`.

4. **Build Android APK**
// turbo
```powershell
flutter build apk --release --split-per-abi
```

5. **Deploy Firebase Rules**
// turbo
```powershell
firebase deploy --only firestore:rules,storage
```

6. **Verify Build**
The output will be located in `build/app/outputs/flutter-apk/`. Use the `app-release.apk` for testing on physical devices.
