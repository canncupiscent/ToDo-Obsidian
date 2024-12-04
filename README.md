# ToDo-Obsidian

A modern Flutter Todo app with clean architecture and Obsidian documentation.

## Project Overview

This project combines the power of Flutter for app development with Obsidian for documentation and project management. It demonstrates best practices in mobile app development while maintaining comprehensive documentation.

## Features (Implemented)

- ✨ Clean, intuitive UI with Material Design 3
- 📝 Basic task management (CRUD operations)
- ⏰ Due dates and reminders
- ❌ Swipe to delete tasks
- ✅ Task completion tracking

### Coming Soon
- 🏷️ Task categories and tags
- ⭐ Priority levels
- 💾 Local storage with SQLite
- 🔄 Cloud sync (future feature)

## Tech Stack

- Flutter/Dart
- Riverpod for state management
- SQLite for local storage (planned)
- Material Design 3
- Firebase (planned for future)

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- VS Code or Android Studio
- Git
- Chrome (for web development)

### Flutter Setup

1. Install Flutter SDK:
   ```bash
   # Download Flutter SDK from https://docs.flutter.dev/get-started/install
   
   # Add Flutter to your path (for zsh)
   echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.zshrc
   source ~/.zshrc
   
   # Verify installation
   flutter --version
   flutter doctor
   ```

2. Enable Platform Support:
   ```bash
   # For web support
   flutter config --enable-web
   
   # For macOS desktop support
   flutter config --enable-macos-desktop
   ```

### Installation

```bash
# Clone the repository
git clone https://github.com/canncupiscent/ToDo-Obsidian.git

# Navigate to project directory
cd ToDo-Obsidian

# Get dependencies
flutter pub get

# Enable web platform
flutter create --platforms=web .

# Run the app (choose one)
flutter run -d chrome  # For web
flutter run -d macos  # For macOS desktop
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

## Troubleshooting

1. **"Command not found: flutter"**
   - Make sure Flutter is properly installed and added to your PATH
   - Check your shell profile (.zshrc for zsh users)
   - Run `source ~/.zshrc` after updating PATH

2. **"No supported devices connected"**
   - Enable web support: `flutter config --enable-web`
   - Enable macOS support: `flutter config --enable-macos-desktop`
   - Create platform-specific projects: `flutter create --platforms=web .`

3. **Platform Selection**
   - Web: `flutter run -d chrome`
   - macOS: `flutter run -d macos`
   - List all devices: `flutter devices`

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