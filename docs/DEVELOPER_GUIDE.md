# Developer Guide

This document explains the project architecture and the recommended development workflow.

---

# Architecture

The project follows **Clean Architecture** using a feature-first approach.

```text
lib/
├── core/
├── features/
├── shared/
└── l10n/
```

---

# Feature Structure

Each feature should follow this structure.

```text
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repository/
│
├── domain/
│   ├── entities/
│   ├── repository/
│   └── usecases/
│
└── presentation/
    ├── pages/
    ├── widgets/
    ├── providers/
    ├── notifiers/
    └── states/
```

---

# Development Flow

Always implement features in this order:

1. Entity
2. Model
3. Remote Data Source
4. Local Data Source (if required)
5. Repository
6. Provider Registration
7. State
8. Notifier
9. UI
10. Route

---

# Data Flow

```
UI
 ↓
Notifier
 ↓
Repository
 ↓
Remote Data Source
 ↓
REST API
```

Offline-first flow:

```
Repository
      ↓
Remote API
      ↓
SQLite Cache
      ↓
Return Cached Data
```

---

# Folder Responsibilities

| Folder   | Responsibility             |
| -------- | -------------------------- |
| core     | Application infrastructure |
| features | Business features          |
| shared   | Reusable UI components     |
| l10n     | Localization resources     |

---

# Where Should Code Go?

| Task                      | Location               |
| ------------------------- | ---------------------- |
| API request               | data/datasources       |
| JSON model                | data/models            |
| Entity                    | domain/entities        |
| Repository implementation | data/repository        |
| Business logic            | presentation/notifiers |
| State                     | presentation/states    |
| Screen                    | presentation/pages     |
| Reusable widget           | shared/widgets         |
| Common service            | core/services          |
| Common providers          | core/providers         |

---

# Providers

All global providers are located in:

```text
lib/core/providers/
```

Typical provider files:

* network_providers.dart
* repository_providers.dart
* datasource_providers.dart
* storage_providers.dart
* service_providers.dart
* database_providers.dart

Keep feature-specific providers inside their respective feature.

---

# Theme

Theme switching is handled through Riverpod.

Supported modes:

* System
* Light
* Dark

---

# Localization

Localization files are located in:

```text
lib/l10n/
```

To add a new language:

1. Create a new `.arb` file.
2. Add translations.
3. Run:

```bash
flutter gen-l10n
```

Use localized strings:

```dart
context.l10n.dashboard
```

---

# Environment

Supported environments:

* Demo
* Live

Switch environments from the Settings screen.

---

# Shared Widgets

Before creating a new widget, check:

```text
shared/widgets/
```

Prefer reusing existing components rather than duplicating UI.

---

# Coding Guidelines

* Follow Clean Architecture.
* Keep business logic out of UI.
* Use dependency injection via Riverpod providers.
* Keep widgets small and reusable.
* Prefer composition over inheritance.
* Reuse shared widgets whenever possible.

---

# Before Every Commit

Run:

```bash
dart format .
flutter analyze
```

Fix all analyzer warnings and errors before committing.

---

# Recommended Development Workflow

When implementing a new feature:

* Create the feature structure.
* Build the domain layer.
* Implement data sources.
* Implement the repository.
* Register providers.
* Create state and notifier.
* Build the UI.
* Test online and offline behavior.
* Format and analyze the project.
* Commit meaningful changes.

Following this workflow keeps every feature consistent, maintainable, and easy to scale.
