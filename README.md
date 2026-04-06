# 📚 Manga Collection App

แอปพลิเคชันสำหรับนักสะสมมังงะ ช่วยให้คุณบันทึกและจัดการจำนวนเล่มมังงะในคอลเลกชันส่วนตัวได้อย่างง่ายดาย ไม่ต้องกลัวว่าจะซื้อซ้ำหรือจำไม่ได้ว่าอ่านถึงเล่มไหนแล้ว!

## ✨ Features

- **Personal Collection Management:** เพิ่มมังงะเข้าลิสต์ส่วนตัว พร้อมใส่ชื่อเรื่องและรูปภาพหน้าปก
- **Volume Tracking:** ระบบบันทึกจำนวนเล่ม (เช่น มีทั้งหมดกี่เล่ม / เราสะสมไปแล้วกี่เล่ม) 
- **Flexible Input:** รองรับการกรอกข้อมูลแบบช่วง (เช่น 1-50) เพื่อความรวดเร็ว
- **Clean Architecture:** พัฒนาด้วยโครงสร้างแบบ **MVC Pattern** ทำให้โค้ดเป็นระเบียบและจัดการง่าย
- **State Management:** ใช้ **GetX** ในการจัดการข้อมูลและสถานะของแอป
- **Local Persistence:** บันทึกข้อมูลลงในเครื่องด้วย **GetStorage** ข้อมูลไม่หายแม้ปิดแอป
- **Responsive UI:** ออกแบบหน้าจอให้สวยงาม รองรับการแสดงผลทั้งบน Mobile และ Web (Tested on Realme GT Neo 2)

## 🛠 Tech Stack

- **Framework:** [Flutter](https://flutter.dev/)
- **Language:** Dart
- **State Management:** [GetX](https://pub.dev/packages/get)
- **Local Database:** [GetStorage](https://pub.dev/packages/get_storage)

## 🚀 Getting Started

หากต้องการรันโปรเจกต์นี้ในเครื่องของคุณ ให้ทำตามขั้นตอนดังนี้:

1. **Clone the repository**
   ```bash
   git clone [https://github.com/kwew012546/Manga_Collection.git](https://github.com/kwew012546/Manga_Collection.git)

2. **Install dependencies**
   flutter pub get

3. **Run app**
   flutter run
