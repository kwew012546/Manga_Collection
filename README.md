# 📚 Manga Collection App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/State_Management-GetX-8A2BE2?style=for-the-badge)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20Web-blue?style=for-the-badge)

**แอปพลิเคชันจัดการและติดตามการสะสมมังงะส่วนตัว (Personal Manga Collection Tracker)**  
ช่วยให้นักสะสมบันทึก เช็กเล่มที่ขาด ค้นหา และดูสถิติความสมบูรณ์ของคลังมังงะได้อย่างสะดวก รวดเร็ว และสวยงาม

[ฟีเจอร์เด่น](#-ฟีเจอร์หลัก-key-features) • [โครงสร้างโปรเจกต์](#-โครงสร้างโปรเจกต์-architecture) • [การติดตั้งและรัน](#-การติดตั้งและเริ่มต้นใช้งาน-getting-started) • [การทดสอบ](#-การทดสอบระบบ-testing)

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
│       └── add_comic_sheet.dart# Bottom sheet สำหรับเพิ่มมังงะใหม่
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

### 3. รันแอปพลิเคชัน
```bash
# รันบนอุปกรณ์ที่เชื่อมต่อ (เช่น Windows, Android, iOS)
flutter run
```

---

## 📦 การสร้างไฟล์สำหรับติดตั้ง (Building)

### 🤖 Android (APK):
```bash
flutter build apk --release
```
*ไฟล์ติดตั้งจะอยู่ที่:* `build/app/outputs/flutter-apk/app-release.apk`

### 🍎 iOS:
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
