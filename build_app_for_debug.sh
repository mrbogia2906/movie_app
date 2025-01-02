echo "------------------------------------------------------------"
echo "🔥🔥🔥 Pulling dependencies..."
echo "------------------------------------------------------------"
fvm flutter pub get

echo "------------------------------------------------------------"
echo "🔥🔥🔥 Generating all files..."
echo "------------------------------------------------------------"
fvm flutter pub run build_runner build --delete-conflicting-outputs

echo "------------------------------------------------------------"
echo "🚀🚀🚀 Building Android app with debug mode..."
echo "------------------------------------------------------------"
fvm flutter build apk --debug lib/main.dart

echo "------------------------------------------------------------"
echo "📂📂📂 Opening Android app folder..."
echo "------------------------------------------------------------"
start ./build/app/outputs/flutter-apk/
