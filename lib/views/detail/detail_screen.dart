import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comic_controller.dart';
import '../../models/comic_model.dart';

class DetailScreen extends StatelessWidget {
  final Comic comic;
  final controller = Get.find<ComicController>();

  DetailScreen({required this.comic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red), 
            onPressed: () => controller.deleteComic(comic.id)
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        double imgWidth = constraints.maxWidth * 0.45;
        return SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () => controller.updateCoverImage(comic),
                child: Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: comic.coverPath.value.isEmpty 
                    ? Container(width: imgWidth, height: imgWidth * 1.5, color: Color(0xFF1A1A1A), child: Icon(Icons.add_a_photo))
                    : Image.file(File(comic.coverPath.value), width: imgWidth, fit: BoxFit.cover),
                )),
              ),
              SizedBox(width: 20),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Obx(() => Text(comic.title.value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                SizedBox(height: 10),
                Obx(() => Text(comic.note.value, style: TextStyle(color: Colors.grey, fontSize: 14))),
                Row(children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.red), 
                    onPressed: () => controller.removeVolume(comic)
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.green), 
                    onPressed: () => controller.addVolume(comic)
                  ),
                ]),
              ])),
            ]),
            SizedBox(height: 30),
            Text("VOLUMES CHECKLIST", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            SizedBox(height: 15),
            Obx(() => Wrap(
              spacing: 8, 
              runSpacing: 12,
              children: comic.volumes.map((vol) => SizedBox(
                width: (constraints.maxWidth - 60) / 3.5, 
                child: Obx(() => ChoiceChip(
                  padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                  label: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text("${vol.number}", style: TextStyle(fontSize: 14)),
                  ),
                  selected: vol.isOwned.value,
                  onSelected: (val) {
                    vol.isOwned.value = val;
                    // บันทึกสถานะทันทีเมื่อมีการติ๊ก
                    controller.box.write('comics', controller.comicList.map((e) => e.toJson()).toList());
                  },
                  selectedColor: Colors.red,
                  backgroundColor: Color(0xFF1A1A1A),
                  showCheckmark: false, 
                  labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                )),
              )).toList(),
            )),
          ]),
        );
      }),
    );
  }
}