import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comic_controller.dart';
import '../detail/detail_screen.dart';
import '../widgets/add_comic_sheet.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.find<ComicController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RECENTLY READ", 
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddComicSheet(context),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() => controller.recentlyOpened.isEmpty 
        ? Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey[800]), 
              SizedBox(height: 10), 
              Text("ยังไม่มีประวัติการอ่าน", style: TextStyle(color: Colors.grey))
            ]))
        : ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: controller.recentlyOpened.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey[900], height: 32, thickness: 1),
            itemBuilder: (context, index) {
              var comic = controller.recentlyOpened[index];
              return InkWell(
                onTap: () {
                  controller.addToRecent(comic);
                  Get.to(() => DetailScreen(comic: comic));
                },
                child: Row(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Obx(() => comic.coverPath.value.isEmpty 
                      ? Container(width: 60, height: 90, color: Color(0xFF1A1A1A), child: Icon(Icons.book)) 
                      : Image.file(File(comic.coverPath.value), width: 60, height: 90, fit: BoxFit.cover)),
                  ),
                  SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Obx(() => Text(comic.title.value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    SizedBox(height: 6),
                    Obx(() {
                      int owned = comic.volumes.where((v) => v.isOwned.value).length;
                      return Text("สะสมแล้ว $owned จาก ${comic.volumes.length} เล่ม", style: TextStyle(color: Colors.redAccent, fontSize: 13));
                    }),
                    SizedBox(height: 4),
                    Obx(() => Text(comic.note.value.isEmpty ? "ไม่มีหมายเหตุ" : comic.note.value, style: TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ])),
                  Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[800]),
                ]),
              );
            },
          )),
    );
  }
}