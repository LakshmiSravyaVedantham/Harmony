# Spiritual Harmony Journal

A Flutter-based spiritual journaling app that combines AI-powered insights, nature scanning, and health data integration to help users reflect, find purpose, and calm their minds.

## Features

- **Journal Entries**: Write daily reflections and receive AI-generated spiritual insights
- **Spiritual Guru**: Ask questions and receive wisdom powered by OpenAI GPT
- **Nature Scan**: Use your camera to connect with nature (AR-ready)
- **Health Integration**: Sync with Apple Health/Google Fit for holistic insights
- **Local Storage**: All journal entries stored securely in SQLite database

## Prerequisites

- Flutter SDK (>=3.0.0)
- OpenAI API Key
- iOS/Android device or emulator

## Setup

1. Clone the repository:
```bash
git clone https://github.com/LakshmiSravya123/Harmony.git
cd harmony
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory:
```
OPEN_AI_API_KEY=your_openai_api_key_here
```

4. Generate environment files:
```bash
dart run build_runner build
```

5. Run the app:
```bash
flutter run
```

## Project Structure

```
harmony/
├── lib/
│   ├── env/           # Environment configuration
│   └── main.dart      # App entry point
├── providers/         # State management
│   └── journal_provider.dart
├── screens/           # UI screens
│   ├── home_screen.dart
│   ├── journal_screen.dart
│   ├── guru_screen.dart
│   └── nature_screen.dart
└── pubspec.yaml       # Dependencies
```

## Technologies Used

- **Flutter**: Cross-platform mobile framework
- **Provider**: State management
- **OpenAI API**: AI-powered insights and chat
- **SQLite**: Local database storage
- **Camera**: Nature scanning feature
- **Health**: Biometric data integration

## License

MIT License
