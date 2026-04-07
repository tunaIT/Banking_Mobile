<div align="center">
  <h1 align="center">Mobile Banking System</h1>
  <p align="center">
    A robust and secure mobile banking solution built with Spring Boot and Flutter.
  </p>
  
  <!-- Add badges here -->
  <p align="center">
    <img src="https://img.shields.io/badge/Spring_Boot-F2F4F9?style=for-the-badge&logo=spring-boot" alt="Spring Boot" />
    <img src="https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white" alt="Java" />
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/MySQL-00000F?style=for-the-badge&logo=mysql&logoColor=white" alt="MySQL" />
  </p>
</div>

---

## 📖 Overview

The **Mobile Banking System** is a full-stack application designed to provide users with a seamless and secure digital banking experience. The project emphasizes clean architecture, scalability, and modern UI/UX design.

### 🌟 Key Features
- **User Authentication**: Secure login and registration with JWT.
- **Account Management**: View balances, transaction history, and account details.
- **Transfers & Payments**: Real-time internal and external funds transfer.
- **Push Notifications**: Instant alerts for account activity.
- **Security**: Data encryption and secure API endpoints.

<br/>
<div align="center">
  <img src="https://sf-static.upanhlaylink.com/img/image_20260407eb117c9c922cbdc956159eb506badf74.jpg" width="200" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://sf-static.upanhlaylink.com/img/image_20260407bcf82c828655deb97d5f7e6c452f3c85.jpg" width="200" />
</div>
<br/>

## 🏗️ Architecture & Tech Stack

### Backend (`/be`)
- **Framework**: Spring Boot (Java)
- **Database**: MySQL (or specify your DB)
- **Security**: Spring Security + JWT Authentication
- **Architecture**: Domain-Driven Design / MVC Pattern (Adjust to your actual architecture)

### Frontend (`/fe`)
- **Framework**: Flutter / Dart
- **State Management**: Provider / BLoC / GetX (Adjust to your actual stack)
- **Networking**: Dio / Http

## 📂 Project Structure

```bash
Banking_Mobile/
├── be/                 # Backend API services
├── fe/                 # Flutter mobile application
├── scripDB/            # Database schema & seed data SQL scripts
└── README.md           # Project documentation
```

## 🚀 Getting Started

### Prerequisites
- [Java Development Kit (JDK) 11+](https://www.oracle.com/java/technologies/javase-downloads.html)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [MySQL/PostgreSQL Database](https://www.mysql.com/)

### 1. Database Setup
Execute the scripts in the `scripDB/` directory in your local database server to create the necessary schemas and seed data.

### 2. Backend Setup
Configure your database credentials in `be/src/main/resources/application.properties` (or `.yml`).

```bash
cd be
# Windows:
mvnw.cmd spring-boot:run
# macOS/Linux:
./mvnw spring-boot:run
```

### 3. Frontend Setup
Make sure you have an emulator running or a device connected.

```bash
cd fe
flutter pub get
flutter run
```

## 🧠 Technical Challenges Solved
*(To impress recruiters, list 1-2 difficult technical problems you solved in this project. E.g.,)*
- **Concurrency in Transactions**: Implemented pessimistic locking in the database to prevent double spending during simultaneous transfer requests.
- **State Management**: Optimized Flutter widget rebuilds by carefully managing application state, resulting in a smooth 60fps experience.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
