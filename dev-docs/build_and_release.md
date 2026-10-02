# Build & Release Configuration

This document outlines how the FP Mandate multiplatform builds are configured, how executables are named, and how the CI/CD pipeline operates.
> **Note:** These pages are specifically for **Developer Documentations**.


## Executable Names

Across all platforms, the application is configured to output an executable named **`FP Mandate`**. This ensures consistency for end-users, installers, and shortcuts.

### Configuration Locations
If you ever need to change the application executable name or display name in the future, you must update the following native configuration files:

- **Windows:** 
  - `windows/CMakeLists.txt` (`set(BINARY_NAME "FP Mandate")`)
  - `windows/runner/Runner.rc` (`ProductName` and `FileDescription` set to `"FP Mandate"`)
  - `windows_installer.iss` (Build output paths and shortcuts look for `FP Mandate.exe`)
- **macOS:** 
  - `macos/Runner.xcodeproj/project.pbxproj` (Target and scheme configurations)
  - `macos/Runner/Configs/AppInfo.xcconfig` (Sets `PRODUCT_NAME = FP Mandate` for the user-facing `.app` name)
- **Linux:** 
  - `linux/CMakeLists.txt` (`set(BINARY_NAME "FP Mandate")`)
  - `linux/runner/my_application.cc` (Window and header bar titles)

## GitHub Actions CI/CD Pipeline

The project uses GitHub Actions (`.github/workflows/multiplatform_release.yml`) to automatically compile and release the application for all platforms.

### Triggers
- **`dev` branch:** Automatically generates a prerelease draft on push. Intended for internal testing by the QA and development teams.
- **`release` branch:** Automatically creates a public, production-ready release on the public distribution repository (`ankittripathi4494/FP Mandate-releases`).
- **Manual Trigger:** Can be manually executed via the GitHub Actions `workflow_dispatch` UI.

### Workflows by Platform

1. **Windows Installer (`.exe`)**
   - Built on `windows-latest` GitHub-hosted runners.
   - Compiles an `x64` executable.
   - Uses **Inno Setup** (`iscc`) with `windows_installer.iss` to package the compiled executable into a seamless installer (`FP Mandate-Setup-vX.Y.Z.exe`).

2. **macOS Application (`.dmg`)**
   - Built on a self-hosted macOS ARM64 runner.
   - Compiles the `.app` bundle.
   - Packages it into a drag-and-drop DMG image using `create-dmg` (`FP Mandate-vX.Y.Z-macos.dmg`). 

3. **Android Application (`.apk`)**
   - Built on a self-hosted macOS runner.
   - Generates an obfuscated FAT APK (supporting both ARM and ARM64).
   - Generates and uploads debug symbols.

4. **iOS Application (`.ipa`)**
   - Built on a self-hosted macOS runner.
   - Compiles without signing (`--no-codesign`) and bundles into a standard payload (`FP Mandate-vX.Y.Z-ios.ipa`).

### Versioning
The pipeline extracts the version directly from `pubspec.yaml` using a shell script. If the tag (e.g. `v1.0.3` or `dev-v1.0.3`) already exists on GitHub, the pipeline skips building to prevent redundant artifact generation. To trigger a new build, always bump the `version` inside `pubspec.yaml` before pushing.

