# Create a New Feature

This guide explains the recommended workflow for implementing a new feature using the project architecture.

---

# Step 1 - Create the Feature

Inside `lib/features`, create a new folder.

Example:

```text
lib/
└── features/
    └── product/
```

---

# Step 2 - Create the Feature Structure

```text
product/
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
    ├── notifiers/
    ├── pages/
    ├── providers/
    ├── states/
    └── widgets/
```

Follow this structure for every feature.

---

# Step 3 - Create the Entity

Create the business object.

Example:

```text
domain/entities/product.dart
```

The entity should contain only business data.

---

# Step 4 - Create the Model

Create the API/Database model.

Example:

```text
data/models/product_model.dart
```

The model should:

* extend the Entity
* implement `fromJson()`
* implement `toJson()`

---

# Step 5 - Create Data Sources

If the feature communicates with an API:

```text
data/datasources/

product_remote_datasource.dart
```

If offline support is required:

```text
product_local_datasource.dart

product_local_datasource_impl.dart
```

---

# Step 6 - Create Repository

Repository interface:

```text
domain/repository/
```

Repository implementation:

```text
data/repository/
```

The repository decides where data comes from.

Typical flow:

```text
UI
 ↓
Repository
 ↓
Remote API
 ↓
Cache SQLite
```

---

# Step 7 - Register Providers

Register the new dependencies inside:

```text
core/providers/
```

Typically:

* datasource_providers.dart
* repository_providers.dart

---

# Step 8 - Create State

Create the feature state.

Example:

```text
presentation/states/

product_state.dart
```

Keep state immutable.

---

# Step 9 - Create Notifier

Create the business logic.

Example:

```text
presentation/notifiers/

product_notifier.dart
```

The notifier should:

* load data
* update state
* call repository methods

Do not place business logic inside widgets.

---

# Step 10 - Create UI

Create:

```text
pages/

widgets/
```

Keep pages small.

Move reusable components into the widgets folder.

---

# Step 11 - Register Routes

Add the page to GoRouter.

Example:

```dart
GoRoute(
  path: '/products',
  builder: (context, state) => const ProductPage(),
)
```

---

# Step 12 - Test

Verify:

* Loading state
* Empty state
* Error state
* Offline behavior (if applicable)
* Navigation
* CRUD operations

---

# Step 13 - Format & Analyze

Run:

```bash
make format
make analyze
```

Fix every warning before committing.

---

# Development Checklist

Use this checklist whenever creating a new feature.

* [ ] Create feature folder
* [ ] Create entity
* [ ] Create model
* [ ] Create remote datasource
* [ ] Create local datasource (optional)
* [ ] Create repository interface
* [ ] Create repository implementation
* [ ] Register providers
* [ ] Create state
* [ ] Create notifier
* [ ] Build UI
* [ ] Register routes
* [ ] Test feature
* [ ] Run format
* [ ] Run analyze

---

# Guiding Principles

* Follow Clean Architecture.
* Keep business logic out of UI.
* Reuse shared widgets whenever possible.
* Use dependency injection through Riverpod.
* Prefer small, reusable components.
* Build MVPs first, then iterate.
