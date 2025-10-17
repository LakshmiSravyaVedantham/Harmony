#!/bin/bash

echo "Setting up Spiritual Harmony Journal..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found"
    echo "Please create a .env file with your OpenAI API key:"
    echo "OPEN_AI_API_KEY=your_api_key_here"
    exit 1
fi

# Install dependencies
echo "Installing Flutter dependencies..."
flutter pub get

# Generate environment files
echo "Generating environment files..."
dart run build_runner build --delete-conflicting-outputs

echo "Setup complete! You can now run the app with: flutter run"
