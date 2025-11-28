# ⚡️ Vision AI - Smart Image Analysis Application

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Gemini AI](https://img.shields.io/badge/Google%20Gemini%202.0-8E75B2?style=for-the-badge&logo=googlebard&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-%232D3748.svg?style=for-the-badge&logo=riverpod&logoColor=white)

**Vision AI** is a modern Flutter application designed for scalable and secure image analysis, leveraging the power of **Google Gemini 2.0 Flash** and modern architectural patterns.

---

## 📱 Screenshots 


<img width="170" height="320" alt="Image" src="https://github.com/user-attachments/assets/7341ffa3-8ac6-48a3-bee0-17a863c9f4bc" />

<img width="170" height="320" alt="Image" src="https://github.com/user-attachments/assets/b02666f8-fdb3-4644-8f02-8262a1bcf905" />

<img width="170" height="320" alt="Image" src="https://github.com/user-attachments/assets/8bb73cb4-5d59-416a-9638-62df5d944b81" />


---

## ✨ Features Highlight

* **🧠 Advanced AI:** Integration with **Gemini 2.0 Flash** for high-speed, multimodal visual processing.
* **🏗️ Clean Architecture:** Structured with dedicated Service and Repository layers using **Riverpod** for state management.
* **🔐 Secure Auth:** Full user authentication flow using **Firebase Authentication**.
* **🛡️ Security:** Critical API keys are securely handled via `.gitignore`.

---

## 🚀 Getting Started

### 1. Prerequisites (Key Setup) 🔒
1. Obtain a Gemini API Key from [Google AI Studio](https://aistudio.google.com/app/apikey).
2. In the `lib` folder, create a file named **`secret_key.dart`** and add your key: `const String mySecretApiKey = 'YOUR_KEY';`
3. Link Firebase using `flutterfire configure`.

### 2. Run the Application
```bash
flutter pub get
flutter run