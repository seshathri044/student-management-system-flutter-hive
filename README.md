# 🎓 Student Management System (Flutter + Hive DB)

A beautiful and responsive **Flutter** application to manage student records by class. This app allows users to select a class (10th, 11th, 12th), view, add, edit, and delete student records using **Hive DB** for local data persistence. Designed with modular and scalable code for mobile and web platforms.
###  🏗️ Architecture
 ```bash
lib/
├── core/                # Common utilities, DI container, error handling
├── data/                # Data sources + repository implementations
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/              # Business logic (entities, repositories, use cases)
│   ├── repositories/
│   └── usecases/
├── presentation/        # UI layer (pages, widgets, state management)
│   └── pages/
└── main.dart            # App entry point
 ```
### 📌 Highlights:
- Data Layer → Hive DB (local storage)
- Domain Layer → Use cases (add, update, delete, fetch students)
- Presentation Layer → Clean UI with Flutter

## ✨ Features

- ✅ Modern **welcome** and **class selection** screens  
- ✅ **CRUD (Create, Read, Update, Delete)** students  
- ✅ Persistent storage using **Hive DB**  
- ✅ Class‑wise separation of students (10th, 11th, 12th)  
- ✅ Beautiful and **responsive UI**  
- ✅ Works on **Flutter Web, Windows, and Mobile**  
- ✅ Structured with **Clean Architecture**  
- ✅ Dependency Injection (`InjectionContainer`)  
- ✅ Repository pattern for clean data access  
- ✅ **Error handling & validation** (empty fields, duplicate roll numbers, invalid age)  
- ✅ **CI/CD with GitHub Actions** (automatic tests on push/PR)  
- ✅ Ready for **unit tests** with `test/` folder  
- ✅ Extensible → Authentication, charts, CSV export in future  
---
### 📦 Hive Database  
- 🐝 Used **Hive** for lightweight local database  
- Created a **Student model** with `@HiveType` and `@HiveField`  
- Registered **adapters** during app initialization  
- Performed full **CRUD operations**:  
  - Add student  
  - View list of students  
  - Edit student details  
  - Delete student  
- Each class (**10th / 11th / 12th**) stores data in a **different Hive box**  

## 📷 Screenshots
 **Welcome Page**
<img width="1920" height="1080" alt="git0 2" src="https://github.com/user-attachments/assets/537f7218-0ae4-4cd0-b0a6-2e28424e67fd" />
 **Class Selection Page**
<img width="1920" height="1080" alt="git0" src="https://github.com/user-attachments/assets/24d58518-1461-4c41-939a-0fbe5adcd7f4" />
**Class 10th(No Records)**
<img width="1920" height="1080" alt="git1" src="https://github.com/user-attachments/assets/84262fe5-4b3a-4ef1-93a0-39f43a8bcadf" />
**Class 10th(With Records)**
<img width="1920" height="1080" alt="git2" src="https://github.com/user-attachments/assets/286803b2-8f8c-4366-8606-46f4e541b38f" />
**Class 12th(Adding the new Detials)**
<img width="1920" height="1080" alt="git3" src="https://github.com/user-attachments/assets/4d404c45-191a-4b8d-aabc-99556c12714d" />
**Class 12th(Added Records)**
<img width="1920" height="1080" alt="git4" src="https://github.com/user-attachments/assets/0b81de2b-e844-44e5-97cc-da2e94f8a76c" />
**Class 12th(Update the Record)** 
<img width="1920" height="1080" alt="git5" src="https://github.com/user-attachments/assets/dc342e49-98a7-4562-8dcd-0db79397cecb" />
**Class 12th(Updated Records)**
<img width="1920" height="1080" alt="git6" src="https://github.com/user-attachments/assets/cc807e87-31c8-44aa-8b55-ac609b16cc36" />


---

### 🧰 Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Dart SDK
- Android Studio or VS Code with Flutter extension
- Chrome (for web) or Android/iOS emulator/device

### ⚙️ Installation

1. **Clone the repo**
   ```bash
   git clone https://github.com/seshathri044/student-management-system-flutter.git
   cd student-management-system-flutter
   ```
2. **Install dependencies**
 ```bash
flutter pub get
 ```
▶️ Running the App
For Web (Chrome):
 ```bash
flutter run -d chrome
 ```
For Android/iOS Emulator:
 ```bash
flutter run
 ```

### 🚀 CI/CD Setup (GitHub Actions)  
This repo includes a **workflow** that:  
- ✅ Runs `flutter test` automatically on every push/PR  
- ✅ Ensures **code quality & reliability**  
CI/CD Status:  
![Flutter CI](https://github.com/seshathri044/student-management-system-flutter-hive/actions/workflows/flutter-ci.yml/badge.svg)  

###  🗂 Project Structure
```bash
.github/
    ├── workflows/            # CI/CD workflows
lib/
    ├── core/                 # Utilities, DI, error handling
    ├──  data/                # Data layer (Hive, repositories, models)
    ├──  domain/              # Use cases, entities, repository contracts
    ├──  presentation/        # UI screens
test/                         # Unit tests
 ```

### 🤝 Contributing
Contributions are welcome!

### 📄 License
This project is licensed under the MIT License.

### 👤 Author
Seshathri
🚀 Aspiring Software Engineer | Passionate about Flutter & Java
🔗 GitHub Profile-https://github.com/seshathri044

