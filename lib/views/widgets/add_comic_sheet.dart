import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/comic_controller.dart';

int _parseVolumes(String input) {
  final nums = RegExp(r'\d+').allMatches(input).map((m) => int.tryParse(m.group(0)!) ?? 1).toList();
  if (nums.length >= 2) return (nums[1] - nums[0]).abs() + 1;
  return nums.isNotEmpty ? nums.first : 1;
}

void showAddComicSheet(BuildContext context) {
  final controller = Get.find<ComicController>();
  String name = "";
  String volInput = "";
  String note = "";
  var path = "".obs;

  Get.bottomSheet(
    isScrollControlled: true,
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
              GestureDetector(
                onTap: () async {
                  final img = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (img != null) path.value = img.path;
                },
                child: Obx(() => Container(
                  height: 140, width: 100,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[900]!)),
                  child: path.value.isEmpty 
                      ? Icon(Icons.add_a_photo, color: Colors.grey) 
                      : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(path.value), fit: BoxFit.cover)),
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
                    final finalVols = _parseVolumes(volInput);
                    controller.addComic(name.trim(), finalVols, path.value, note.trim());
                    Get.back();
                  }
                },
                child: Text("ยืนยันเพิ่มเข้าคลังหนังสือ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}