#!/bin/bash


read -p "App Name: " APP_NAME

read -p "Bundle ID: " BUNDLE_ID


dart pub global run rename setAppName \
--value "$APP_NAME"


dart pub global run rename setBundleId \
--value "$BUNDLE_ID"


flutter clean

flutter pub get


echo "Done 🚀"