# Flowa - Flutter Task Manager

Flowa is a premium, modern task management application built with Flutter and Firebase. It features a sleek dark-mode design, real-time Firestore synchronization, and daily motivational quotes via REST API.

## 🚀 Features

- **Secure Authentication**: Firebase Email/Password Sign Up and Login.
- **Task CRUD**: Create, Read, Update, and Delete tasks in real-time.
- **Task Status**: Manage task progress (Pending, In-Progress, Completed).
- **Daily Inspiration**: Random motivational quotes fetched from `quotable.io`.
- **Premium UI**: Built with Google Fonts (Sora & DM Sans) and custom glassmorphism-inspired widgets.

## 🛠️ Setup Instructions

### 1. Prerequisites
- **Flutter SDK**: v3.41.9
- **Dart SDK**: v3.11.5
- Firebase Account.
- Android Studio / VS Code.

### 2. Firebase Configuration
1. Create a new Firebase Project at [Firebase Console](https://console.firebase.google.com/).
2. Enable **Email/Password Authentication**.
3. Create a **Firestore Database** in Test Mode.
4. Add an Android App with package name `com.example.flowa`.
5. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
6. Place `google-services.json` in `android/app/` and `GoogleService-Info.plist` in `ios/Runner/`.
7. (Optional) Run `flutterfire configure` to update `firebase_options.dart`.

### 3. Running the App
```bash
# Clone the repository
git clone https://github.com/Praveen0586/flowa.git

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 4. Generating APK
To generate the release APK for submission:
```bash
flutter build apk --split-per-abi
```
The file will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## 📂 Folder Structure
- `lib/models/`: Data structures (TaskModel).
- `lib/services/`: Logic for Firebase Auth, Firestore, and Quote API.
- `lib/screens/`: UI Screens (Login, Signup, Home, Profile, etc.).
- `lib/widgets/`: Reusable UI components.

---
**Developed for the Flutter Development Internship Assignment.**
