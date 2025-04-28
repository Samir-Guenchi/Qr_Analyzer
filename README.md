# Qr_Analyzer
**Protect yourself before you scan!**  
_A Flutter app that classifies QR codes as malicious or safe using Machine Learning models and heuristic analysis._

## 📱 Features

- 📷 Scan QR codes easily.
- 🧠 Classify scanned QR codes using a trained ML model.
- 🧩 Enhance classification with a custom heuristic function.
- 🛡️ Warn users about potentially dangerous QR codes.
- 🌙 Simple, clean, and intuitive interface.


## 🚀 Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/qr-shield.git
   cd qr-shield
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:

   ```bash
   flutter run
   ```

---

## 🧠 How It Works

- The app captures the content of the QR code (usually a URL).
- It passes the content through:
  - A **Machine Learning model** trained to recognize patterns of malicious links.
  - A **heuristic function** that checks for common suspicious indicators like:
    - Shortened URLs
    - Presence of IP addresses instead of domains
    - Suspicious keywords (e.g., "free", "win", "urgent")
    - Non-HTTPS links
- Based on the combined results, the app classifies the QR code as:
  - ✅ Safe
  - ⚠️ Suspicious
  - ❌ Malicious

---

## 🛠️ Tech Stack

- **Flutter** (Dart)
- **TensorFlow Lite** (for ML model inference)
- **QR Code Scanner Plugin** (`qr_code_scanner`)
- **Custom heuristic algorithm**

---


## ⚡ Future Improvements

- Online database check for known malicious URLs.
- User history log.
- Dark Mode.
- Real-time protection for links outside QR scanning.

---

## 🤝 Contributing

Contributions are welcome!  
Please open an issue first to discuss what you would like to change.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 📢 Disclaimer

This app provides a **first layer of protection**.  
It **cannot guarantee 100% safety**.  
Always stay cautious when scanning and visiting unknown links!
Or maybe a template for the **heuristic function** inside the `heuristic_service.dart`? 📦
