import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comic_controller.dart';
import '../detail/detail_screen.dart';
import '../widgets/add_comic_sheet.dart';

class LibraryScreen extends StatelessWidget {
  final controller = Get.find<ComicController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "MY COLLECTION",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddComicSheet(context),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() => controller.comicList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 64, color: Colors.grey[800]),
                  SizedBox(height: 10),
                  Text("ยังไม่มีหนังสือในคลัง", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180, // กำหนดความกว้างสูงสุดของแต่ละไอเทม
                childAspectRatio: 0.68, // ปรับจาก 0.62 เป็น 0.68 เพื่อให้ภาพกว้างขึ้น ไม่ผอม
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.comicList.length,
              itemBuilder: (context, index) {
                var comic = controller.comicList[index];
                return GestureDetector(
                  onTap: () {
                    controller.addToRecent(comic);
                    Get.to(() => DetailScreen(comic: comic));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFF1A1A1A),
                            ),
                            child: Obx(() => comic.coverPath.value.isEmpty
                                ? Icon(Icons.image, color: Colors.grey[700], size: 40)
                                : Image.file(
                                    File(comic.coverPath.value),
                                    fit: BoxFit.cover, // บังคับให้ภาพเต็มพื้นที่โดยไม่เสียสัดส่วน
                                    width: double.infinity,
                                    height: double.infinity,
                                  )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(4, 8, 4, 0),
                        child: Obx(() => Text(
                              comic.title.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ),
                    ],
                  ),
                );
              },
            )),
    );
  }
}