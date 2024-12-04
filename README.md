# ToDo-Obsidian

A modern Flutter Todo app with clean architecture and Obsidian documentation.

## Project Overview

This project combines the power of Flutter for app development with Obsidian for documentation and project management. It demonstrates best practices in mobile app development while maintaining comprehensive documentation.

## Features (Planned)

- ✨ Clean, intuitive UI with Material Design 3
- 📝 Basic task management (CRUD operations)
- 🏷️ Task categories and tags
- ⏰ Due dates and reminders
- ⭐ Priority levels
- 💾 Local storage with SQLite
- 🔄 Cloud sync (future feature)

## Tech Stack

- Flutter/Dart
- Provider for state management
- SQLite for local storage
- Material Design 3
- Firebase (planned for future)

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- VS Code or Android Studio
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/canncupiscent/ToDo-Obsidian.git

# Navigate to project directory
cd ToDo-Obsidian

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## Project Structure

```
lib/
├── core/              # Core functionality
│   ├── constants/     # App constants
│   ├── themes/        # App theming
│   └── utils/         # Utility functions
├── data/              # Data layer
│   ├── models/        # Data models
│   ├── providers/     # State management
│   └── repositories/  # Data repositories
├── features/          # Feature modules
│   ├── tasks/         # Task management
│   └── settings/      # App settings
└── ui/                # UI components
    ├── screens/       # App screens
    ├── widgets/       # Reusable widgets
    └── shared/        # Shared UI elements
```

## Documentation

Detailed documentation is maintained in the `docs/` directory and in our Obsidian vault. Key documentation includes:

- Architecture Overview
- Development Guidelines
- Feature Specifications
- UI/UX Guidelines

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.