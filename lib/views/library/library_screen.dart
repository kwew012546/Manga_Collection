import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comic_controller.dart';
import '../../models/comic_model.dart';
import '../detail/detail_screen.dart';
import '../widgets/add_comic_sheet.dart';
import '../widgets/comic_dialogs.dart';

class LibraryScreen extends StatelessWidget {
  final controller = Get.find<ComicController>();

  void _showQuickActionSheet(BuildContext context, Comic comic) {
    int ownedCount = comic.volumes.where((v) => v.isOwned).length;

    Get.bottomSheet(
      Material(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 16),
              
              // Header with thumbnail and info
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: comic.coverPath.isEmpty
                        ? Container(width: 45, height: 65, color: Color(0xFF141414), child: Icon(Icons.book, color: Colors.grey))
                        : Image.file(
                            File(comic.coverPath),
                            width: 45,
                            height: 65,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 45,
                              height: 65,
                              color: Color(0xFF141414),
                              child: Icon(Icons.broken_image, color: Colors.grey[700], size: 20),
                            ),
                          ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comic.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4),
                        Text("สะสมแล้ว $ownedCount จาก ${comic.volumes.length} เล่ม", style: TextStyle(color: Colors.redAccent, fontSize: 13)),
                        if (comic.note.isNotEmpty) ...[
                          SizedBox(height: 2),
                          Text(comic.note, style: TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey[850], height: 1),
              SizedBox(height: 8),

              // Action Tiles
              ListTile(
                leading: Icon(Icons.edit_outlined, color: Colors.white),
                title: Text("แก้ไขรายละเอียด", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Get.back(); // close quick action sheet
                  showEditComicDetailsSheet(context, comic, controller);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.redAccent),
                title: Text("ลบเรื่องนี้ออกจากคลัง", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Get.back(); // close quick action sheet
                  confirmDeleteComicDialog(context, comic, controller);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "ค้นหาชื่อเรื่อง...",
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          
          // Filter Chips Row
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                _buildFilterChip("ทั้งหมด", 0),
                SizedBox(width: 8),
                _buildFilterChip("สะสมไม่ครบ", 1),
                SizedBox(width: 8),
                _buildFilterChip("สะสมครบแล้ว", 2),
              ],
            ),
          )),
          
          // Library Grid
          Expanded(
            child: Obx(() => controller.filteredComics.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.library_books, size: 64, color: Colors.grey[800]),
                        SizedBox(height: 10),
                        Text(controller.searchQuery.isEmpty ? "ยังไม่มีหนังสือในคลัง" : "ไม่พบรายการที่ค้นหา", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  )
                : Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1200),
                      child: GridView.builder(
                        padding: EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 180,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: controller.filteredComics.length,
                        itemBuilder: (context, index) {
                          var comic = controller.filteredComics[index];
                          return GestureDetector(
                            onTap: () {
                              controller.addToRecent(comic);
                              Get.to(() => DetailScreen(comic: comic));
                            },
                            onLongPress: () => _showQuickActionSheet(context, comic),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Hero(
                                      tag: 'cover_${comic.id}',
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF1A1A1A),
                                        ),
                                        child: comic.coverPath.isEmpty
                                            ? Icon(Icons.image, color: Colors.grey[700], size: 40)
                                            : Image.file(
                                                File(comic.coverPath),
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                errorBuilder: (context, error, stackTrace) => Container(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  color: Color(0xFF1A1A1A),
                                                  child: Icon(Icons.broken_image, color: Colors.grey[700], size: 40),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(4, 8, 4, 0),
                                  child: Text(
                                    comic.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = controller.filterIndex.value == index;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) controller.filterIndex.value = index;
      },
      selectedColor: Colors.red,
      backgroundColor: Color(0xFF1A1A1A),
      showCheckmark: false,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}