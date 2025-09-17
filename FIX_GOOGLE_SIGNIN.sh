#!/bin/bash

echo "🔧 Google Sign-In Release Mode Fix Script"
echo "=========================================="
echo ""

echo "📋 Your SHA-1 Fingerprints:"
echo "DEBUG SHA-1:   11:46:A4:A0:3F:37:6E:6D:C5:B4:66:E5:2A:B0:10:A2:D9:58:02:65"
echo "RELEASE SHA-1: 70:08:CA:92:68:6F:43:79:39:A9:AA:B2:4E:8C:B5:E9:BA:3D:78:59"
echo ""

echo "🚨 CRITICAL: The release SHA-1 is NOT in your Firebase configuration!"
echo "   Your google-services.json only contains the debug certificate hash."
echo ""

echo "📝 TO FIX:"
echo "1. Go to: https://console.firebase.google.com/project/pco-app-3d42d/settings/general"
echo "2. Find your Android app (com.pco.pcoapp)"
echo "3. Add this SHA-1 fingerprint:"
echo "   70:08:CA:92:68:6F:43:79:39:A9:AA:B2:4E:8C:B5:E9:BA:3D:78:59"
echo "4. Download the new google-services.json"
echo "5. Replace android/app/google-services.json"
echo ""

echo "🧹 Cleaning Flutter build..."
flutter clean
echo ""

echo "📦 Getting dependencies..."
flutter pub get
echo ""

echo "✅ Ready! After updating Firebase:"
echo "   flutter build apk --release"
echo "   flutter install --release"
echo ""

echo "🔍 Current google-services.json certificate hashes:"
grep -A 3 "certificate_hash" android/app/google-services.json
