# Google Sign-In Release Mode Fix

## Current Issue
Google Sign-In error code 10 in release mode: `PlatformException(sign_in_failed, com.google.android.gms.common.api.j: 10: , null, null)`

## Required SHA-1 Fingerprints for Firebase Console

### 1. Debug SHA-1 (for development builds)
```
11:46:A4:A0:3F:37:6E:6D:C5:B4:66:E5:2A:B0:10:A2:D9:58:02:65
```

### 2. Release SHA-1 (for release builds) - **MUST BE ADDED TO FIREBASE**
```
70:08:CA:92:68:6F:43:79:39:A9:AA:B2:4E:8C:B5:E9:BA:3D:78:59
```

## Step-by-Step Firebase Configuration

### Step 1: Add SHA-1 Fingerprints to Firebase
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `pco-app-3d42d`
3. Click on Project Settings (⚙️ gear icon)
4. Scroll down to "Your apps" section
5. Find your Android app (`com.pco.pcoapp`)
6. Click "Add fingerprint" and add:
   ```
   70:08:CA:92:68:6F:43:79:39:A9:AA:B2:4E:8C:B5:E9:BA:3D:78:59
   ```

### Step 2: Download Updated google-services.json
1. After adding the SHA-1, click "Download google-services.json"
2. Replace the existing file at: `android/app/google-services.json`

### Step 3: Verify Configuration
Ensure your Firebase console shows:
- ✅ Package name: `com.pco.pcoapp`
- ✅ Debug SHA-1: `11:46:A4:A0:3F:37:6E:6D:C5:B4:66:E5:2A:B0:10:A2:D9:58:02:65`
- ⚠️ Release SHA-1: `70:08:CA:92:68:6F:43:79:39:A9:AA:B2:4E:8C:B5:E9:BA:3D:78:59` **← ADD THIS**

### Step 4: Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

## Alternative: If uploading to Google Play Store

If you're uploading to Google Play Store, you also need the Play Store's signing certificate SHA-1:

1. Go to Google Play Console
2. Navigate to: App signing → App signing key certificate
3. Copy the SHA-1 certificate fingerprint
4. Add this SHA-1 to Firebase as well

## Client IDs in Firebase
Your google-services.json should contain:
- Android client ID: `906367301565-4kcsf4s68lf9o0l6qqsn5g12csqnhdvd.apps.googleusercontent.com`
- Web client ID: `906367301565-lupte21f5ai9nu8mu98ualkou76rgvjr.apps.googleusercontent.com` (used in code)

## Test Commands
```bash
# Test debug build
flutter run --debug

# Test release build
flutter run --release

# Build release APK for testing
flutter build apk --release
```
