# Logistic Operation

A Flutter logistics operation template built with Clean Architecture, Riverpod, GoRouter, and Dio. The project supports both **Demo Mode** (JSON Server) and **Live Mode** (REST API).

## Features

* Clean Architecture
* Riverpod State Management
* GoRouter Navigation
* Dio Networking
* Authentication
* CRUD Operations
* Search & Filter
* Dashboard Summary
* Pull to Refresh
* Reusable Widgets
* Demo Mode (JSON Server)
* Live Mode (REST API)

## Requirements

* Flutter SDK
* Dart SDK
* Node.js (for Demo Mode)

## Installation

```bash
git clone <repository-url>

cd flutter_mvp_starter

flutter pub get
```

## Demo Mode

Navigate to the mock server:

```bash
cd backend/mock/

npm install

npm start
```

The mock server will start on:

```text
http://localhost:3000
```

Then run Flutter:

```bash
flutter run
```

## Live Mode

Configure your production API in:

```text
lib/core/config/app_config.dart
```

Update the base URL and switch the environment to `live`.

Then run:

```bash
flutter run
```

## Project Structure

```text
lib/
 ├── core/
 ├── shared/
 └── features/
```

## Developed by
Tahsin Hasan
