# Flutter MVP Starter

A production-ready Flutter starter template built with **Clean Architecture**, **Riverpod**, and **Offline-First** principles.

Clone this repository to quickly bootstrap MVPs and production-ready mobile applications without rebuilding the project structure every time.

---

## Features

* Clean Architecture
* Feature-first structure
* Riverpod state management
* GoRouter navigation
* Dio networking
* Offline-first foundation (SQLite)
* Authentication structure
* Environment switching (Demo / Live)
* Light / Dark / System theme
* Localization (English / Bangla)
* Shared UI components
* Responsive design foundation
* Android, iOS, Web, Windows, Linux & macOS support

---

## Getting Started

Clone the repository:

```bash
git clone <repository-url>
cd flutter_mvp_starter
```

Run the setup:

```bash
make setup
```

The setup script will configure:

* Project name
* Application name
* Android/iOS package name (Bundle ID)

Then install dependencies and run the project:

```bash
flutter pub get
flutter run
```

---

## Development Commands

Run the application:

```bash
make run
```

Analyze the project:

```bash
make analyze
```

Format the project:

```bash
make format
```

Clean the project:

```bash
make clean
```

---

## Project Structure

```text
lib/
├── core/          # Shared infrastructure
├── features/      # Business features
├── shared/        # Reusable widgets
└── l10n/          # Localization
```

---

## Building a New App

1. Clone the template.
2. Run `make setup`.
3. Create your first feature.
4. Remove or replace the sample Shipment feature.
5. Build your application.

The template already provides the common infrastructure required by most Flutter applications, allowing you to focus only on business logic.

---

## Included Infrastructure

* Authentication
* API Client
* Environment Management
* Offline Storage
* Navigation
* Theme Management
* Localization
* Shared Widgets
* Error Handling
* Repository Pattern

---

## Best Suited For

* MVP Applications
* E-Commerce
* Logistics
* School Management
* Healthcare
* Inventory
* Booking Systems
* SaaS Mobile Clients
* Internal Business Apps

---

## License

Released under the MIT License.
