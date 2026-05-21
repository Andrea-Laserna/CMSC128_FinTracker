# Fins

<p align="center">
  <strong>An Offline-First Personal Finance Tracker</strong>
</p>

<p align="center">
  Manage expenses, track budgets, monitor cash flow, and gain financial insights — all without requiring an internet connection.
</p>

---

## Overview

Fins is a personal finance tracking application designed for users who want a simple, reliable, and privacy-focused way to manage their finances.

Instead of relying on spreadsheets or manual record-keeping, Fins provides a structured platform for recording expenses, managing budgets, monitoring cash flow, and reviewing financial summaries. All data is stored locally on the device, ensuring complete ownership and privacy of financial information.

---

## Table of Contents

- [Features](#features)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Application](#running-the-application)
- [Logical View](#logical-view)
- [Software Architecture](#software-architecture)
- [Project Structure](#project-structure)
- [Authors](#authors)

---

# Features

### Expense Management

Manage expenses through complete CRUD functionality.

- Create, view, update, and delete expense records
- Support for both past and future expenses
- Organize expenses using preset or custom categories
- Maintain a detailed history of financial transactions

### Cash In Recording

Track incoming funds and monitor available spending capacity.

- Record cash inflows and additional income sources
- Automatically update remaining budget allocations

### Receipt Scanner

Digitize expense entries with OCR-assisted receipt processing.

- Capture receipts using the device camera
- Import receipts directly from the gallery
- Automatically extract and populate expense information

### Budget Management & Notifications

Stay within financial limits through budgeting tools and reminders.

- Create and modify budget limits
- Configure personalized notification schedules
- Receive reminders for financial activities and deadlines

### Summary Reports

Visualize and review spending patterns over time.

- Weekly and monthly financial summaries
- Historical expense browsing
- Spending comparisons across different periods

### Financial Insights

Receive AI-powered spending analysis without requiring an internet connection.

- Fully offline financial analysis
- Personalized spending observations
- Actionable recommendations for improving financial habits

### Theme Customization

Personalize the application's appearance.

- Multiple built-in themes
- Customizable user experience

### Privacy-First Design

All information remains on the user's device.

- No account creation required
- No cloud synchronization
- No internet connection required
- Local SQLite storage

---

# Technology Stack

Fins is built using Flutter and local storage technologies to provide a fully offline experience.

| Technology | Purpose |
|------------|----------|
| **Flutter** | Cross-platform mobile application development |
| **SQLite** | Local data persistence |
| **Android Notification System** | Scheduled reminders and alerts |

---

# Getting Started

## Prerequisites

Before running the project, ensure the following tools are installed:

| Tool | Download |
|------|----------|
| Flutter SDK | https://docs.flutter.dev/get-started/install |
| Git | https://git-scm.com/downloads |
| IDE | Visual Studio Code or Android Studio |

---

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Fins-Financial-Tracker/CMSC128_FinTracker
cd CMSC128_FinTracker
```

### 2. Verify Flutter Installation

```bash
flutter doctor
```

Resolve any issues reported before proceeding.

### 3. Install Dependencies

```bash
flutter pub get
```

---

## Running the Application

### Option A — Android APK (Recommended)

#### Build the APK

```bash
flutter build apk --split-per-abi
```

#### Locate the Generated Files

```text
build/app/outputs/flutter-apk/
```

| APK File | Recommended Device |
|-----------|------------------|
| `app-arm64-v8a-release.apk` | Most modern Android devices |
| `app-armeabi-v7a-release.apk` | Older Android devices |

#### Install on a Physical Device

**Manual Installation**

Transfer the APK through USB, cloud storage, or file sharing services. Open the APK on the device and allow installation from unknown sources when prompted.

**ADB Installation**

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

### Option B — Windows Desktop

#### 1. Install Visual Studio 2022

Install Visual Studio with:

- Desktop development with C++
- Default recommended components

#### 2. Enable Developer Mode

Navigate to:

**Settings → Privacy & Security → For Developers**

Enable **Developer Mode**.

#### 3. Enable Windows Desktop Support

```bash
flutter config --enable-windows-desktop
```

#### 4. Run the Application

```bash
flutter run -d windows
```

---

### Option C — Android Emulator

#### 1. Install Android Studio

Download and install Android Studio.

#### 2. Create a Virtual Device

1. Open **Tools → Device Manager**
2. Select **Create Device**
3. Choose a device profile
4. Download a system image (API 34+ recommended)
5. Launch the emulator

#### 3. Verify Device Detection

```bash
flutter devices
```

#### 4. Run the Application

```bash
flutter run
```

---

# Logical View

Fins follows a layered architecture composed of the User Interface, Business Logic, and Data Storage layers.

<p align="center">
  <img width="678" height="793" alt="Logical View Diagram" src="https://github.com/user-attachments/assets/e64e9156-66db-4f04-a4c4-b194ae4adaf7" />
</p>

## Flow Description

1. The **User** interacts with the application through the UI layer.
2. User actions are forwarded to the **Business Logic Layer** for processing and validation.
3. Managers compute summaries, handle categories, and manage budgets.
4. The **Data Layer** stores and retrieves records using SQLite.
5. The **Notification Scheduler** triggers reminders that are surfaced back to the user.

This separation improves maintainability and clearly defines how system components interact with one another.

---

# Software Architecture

Fins adopts the **Model–View–ViewModel (MVVM)** architectural pattern.

| Layer | Implementation | Responsibility |
|---------|--------------|---------------|
| **View** | Flutter Widgets | User interface screens and components |
| **ViewModel** | Presentation Logic | State management and interaction handling |
| **Model** | Data Classes + SQLite | Data representation and persistence |

## MVVM in Fins

### View

Responsible for displaying information and capturing user interactions.

Examples:

- Homepage
- Add Expense Screen
- Summary Dashboard
- Settings

### ViewModel

Acts as the bridge between the View and Model.

Responsibilities include:

- State management
- Data transformation
- User interaction handling
- Business process coordination

### Model

Represents the application's core data structures and persistence layer.

Examples:

- Expenses
- Income Records
- Financial Summaries
- SQLite Database

This separation reduces coupling between components and improves maintainability, scalability, and testability.

---

# Project Structure

## Current Structure

```text
CMSC128_FinTracker/
├── lib/
│   ├── main.dart
│   │
│   ├── database/
│   │   └── db_helper.dart
│   │
│   ├── pages/
│   │   ├── expense_model.dart
│   │   ├── homepage.dart
│   │   ├── add_expense.dart
│   │   ├── summary.dart
│   │   ├── customizations.dart
│   │   ├── profile.dart
│   │   └── landing.dart
│   │
│   └── utils/
│       └── notification_helper.dart
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

#### Model — Data & Business Rules

| File | Component | Responsibility |
|------|-----------|---------------|
| `lib/database/db_helper.dart` | DBHelper | Database initialization and CRUD operations |
| `lib/pages/expense_model.dart` | Expense Class | Expense data structure and mapping |

#### View — User Interface

| File | Component | Responsibility |
|------|-----------|---------------|
| `lib/pages/landing.dart` | LandingPage | Splash / onboarding screen |
| `lib/pages/homepage.dart` | HomePage | Main dashboard and expense list |
| `lib/pages/add_expense.dart` | AddExpensePage | Expense creation and editing |
| `lib/pages/summary.dart` | SummaryPage | Reports and analytics |
| `lib/pages/customizations.dart` | CustomizationsPage | User preferences and settings |
| `lib/pages/profile.dart` | ProfilePage | User profile information |

#### Controller — Business Logic

| File | Component | Responsibility |
|------|-----------|---------------|
| Scattered throughout `pages/` | Page Widgets | Expense loading, filtering, and state handling |
| `lib/utils/notification_helper.dart` | NotificationHelper | Notification scheduling |

> **Note:** Business logic is currently distributed across page widgets. A dedicated controller/service layer is planned for future refactoring.

---

## Future Structure

```text
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

**Current Architecture**

```text
View (HomePage)
 ├── Directly calls DBHelper
 ├── Manages state internally
 └── Performs filtering and calculations
```

**Planned Architecture**

```text
View (HomeScreen)
    ↓
ExpenseController
    ↓
DatabaseService
    ↓
Expense Model
    ↓
SQLite Database
```

---

# Authors

<div align="center">

| Team Members |
|-------------|
| Andrea Laserna |
| Sam Lansoy |
| Marinelle Joan Tambolero |
| Michaela Borces |
| Christel Hope Ong |
| Sophe Mae Dela Cruz |

</div>

---

<p align="center">
  Built as a CMSC 128 Software Engineering Project
</p>
