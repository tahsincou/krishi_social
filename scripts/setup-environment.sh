#!/bin/bash

set -e

OLD_PACKAGE_NAME=$(grep '^name:' pubspec.yaml | awk '{print $2}')

read -p "Flutter package name (example: krishi_social): " PACKAGE_NAME
read -p "App display name (example: Krishi Social): " APP_NAME
read -p "Bundle ID (example: com.tahsin.krishisocial): " BUNDLE_ID

if [[ ! "$PACKAGE_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "Invalid Flutter package name."
  echo "Use lowercase letters, numbers and underscores only."
  exit 1
fi

echo "Renaming Flutter package:"
echo "$OLD_PACKAGE_NAME -> $PACKAGE_NAME"

# Update pubspec.yaml package name
sed -i "s/^name: .*/name: $PACKAGE_NAME/" pubspec.yaml

# Update description
sed -i "s/^description: .*/description: \"$APP_NAME\"/" pubspec.yaml

# Replace Dart package imports
grep -rl \
  --include="*.dart" \
  "package:$OLD_PACKAGE_NAME/" \
  lib test 2>/dev/null | while read -r file; do
    sed -i \
      "s|package:$OLD_PACKAGE_NAME/|package:$PACKAGE_NAME/|g" \
      "$file"
done

# Install rename package if missing
if ! dart pub global list | grep -q "^rename "; then
  dart pub global activate rename
fi

# Change visible app name
dart pub global run rename setAppName \
  --value "$APP_NAME"

# Change Android/iOS bundle ID
dart pub global run rename setBundleId \
  --value "$BUNDLE_ID"

flutter clean
flutter pub get

echo ""
echo "Setup complete"
echo "Package name: $PACKAGE_NAME"
echo "App name: $APP_NAME"
echo "Bundle ID: $BUNDLE_ID"