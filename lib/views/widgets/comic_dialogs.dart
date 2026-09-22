import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comic_controller.dart';
import '../../models/comic_model.dart';

/// Shared confirmation dialog for deleting a comic
void confirmDeleteComicDialog(
  BuildContext context,
  Comic comic,
  ComicController controller, {
  VoidCallback? onDeleted,
}) {
  Get.dialog(
    AlertDialog(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text("ยืนยันการลบ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      content: Text(
        "คุณแน่ใจหรือไม่ว่าต้องการลบ \"${comic.title}\" ออกจากคลังหนังสือ?",
        style: TextStyle(color: Colors.grey[300]),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            Get.back(); // close dialog
            controller.deleteComic(comic.id);
            if (onDeleted != null) {
              onDeleted();
            }
          },
          child: Text("ลบรายการ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

/// Shared bottom sheet for editing comic details (title and note)
void showEditComicDetailsSheet(
  BuildContext context,
  Comic comic,
  ComicController controller,
) {
  String newTitle = comic.title;
  String newNote = comic.note;

  Get.bottomSheet(
    Material(
      color: Color(0xFF1A1A1A),
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 20),
              Text("แก้ไขรายละเอียด", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
              SizedBox(height: 15),
              TextFormField(
                initialValue: comic.title,
                onChanged: (v) => newTitle = v,
                decoration: InputDecoration(labelText: "ชื่อเรื่อง"),
              ),
              TextFormField(
                initialValue: comic.note,
                onChanged: (v) => newNote = v,
                decoration: InputDecoration(labelText: "หมายเหตุ"),
                maxLines: 2,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(double.infinity, 55)),
                onPressed: () {
                  if (newTitle.trim().isNotEmpty) {
                    controller.updateComicDetails(comic, newTitle.trim(), newNote.trim());
                    Get.back();
                  }
                },
                child: Text("บันทึกการแก้ไข", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
