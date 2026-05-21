# Fins

A personal finance tracker built for offline use, designed to help users manage expenses, budgets, and financial summaries — right from their Android device.

Fins replaces manual expense logging with a structured, intuitive tool for tracking income and expenses, setting budgets, and visualizing spending patterns — all stored locally on-device.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Logical View](#logical-view)
- [Software Architecture](#software-architecture)
- [Project Structure](#project-structure)
- [Authors](#authors)

---

## Features

- **Fully offline, no login required** — Get started immediately; all user data and settings are stored locally on the device
- **Expense management (CRUD)** — Create, read, update, and delete both past and future expenses; organize them using preset or custom categories
- **Cash in recording** — Log incoming funds to automatically adjust to the user's remaining budget
- **Receipt scanner** — Scan receipts with your camera or upload from gallery; the app automatically extracts and fills in the expense details
- **Budget & notifications** — Set and edit budget limits, and configure personalized reminder notifications
- **Summary reports** — View monthly and weekly expense summaries, browse past expenses, and compare spending by day and week
- **Financial insights** — Get fully offline AI-powered analysis of your spending habits, with actionable advice on saving and improving financial health
- **Theme customization** — Personalize the app's appearance by choosing from a selection of available themes
  
---

## Tech Stack

Fins is a Flutter mobile application targeting Android, with local SQLite storage.

| Package / Tool | Purpose |
|---|---|
| `Flutter` | UI framework and cross-platform mobile development |
| `SQLite` | Local data persistence |
| `Android Notification System` | Scheduled reminders and alerts |

---

## Setting Up

### Prerequisites

| Tool | Download |
|---|---|
| Flutter SDK | [docs.flutter.dev](https://docs.flutter.dev/get-started/install) |
| Git | [git-scm.com](https://git-scm.com/downloads) |
| IDE | VS Code or Android Studio (with Flutter and Dart plugins) |

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Fins-Financial-Tracker/CMSC128_FinTracker
cd CMSC128_FinTracker
```

**2. Check your environment**

```bash
flutter doctor
```

Resolve any issues flagged before proceeding.

**3. Install dependencies**

```bash
flutter pub get
```

---

### Running the App

#### Option A — Android APK (Recommended)

**1. Generate the APK**

```bash
flutter build apk --split-per-abi
```

**2. Locate the output files**

```
build/app/outputs/flutter-apk/
```

| APK | Use case |
|---|---|
| `app-arm64-v8a-release.apk` | Most modern Android phones |
| `app-armeabi-v7a-release.apk` | Older or budget Android devices |

**3. Install on your device**

*Option 1 — Manual transfer:* Send the `.apk` to your phone via Discord, Google Drive, or USB. Open the file on your phone, allow "Install from Unknown Sources" when prompted, then launch the app.

*Option 2 — ADB (via USB cable):*

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

#### Option B — Windows Desktop

**1. Install [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/)**
   - Select the **Desktop development with C++** workload during installation.
   - Ensure all default components are checked.

**2. Enable Developer Mode**
   - Go to **Windows Settings > Privacy & Security > For developers**.
   - Toggle **Developer Mode** to On.

**3. Enable Windows desktop support in Flutter**

```bash
flutter config --enable-windows-desktop
```

**4. Run the app**

```bash
flutter run -d windows
```

---

#### Option C — Android Emulator (Android Studio)

**1. Install [Android Studio](https://developer.android.com/studio)**

**2. Set up a virtual device**
   - Open Android Studio and go to **Tools > Device Manager**.
   - Click **Create Device** and select a phone (e.g., Pixel 7).
   - Download a system image (API 34 or higher recommended).
   - Finish setup and click the **Play** button to start the emulator.

**3. Verify Flutter detects the emulator**

```bash
flutter devices
```

**4. Run the app**

```bash
flutter run
```

---

## Logical View

Fins follows a layered logical structure composed of the user interface, business logic, and local data storage.


```
<img width="718" height="830" alt="image" src="https://github.com/user-attachments/assets/8ed61ec4-5008-4f1b-a621-5a284fc4ccff" />

```

### Flow Description

1. The **User** interacts with the app through the UI layer (dashboard, forms, settings).
2. **User actions** are passed to the Business Logic layer for processing and validation.
3. **Managers** compute summaries, handle categories, and manage budgets.
4. The **Data Layer** persists all financial records locally via SQLite.
5. The **Notification Scheduler** triggers Android notifications, which surface back to the user.

This logical separation improves maintainability and clearly defines how system components collaborate.

---

## Software Architecture

Fins uses the **Model-View-ViewModel (MVVM)** architectural pattern.

| Layer | Implementation | Responsibility |
|---|---|---|
| **View** | Flutter widgets | UI screens (homepage, add expense, dashboard, etc.) |
| **ViewModel** | Presentation logic | Bridges View and Model; handles user interaction and state updates |
| **Model** | Data classes + SQLite | Core data structures (income, expenses, summaries); local persistence |

MVVM is widely adopted for mobile applications because it cleanly separates UI from backend logic, improving maintainability and testability. In Fins:

- The **View** is implemented using Flutter's widget system and does not directly access database operations.
- The **ViewModel** acts as the bridge — it exposes data from the Model to the View and handles user-triggered updates.
- The **Model** manages all core data (income entries, expense records, summaries) and interacts directly with local SQLite storage, with no dependency on a remote server.

---

## Project Structure

### Current Structure

```
CMSC128_FinTracker/
├── lib/
│   ├── main.dart                          # Entry point
│   │
│   ├── database/
│   │   └── db_helper.dart                 # Database operations (SQLite)
│   │
│   ├── pages/
│   │   ├── expense_model.dart             # Model: Expense data structure
│   │   ├── homepage.dart                  # View: Main screen
│   │   ├── add_expense.dart               # View: Add expense form
│   │   ├── summary.dart                   # View: Summary/Reports
│   │   ├── customizations.dart            # View: Settings
│   │   ├── profile.dart                   # View: User profile
│   │   └── landing.dart                   # View: Landing/splash screen
│   │
│   └── utils/
│       └── notification_helper.dart       # Utility: Notifications
│
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
└── pubspec.yaml
```

### MVC Layer Mapping (Current)

**Model** — Data & Business Rules

| File | Component | Responsibility |
|---|---|---|
| `lib/database/db_helper.dart` | DBHelper | Database initialization, CRUD operations |
| `lib/pages/expense_model.dart` | Expense class | Data structure for expenses (toMap, fromMap) |

**View** — User Interface

| File | Component | Responsibility |
|---|---|---|
| `lib/pages/landing.dart` | LandingPage | Splash/onboarding screen |
| `lib/pages/homepage.dart` | HomePage | Main dashboard, expense list |
| `lib/pages/add_expense.dart` | AddExpensePage | Form for creating/updating expenses |
| `lib/pages/summary.dart` | SummaryPage | Reports and analytics |
| `lib/pages/customizations.dart` | CustomizationsPage | User preferences/settings |
| `lib/pages/profile.dart` | ProfilePage | User profile information |

**Controller** — Business Logic *(currently scattered in pages)*

| File | Component | Responsibility |
|---|---|---|
| Scattered in `pages/` | Page widgets | Expense loading, filtering, data passing |
| `lib/utils/notification_helper.dart` | NotificationHelper | Triggers notifications |

> **Note:** Business logic is currently mixed within View pages. A dedicated controller/service layer is planned for a future refactor.

---

### Future Structure

```
CMSC128_FinTracker/
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   ├── expense.dart
│   │   └── user.dart
│   │
│   ├── views/
│   │   ├── screens/
│   │   │   ├── landing_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── add_expense_screen.dart
│   │   │   ├── summary_screen.dart
│   │   │   ├── customizations_screen.dart
│   │   │   └── profile_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── expense_item.dart
│   │       ├── bottom_nav_bar.dart
│   │       └── expense_form.dart
│   │
│   ├── controllers/
│   │   ├── expense_controller.dart
│   │   ├── user_controller.dart
│   │   └── notification_controller.dart
│   │
│   ├── services/
│   │   ├── database_service.dart
│   │   ├── notification_service.dart
│   │   └── storage_service.dart
│   │
│   └── config/
│       ├── constants.dart
│       └── theme.dart
│
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
└── pubspec.yaml
```

### Example Flow

**Current (problematic):**
```
View (HomePage)
  └→ Directly calls DBHelper
  └→ Manages state with static variables
  └→ Performs filtering and calculations
```

**Future:**
```
View (HomeScreen)
  → Controller (ExpenseController)
    → Service (DatabaseService)
      → Model (Expense class)
        → SQLite Database
```

---

## Authors

- Andrea Laserna
- Sam Lansoy
- Marinelle Joan Tambolero
- Michaela Borces
- Christel Hope Ong
- Sophe Mae Dela Cruz
