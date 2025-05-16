# QR Code Safety Scanner

## Project Overview
The QR Code Safety Scanner is a cross-platform application that scans QR codes, extracts URLs, and evaluates their safety using a Flask-based backend. The Flutter frontend provides a user-friendly interface for scanning QR codes via camera (mobile) or image upload (desktop), while the backend employs multiple layers of security checks to determine if a URL is malicious.

## Features
- **QR Code Scanning**: Supports mobile camera scanning and desktop image uploads.
- **URL Safety Analysis**: Uses heuristic analysis, machine learning, and simulated API checks to classify URLs as benign or malicious.
- **Multi-Layer Security**: Implements validation, sanitization, and error handling to ensure robust operation.
- **Cross-Platform**: Runs on iOS, Android, and desktop environments.

## Security Layers
The project incorporates several layers of security to protect users and ensure reliable operation:

### 1. Input Validation and Sanitization
- **Frontend (Flutter)**:
  - URLs extracted from QR codes are normalized to ensure they start with `http://` or `https://` (see `url_checker_service.dart`).
  - Invalid URLs (e.g., those without a valid domain or containing spaces) are rejected early with user-friendly error messages.
- **Backend (Flask)**:
  - The `/check_url` endpoint validates incoming JSON payloads, rejecting requests without a `url` field (returns HTTP 400).
  - URLs are cleaned using `urlparse` to remove query parameters and fragments, preventing injection attacks.

### 2. Network Security
- **Frontend**:
  - HTTP requests to the backend are sent with proper headers (`Content-Type: application/json`) to ensure compatibility and prevent malformed requests.
  - Cleartext traffic is explicitly allowed for development (configurable in `AndroidManifest.xml` and `Info.plist`) but can be secured with HTTPS in production.
- **Backend**:
  - Redirects are followed securely with a maximum limit (`max_redirects=5`) to prevent infinite loops.
  - SSL certificate verification checks for HTTPS URLs, flagging invalid, self-signed, or soon-to-expire certificates as potential risks.

### 3. Data Integrity and Analysis
- **Backend**:
  - Heuristic features (e.g., URL length, domain entropy, suspicious keywords) are extracted to detect phishing patterns.
  - A pre-trained Logistic Regression model evaluates URLs based on 23 features, providing a probabilistic maliciousness score.
  - Simulated Google Safe Browsing and VirusTotal checks (mocked for development) flag known malicious domains.
  - Results are cached with a TTL (30 minutes) to reduce redundant checks and improve performance.

### 4. Error Handling and User Safety
- **Frontend**:
  - Errors during scanning or backend communication are caught and displayed via `SnackBar` widgets, preventing app crashes.
  - Users are informed if a URL is invalid or the backend is unreachable, with options to retry.
- **Backend**:
  - Comprehensive exception handling ensures the server remains operational even if external services (e.g., network checks) fail.
  - Offline mode falls back to ML and heuristic scoring if network connectivity is unavailable.

### 5. Development Security Practices
- **Backend**:
  - Debug mode is enabled for development but disabled in production to prevent information leakage.
  - API keys (e.g., `GOOGLE_SAFE_BROWSING_KEY`, `VIRUSTOTAL_KEY`) are placeholders, requiring secure storage in environment variables for production.
- **Frontend**:
  - Dependencies are managed via `pubspec.yaml`, ensuring only trusted packages are used.
  - The app avoids storing sensitive data locally, relying on the backend for processing.

## Prerequisites
- **Flutter**: Install Flutter SDK (https://flutter.dev/docs/get-started/install).
- **Python**: Install Python 3.8+ (https://www.python.org/downloads/).
- **Tools**: Ensure `pip`, `flutter`, and a code editor (e.g., VS Code) are available.
- **Hardware**: A mobile device/emulator or desktop for testing.

## Project Structure
- `lib/`: Flutter source code, including UI (`screens/`), services (`services/`), and widgets (`widgets/`).
- `backend.py`: Flask backend for URL safety analysis.
- `requirements.txt`: Python dependencies for the backend.
- `README.md`: This documentation file.

## Setup Instructions

### 1. Backend Setup
1. **Navigate to the Project Root**:
   ```bash
   cd path/to/project
   ```
2. **Install Python Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
   - Dependencies: `flask`, `requests`, `numpy`, `scikit-learn`.
3. **Run the Flask Backend**:
   ```bash
   python backend.py
   ```
   - The server runs on `http://127.0.0.1:5000` (localhost) and the machine’s IP (e.g., `http://<your-ip>:5000`).
   - Note: Keep the server running during testing.

### 2. Flutter App Setup
1. **Navigate to the Flutter Project Directory**:
   ```bash
   cd path/to/project
   ```
2. **Install Flutter Dependencies**:
   ```bash
   flutter pub get
   ```
   - Key dependencies: `http`, `mobile_scanner`, `file_picker`, `wave`, `url_launcher`.
3. **Configure the Backend URL**:
   - Open `lib/services/url_checker_service.dart` and update `_baseUrl`:
     - **iOS Simulator or Local Testing**: `http://localhost:5000/check_url`
     - **Android Emulator**: `http://10.0.2.2:5000/check_url`
     - **Physical Device**: `http://<machine-ip>:5000/check_url`
       - Find the machine’s IP using `ipconfig` (Windows) or `ifconfig`/`ip addr` (Linux/Mac).
       - Example: `http://192.168.1.100:5000/check_url`
   - Example modification:
     ```dart
     static const String _baseUrl = 'http://localhost:5000/check_url';
     ```
4. **Enable Cleartext Traffic (Development Only)**:
   - **Android**: Edit `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <application android:usesCleartextTraffic="true">
     ```
   - **iOS**: Edit `ios/Runner/Info.plist`:
     ```xml
     <key>NSAppTransportSecurity</key>
     <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
     </dict>
     ```
   - Note: For production, configure the backend to use HTTPS and remove these settings.

### 3. Running the App
1. **Start the Flask Backend** (if not already running):
   ```bash
   python backend.py
   ```
2. **Run the Flutter App**:
   ```bash
   flutter run
   ```
   - Select the target device (emulator, simulator, or physical device).
3. **Test the App**:
   - **Mobile**: Scan a QR code using the camera.
   - **Desktop**: Upload an image containing a QR code.
   - The app extracts the URL, sends it to the backend, and displays the safety result in `ResultScreen`.

## Testing
- **Sample URLs**:
  - Safe: `https://example.com`, `https://trusted.com`
  - Malicious: `http://known-malicious.com`, `http://phishing-example.com`
- **Expected Behavior**:
  - The app displays whether the URL is safe (`isSafe: true/false`) and a message (e.g., "Score: 0.15 - ml + heuristics").
  - Errors (e.g., invalid URL, server unreachable) are shown via `SnackBar` with retry options.

## Security Considerations for Production
- **Backend**:
  - Use a production WSGI server (e.g., Gunicorn) with HTTPS.
  - Store API keys in environment variables (e.g., `.env` file with `python-dotenv`).
  - Implement rate limiting to prevent abuse.
- **Frontend**:
  - Remove cleartext traffic permissions and enforce HTTPS.
  - Validate backend responses to prevent injection attacks.
- **General**:
  - Regularly update dependencies to address security vulnerabilities.
  - Deploy the backend on a secure server with firewall protection.

## Dependencies
- **Flutter** (in `pubspec.yaml`):
  - `http: ^1.1.0`
  - `mobile_scanner: ^5.1.1`
  - `file_picker: ^8.0.0`
  - `wave: ^0.2.2`
  - `url_launcher: ^6.3.0`
- **Python** (in `requirements.txt`):
  - `flask==3.0.0`
  - `requests==2.32.3`
  - `numpy==1.26.4`
  - `scikit-learn==1.5.1`

## Troubleshooting
- **Backend Not Reachable**:
  - Verify the Flask server is running (`http://127.0.0.1:5000`).
  - Check `_baseUrl` in `url_checker_service.dart` matches the testing environment.
  - Ensure the device/emulator and backend machine are on the same network for physical device testing.
- **Flutter Errors**:
  - Run `flutter doctor` to check for issues.
  - Ensure all dependencies are installed (`flutter pub get`).
- **Debugging**:
  - Check Flask server logs for incoming requests.
  - Add `print(response.body)` in `url_checker_service.dart` to inspect backend responses.

## Notes
- The backend uses a mock ML model and simulated API responses for development. For production, replace `GOOGLE_SAFE_BROWSING_KEY` and `VIRUSTOTAL_KEY` in `backend.py` with valid API keys.
- The app is designed for educational purposes, with security features suitable for a prototype. Production deployment requires additional hardening.

## Contact
For questions or issues, please contact [Your Name] at [Your Email].

---

*Last Updated: May 16, 2025*
