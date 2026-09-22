# 📚 Manga Collection App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/State_Management-GetX-8A2BE2?style=for-the-badge)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20Web-blue?style=for-the-badge)

**แอปพลิเคชันจัดการและติดตามการสะสมมังงะส่วนตัว (Personal Manga Collection Tracker)**  
ช่วยให้นักสะสมบันทึก เช็กเล่มที่ขาด ค้นหา และดูสถิติความสมบูรณ์ของคลังมังงะได้อย่างสะดวก รวดเร็ว และสวยงาม

[ฟีเจอร์เด่น](#-ฟีเจอร์หลัก-key-features) • [โครงสร้างโปรเจกต์](#-โครงสร้างโปรเจกต์-project-architecture) • [การติดตั้งและรัน](#-การติดตั้งและเริ่มต้นใช้งาน-getting-started) • [การสร้างไฟล์ติดตั้ง](#-การสร้างไฟล์สำหรับติดตั้งบนอุปกรณ์-building--installing) • [การทดสอบ](#-การทดสอบระบบ-testing)

</div>

---

## ✨ ฟีเจอร์หลัก (Key Features)

### 📊 1. แดชบอร์ดสรุปสถิติคลัง (Collection Statistics Dashboard)
* **สรุปภาพรวมแบบ Real-time:** แสดงจำนวนเรื่องทั้งหมดในคลัง, จำนวนเล่มที่ครอบครองเทียบกับจำนวนเล่มทั้งหมด
* **เปอร์เซ็นต์ความสมบูรณ์:** มีแถบสถานะ (Progress Bar) และ Badge แสดงอัตราสะสมสำเร็จของคลังหนังสือ

### 🔍 2. ระบบค้นหาและตัวกรองอัจฉริยะ (Search & Filter Chips)
* **Search Bar:** ค้นหาชื่อเรื่องได้อย่างรวดเร็ว
* **Filter Chips:** คัดกรองมังงะออกเป็น 3 หมวดหมู่:
  * **ทั้งหมด (All):** แสดงมังงะทั้งหมดในคลัง
  * **สะสมไม่ครบ (Incomplete):** แสดงเฉพาะเรื่องที่มีเล่มขาด เพื่อความสะดวกเวลาไปซื้อหนังสือ
  * **สะสมครบแล้ว (Completed):** แสดงเรื่องที่สะสมครบทุกเล่มแล้ว

### 🎛️ 3. กล่องควบคุมเล่มแบบรวมศูนย์ (Unified Volume Management)
* **Inline Stepper `[-] [ X เล่ม ✏️ ] [+]`:** ปรับเพิ่มหรือลดทีละ 1 เล่มได้ทันที
* **Direct Total Setter:** แตะที่ตัวเลขเพื่อพิมพ์จำนวนเล่มใหม่ได้ตามต้องการ
  * **Dynamic Disabled Button:** ปุ่มยืนยันจะเปิดใช้งานเฉพาะเมื่อกรอกตัวเลขที่ถูกต้องและต่างจากเดิม
  * **Safety Warning:** แสดงข้อความเตือนเมื่อมีการลดจำนวนเล่ม ป้องกันการลบเล่มโดยไม่ได้ตั้งใจ
* **Bulk Actions:** ปุ่ม *"เลือกทั้งหมด"* และ *"ยกเลิกทั้งหมด"* สำหรับมังงะที่ซื้อมายกเซ็ต

### ⏱️ 4. เมนูด่วนในหน้าคลัง (Long-Press Quick Action)
* **แตะธรรมดา (Single Tap):** เปิดดูหน้ารายละเอียดพร้อมแอนิเมชันรูปภาพขยายตัว (Hero Transition)
* **กดค้าง (Long Press):** เปิด Action Sheet สำหรับ **แก้ไขรายละเอียด** หรือ **ลบเรื่องออกจากคลัง** ได้ทันทีโดยไม่ต้องกดเข้าหน้ารายละเอียด

### 📸 5. ระบบจัดเก็บรูปภาพถาวร (Persistent Image Storage)
* คัดลอกรูปภาพหน้าปกไปยัง Application Documents Directory ป้องกันปัญหารูปภาพหายจากการล้างแคชของระบบปฏิบัติการ

### 📱 6. รองรับทุกอุปกรณ์ (Adaptive & Responsive UI)
* ปรับเปลี่ยนรูปแบบ Navigation อัตโนมัติ: **BottomNavigationBar** สำหรับมือถือ และ **NavigationRail** สำหรับแท็บเล็ต/เดสก์ท็อป

---

## 🛠️ เทคโนโลยีที่ใช้ (Tech Stack)

* **Framework:** [Flutter](https://flutter.dev/) (SDK ^3.6.0)
* **Language:** [Dart](https://dart.dev/)
* **State Management:** [GetX](https://pub.dev/packages/get)
* **Local Database:** [GetStorage](https://pub.dev/packages/get_storage) (NoSQL Key-Value persistence)
* **File System:** [path_provider](https://pub.dev/packages/path_provider)
* **Image Picker:** [image_picker](https://pub.dev/packages/image_picker)
* **Testing:** [integration_test](https://api.flutter.dev/flutter/integration_test/integration_test-library.html)

---

## 📁 โครงสร้างโปรเจกต์ (Project Architecture)

```text
lib/
├── controllers/
│   └── comic_controller.dart   # จัดการ Business Logic, Filter, Storage, สถิติ
├── models/
│   └── comic_model.dart        # Pure Dart Data Models (Comic, Volume)
├── views/
│   ├── detail/
│   │   └── detail_screen.dart  # หน้ารายละเอียดมังงะ, Checklist, Stepper
│   ├── home/
│   │   └── home_screen.dart    # หน้าแรก, การ์ดสถิติ Dashboard, ประวัติการเปิดล่าสุด
│   ├── library/
│   │   └── library_screen.dart # หน้าคลังหนังสือ, Search, Filter, Long-press menu
│   └── widgets/
│       ├── add_comic_sheet.dart# Bottom sheet สำหรับเพิ่มมังงะใหม่
│       └── comic_dialogs.dart  # Shared Dialogs (แก้ไขรายละเอียด & ยืนยันการลบ)
└── main.dart                   # จุดเริ่มต้นแอป, การตั้งค่าธีม และ Responsive Layout
```

---

## 🚀 การติดตั้งและเริ่มต้นใช้งาน (Getting Started)

### 1. Clone Repository
```bash
git clone https://github.com/kwew012546/Manga_Collection.git
cd Manga_Collection
```

### 2. ติดตั้ง Dependencies
```bash
flutter pub get
```

### 3. ตรวจสอบอุปกรณ์ที่เชื่อมต่อ (Check Connected Devices)
```bash
flutter devices
```

### 4. คำสั่งสำหรับรันแอปพลิเคชัน (Running the App)

* 🤖 **สำหรับระบบ Android (โทรศัพท์มือถือ หรือ Android Emulator):**
  ```bash
  # รันบนอุปกรณ์ Android ที่เชื่อมต่อ
  flutter run -d android
  ```

* 🍎 **สำหรับระบบ iOS (iPhone จริง หรือ iOS Simulator บน macOS):**
  ```bash
  # รันบนอุปกรณ์ iOS ที่เชื่อมต่อ หรือ Simulator
  flutter run -d ios
  ```

* 💻 **สำหรับ Windows Desktop:**
  ```bash
  flutter run -d windows
  ```

* 🌐 **สำหรับ Web Browser:**
  ```bash
  flutter run -d chrome
  ```

---

## 📦 การสร้างไฟล์สำหรับติดตั้งบนอุปกรณ์ (Building & Installing)

### 🤖 1. สำหรับ Android (สร้างไฟล์ APK ไปติดตั้งบนมือถือได้ถาวร)

1. **คอมไพล์เป็นไฟล์ APK:**
   ```bash
   flutter build apk --release
   ```
2. **ตำแหน่งไฟล์ติดตั้ง:**
   `build/app/outputs/flutter-apk/app-release.apk`
3. **การติดตั้ง:**
   ส่งไฟล์ `app-release.apk` ไปยังโทรศัพท์ Android (ผ่าน LINE, Google Drive หรือสาย USB) แล้วกดติดตั้งได้ทันที ไม่จำเป็นต้องต่อสายกับคอมพิวเตอร์อีก

---

### 🍎 2. สำหรับ iOS (สร้างไฟล์สำหรับ iPhone / iPad)

1. **เปิดโปรเจกต์ใน Xcode (บน macOS):**
   ```bash
   open ios/Runner.xcworkspace
   ```
2. **ตั้งค่า Code Signing:**
   ไปที่แถบ **Signing & Capabilities** ใน Xcode แล้วเลือก **Development Team** ของคุณ
3. **คอมไพล์เป็นไฟล์ IPA หรือติดตั้งผ่าน Xcode:**
   ```bash
   flutter build ipa --release
   ```

---

## 🧪 การทดสอบระบบ (Testing)

โปรเจกต์นี้มีชุดทดสอบ End-to-End (E2E) Integration Tests ครอบคลุมการทำงานทุกฟังก์ชัน:

```bash
# รันการทดสอบบน Windows Desktop
flutter test integration_test/app_test.dart -d windows
```

---

## 📄 License
This project is developed for personal collection management.
