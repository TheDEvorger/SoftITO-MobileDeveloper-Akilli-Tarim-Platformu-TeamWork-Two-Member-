#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
flutter doctor
flutter create --project-name akilli_tarim_platformu --platforms=android,ios .
flutter pub get
flutter analyze
flutter test
flutter devices
