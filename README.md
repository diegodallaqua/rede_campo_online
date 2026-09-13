# Rede Campo Online

🌐 **English** | [Português](README.pt-BR.md)

Official repository of the **Rede Campo Online Platform**, a responsive website (Flutter Web) built for the Rede Campo research group.

The application is a front-end that consumes its own REST API and provides:

- **Public area:** home, about us, news, projects, events, publications (articles, theses, books, and book chapters), and members.
- **Admin panel** (`/admin`, protected by JWT login): management of news, projects, events, publications, and members.

## Prerequisites

To build and run this project, you will need the following tools installed on your machine:

- **Flutter:** Version 3.16.4 - `stable` channel (use [Puro](https://puro.dev/) to manage Flutter versions)
- **Dart:** Version 3.2.3 (bundled with Flutter 3.16.4)
  - Constraint declared in `pubspec.yaml`: `sdk: '>=3.2.3 <4.0.0'`
- **Chrome / Chromium browser** (Flutter Web run and debug target)
- **Rede Campo Online API** running (REST back-end consumed by the app)

> ⚠️ **Supported target:** this project is built for **Web** only. The repository does not contain the `android/` and `ios/` folders, so Java, Gradle, AGP, and Kotlin are not required.

📌 **Sample `pubspec.yaml` excerpt:**

```yaml
environment:
  sdk: '>=3.2.3 <4.0.0'
```

📌 **Pinning the Flutter version with Puro:**

```bash
puro create rede_campo 3.16.4
puro use rede_campo
```

## Environment configuration

The API address and routes are centralized in `lib/core/global/constants/api_constants.dart`:

```dart
enum BaseEnvironment {
  development('http://127.0.0.1:3308');
  //production('https://');

  final String baseURL;

  const BaseEnvironment(this.baseURL);
}

final baseURL = BaseEnvironment.development.baseURL;
```

Before running the application in another environment:

1. Uncomment/adjust the `production` entry of the `BaseEnvironment` enum with the public API URL.
2. Change `final baseURL = ...` to the desired environment.
3. Provide the JWT secret via `--dart-define` (the `jwtSecret` constant is read from `String.fromEnvironment('JWT_SECRET')`):

```bash
flutter run -d chrome --dart-define=JWT_SECRET=your_secret_here
```

## Running the project

1. **Clone the repository:**

   ```bash
   git clone https://github.com/diegodallaqua/rede_campo_online.git
   ```

2. **Go to the project directory:**

   ```bash
   cd rede_campo_online
   ```

3. **Install Flutter dependencies:**

   ```bash
   flutter pub get
   ```

4. **Generate MobX files (`*.g.dart`):**

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

   During development, to regenerate automatically on every change:

   ```bash
   flutter packages pub run build_runner watch --delete-conflicting-outputs
   ```

5. **Run the application:**

   ```bash
   flutter run -d chrome
   ```

   If the API uses a self-signed certificate (common on internal VMs):

   ```bash
   flutter run -d chrome --web-browser-flag=--ignore-certificate-errors
   ```

6. **If needed, delete duplicated code generation files:**

   ```bash
   find . -name "*.g [0-9]*.dart" -type f -delete
   ```

   On PowerShell (Windows):

   ```powershell
   Get-ChildItem -Recurse -Filter "*.g [0-9]*.dart" | Remove-Item
   ```

7. **Analyze and test:**

   ```bash
   flutter analyze
   flutter test
   ```

8. **Check whether the API server is up:**

   ```bash
   for pair in "development|http://127.0.0.1:3308"; do
     env=${pair%%|*}
     url=${pair#*|}
     code=$(curl -k -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
     case "$code" in 2*|3*) state="ON";; *) state="OFF";; esac
     echo "$env ($url): $state (HTTP $code)"
   done
   ```

   Add the `"production|https://<vm-host>:<port>"` pair to the list once the production environment is configured.

## Build and deployment

```bash
flutter build web --release --dart-define=JWT_SECRET=your_secret_here
```

The output is placed in `build/web/`. See [DEPLOY.md](DEPLOY.md) for VM hosting instructions (Nginx, `--base-href`, HTTPS, and CORS).

## Project structure

The project follows a **feature-first** architecture with a shared `core/` layer:

- `lib/`: all Dart source code.
  - `app/`: entry point and navigation.
    - `main.dart`: initialization (dependency injection, `pt_BR` locale, session check) and `MaterialApp.router` with responsive breakpoints.
    - `router.dart`: `go_router` routes (`AppRoutes`) and access guard for the `/admin` area.
  - `core/`: code shared across features.
    - `global/`: `injection.dart` (GetIt) and `constants/api_constants.dart` (base URL + API routes).
    - `models/`: cross-cutting models (addresses, cities, states, organizations, contributors, roles, auth token, media, etc.).
    - `repositories/`: cross-cutting repositories (addresses, organizations, research areas, image upload, token, translation, etc.).
    - `stores/`: base MobX stores - `BaseStore`, `PagedStore<T>` (paginated listings), `MediaMapStore<M>`, `FilterSearchStore`, `TranslationStore`, and `UserManagerStore` (session).
    - `ui/`: reusable components - `buttons/`, `forms/`, `listing_tiles/`, `sections/`, `theme/` (`CustomColors`), and `widgets/` (including the generic admin listing widgets in `widgets/admin/`).
    - `utils/`: pure utilities (formatters, placeholders, toasts, API error message handling).
  - `features/`: one folder per domain (`home`, `about_us`, `news`, `projects`, `events`, `publications`, `articles`, `books`, `book_chapters`, `thesis`, `members`, `login`, `admin`). Each feature follows the same internal layout:
    - `models/`: models for that domain.
    - `repositories/`: HTTP access for that domain.
    - `stores/`: MobX stores for that domain.
    - `screens/`: screens and their `widgets/` (`sections/`, `listing/`), with `*_desktop_version.dart` and `*_mobile_version.dart` variants.
- `assets/`: application images and fonts (`assets/images/`, `assets/fonts/RobotoSlab.ttf`).
- `web/`: Web platform-specific files (`index.html`, `manifest.json`, icons, and favicon).
- `*.puml`: project UML diagrams (see section below).

## Architecture and main libraries

| Responsibility | Library / Pattern |
| --- | --- |
| State management | `mobx` + `flutter_mobx` (stores with code generated by `mobx_codegen`) |
| Dependency injection | `get_it` (`setupDependencies()` in `core/global/injection.dart`) |
| Navigation | `go_router` (routes declared in `app/router.dart`) |
| Responsiveness | `responsive_framework` (breakpoints: mobile 400, tablet 768, desktop 1024) |
| HTTP communication | `http` + `http_parser` |
| Authentication | `dart_jsonwebtoken` (reads `exp`) + `flutter_secure_storage` (token persistence) |
| Images | `image_picker`, `image_cropper`, `cached_network_image` |
| Formatting | `intl`, `brasil_fields` |

Conventions new code should follow:

- Paginated listings extend `PagedStore<T>` and implement only `fetchPage(int)` - they do not need their own `.g.dart`.
- Admin panel listings reuse the generic `AdminEntityListSection{Desktop,Mobile}Version<T>` and `AdminEntityList{Desktop,Mobile}Version<T>` widgets (`core/ui/widgets/admin/`), parameterized by store, texts, `itemBuilder`, and `gridDelegate`.
- Media upload uses `MediaUploadField`, generic over the `MediaAttachment` interface (`core/models/`).
- Models, repositories, and stores shared by more than one feature live in `core/models`, `core/repositories`, and `core/stores` - never in `core/utils`.

## License

This repository is public only for portfolio and academic demonstration purposes and **is not open source software**. All rights are reserved by the author. Copying, modifying, redistributing, or using this code (in whole or in part), including by third parties, requires prior written permission. See the [LICENSE](LICENSE) file for the full text.

Developed as an undergraduate thesis (Trabalho de Conclusão de Curso - TCC) for the Rede Campo research group, which maintains its own modified version of this software under a separate agreement.
