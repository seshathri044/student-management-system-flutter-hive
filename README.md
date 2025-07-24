# 🎓 Student Management System (Flutter + Hive DB)

A beautiful and responsive **Flutter** application to manage student records by class. This app allows users to select a class (10th, 11th, 12th), view, add, edit, and delete student records using **Hive DB** for local data persistence. Designed with modular and scalable code for mobile and web platforms.


## ✨ Features

✅ Modern welcome and class selection screens  
✅ Create, Read, Update, Delete (CRUD) students  
✅ Persistent storage using **Hive DB**  
✅ Class-wise separation of students (10th, 11th, 12th)  
✅ Beautiful responsive UI  
✅ Compatible with Flutter web and mobile  
✅ Modular and maintainable code

---

## 📷 Screenshots
 **Welcome Page**
<img width="1920" height="1080" alt="SMD1" src="https://github.com/user-attachments/assets/4193ec14-80bb-4ddb-920d-5db32dc374b5" />
 **Class Selection Page**
<img width="1920" height="1080" alt="SMD2" src="https://github.com/user-attachments/assets/16b2dae3-1665-4040-b37b-43c51644f23f" />
**Class 10th(No Records)**
<img width="1920" height="1080" alt="SMD3" src="https://github.com/user-attachments/assets/788aa0d2-16d7-47fb-963c-0095b8f08fcd" />
**Class 10th(With Records)**
<img width="1920" height="1080" alt="SMD4" src="https://github.com/user-attachments/assets/33250217-4a24-4d94-a115-771c1cd923a8" />
**Class 12th(Adding the new Detials)**
<img width="1920" height="1080" alt="SMD5" src="https://github.com/user-attachments/assets/263bfb6b-a64f-48d2-ae79-11fd7cbb2eea" />
**Class 12th(Added Records)**
<img width="1920" height="1080" alt="SMD6" src="https://github.com/user-attachments/assets/59a29d59-4d9d-4e37-adf6-fd67b2cfcd17" />

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
###  🗂 Project Structure
```bash
lib/
├── main.dart                    # Entry point
├── welcome_page.dart            # Welcome screen UI
├── class_selection_page.dart    # Class card selection screen
├── student_management_page.dart # Placeholder for class management screen
 ```




