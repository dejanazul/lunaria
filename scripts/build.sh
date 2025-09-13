#!/bin/bash
set -e

# Optional: aktifkan web jika belum
flutter/bin/flutter config --enable-web

# Generate env.json dari Env Vars Vercel
bash ./scripts/generate-env.sh

# Build Flutter Web dengan env.json
flutter/bin/flutter build web --release --dart-define-from-file=env.json