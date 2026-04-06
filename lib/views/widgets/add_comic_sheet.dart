import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/comic_controller.dart';

void showAddComicSheet(BuildContext context) {
  final controller = Get.find<ComicController>();
  String name = "";
  String volInput = "";
  String note = "";
  var path = "".obs;

  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (img != null) path.value = img.path;
              },
              child: Obx(() => Container(
                height: 140, width: 100,
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[900]!)),
                child: path.value.isEmpty ? Icon(Icons.add_a_photo, color: Colors.grey) : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(path.value), fit: BoxFit.cover)),
              )),
            ),
            TextField(onChanged: (v) => name = v, decoration: InputDecoration(labelText: "ชื่อเรื่อง")),
            TextField(
              onChanged: (v) => volInput = v, 
              decoration: InputDecoration(labelText: "จำนวนเล่ม", hintText: "เช่น '50' หรือ '1-50'"),
            ),
            TextField(onChanged: (v) => note = v, decoration: InputDecoration(labelText: "หมายเหตุ"), maxLines: 2),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, minimumSize: Size(double.infinity, 55)),
              onPressed: () {
                if (name.trim().isNotEmpty && volInput.trim().isNotEmpty) {
                  int finalVols = 1; 
                  try {
                    final RegExp separator = RegExp(r'[\-\+\/\*\.\,\s]+');
                    if (volInput.contains(separator)) {
                      var parts = volInput.split(separator).where((p) => p.isNotEmpty).toList();
                      if (parts.length >= 2) {
                        int start = int.parse(parts[0].replaceAll(RegExp(r'[^0-9]'), ''));
                        int end = int.parse(parts[1].replaceAll(RegExp(r'[^0-9]'), ''));
                        finalVols = (end - start).abs() + 1;
                      } else {
                        finalVols = int.parse(volInput.replaceAll(RegExp(r'[^0-9]'), ''));
                      }
                    } else {
                      finalVols = int.parse(volInput.replaceAll(RegExp(r'[^0-9]'), ''));
                    }
                  } catch (e) { finalVols = 1; }
                  controller.addComic(name, finalVols, path.value, note);
                  Get.back();
                }
              },
              child: Text("ยืนยันเพิ่มเข้าคลังหนังสือ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    ),
  );
}