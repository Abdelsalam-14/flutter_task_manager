# Task Flow - Professional Flutter Task Manager

A clean, modern, and intuitive Flutter application designed to organize daily tasks, set priorities, and track completion progress. Built with a premium UI/UX, light/dark themes, and robust local persistence.

## Features

- **Full Task CRUD**: Add, edit, delete, and mark tasks as completed.
- **Priority Indicator**: Label tasks as Low (Teal), Medium (Orange), or High (Red) priority.
- **Due Date Selector**: Set completion deadlines using an intuitive native date picker.
- **Filter & Search**: Search tasks instantly and filter by completion status (All, Active, Completed) or priority levels.
- **Visual Progress Dashboard**: Interactive radial score and linear progress bar showing daily completion rates.
- **Local Persistence**: Instant saving using `SharedPreferences` to secure data between sessions.
- **Dynamic Dark/Light Mode**: Toggle dark/light themes with a single tap.
- **RTL & Arabic Support**: Fully localized in Arabic with native RTL layouts.

## Technology Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider
- **Local Storage**: SharedPreferences
- **Localization**: flutter_localizations (RTL support)

## Getting Started

### Prerequisites

Ensure you have Flutter SDK installed on your system.

### Running the App

1. Clone this repository.
2. Open your terminal in the project directory.
3. Run the following commands:
   ```bash
   flutter pub get
   flutter run
   ```
