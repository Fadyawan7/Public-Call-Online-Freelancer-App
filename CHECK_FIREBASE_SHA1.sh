#!/bin/bash

echo "🔍 Firebase SHA-1 Configuration Checker"
echo "======================================="
echo ""

# Get the SHA-1 fingerprints from keystores
DEBUG_SHA1=$(keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android 2>/dev/null | grep "SHA1:" | awk '{print $2}')
RELEASE_SHA1=$(keytool -list -v -alias upload -keystore android/app/keystore/upload-keystore.jks -storepass pcokeystore 2>/dev/null | grep "SHA1:" | awk '{print $2}')

echo "📱 Your Keystore SHA-1 Fingerprints:"
echo "DEBUG SHA-1:   $DEBUG_SHA1"
echo "RELEASE SHA-1: $RELEASE_SHA1"
echo ""

# Check what's in google-services.json
echo "📄 Current google-services.json Configuration:"
if [ -f "android/app/google-services.json" ]; then
    echo "✅ File exists"
    
    # Extract all certificate hashes from google-services.json
    echo "Configured certificate hashes:"
    grep -A 1 "certificate_hash" android/app/google-services.json | grep -v "certificate_hash" | while read -r line; do
        hash=$(echo "$line" | tr -d ' ",' | tr '[:upper:]' '[:lower:]')
        if [ ! -z "$hash" ]; then
            echo "   - $hash"
        fi
    done
    
    echo ""
    
    # Convert SHA-1 to hash format (remove colons and convert to lowercase)
    DEBUG_HASH=$(echo "$DEBUG_SHA1" | tr -d ':' | tr '[:upper:]' '[:lower:]')
    RELEASE_HASH=$(echo "$RELEASE_SHA1" | tr -d ':' | tr '[:upper:]' '[:lower:]')
    
    echo "🔍 Analysis:"
    
    # Check if debug SHA-1 is configured
    if grep -q "$DEBUG_HASH" android/app/google-services.json; then
        echo "✅ Debug SHA-1 is configured"
    else
        echo "❌ Debug SHA-1 is NOT configured"
    fi
    
    # Check if release SHA-1 is configured
    if grep -q "$RELEASE_HASH" android/app/google-services.json; then
        echo "✅ Release SHA-1 is configured"
    else
        echo "❌ Release SHA-1 is NOT configured"
    fi
    
    echo ""
    
    # Check if both are configured
    if grep -q "$DEBUG_HASH" android/app/google-services.json && grep -q "$RELEASE_HASH" android/app/google-services.json; then
        echo "🎉 SUCCESS: Both SHA-1 fingerprints are properly configured!"
        echo "   Google Sign-In should now work in both debug and release modes."
    else
        echo "🚨 PROBLEM: Some SHA-1 fingerprints are missing from Firebase!"
        echo "   This is why Google Sign-In might still fail."
    fi
    
else
    echo "❌ google-services.json not found!"
fi

echo ""
echo "🔍 To manually check Firebase Console:"
echo "   https://console.firebase.google.com/project/pco-app-3d42d/settings/general"
