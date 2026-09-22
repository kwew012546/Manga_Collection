import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/comic_controller.dart';
import '../../models/comic_model.dart';

class DetailScreen extends StatelessWidget {
  final Comic comic;
  final controller = Get.find<ComicController>();

  DetailScreen({required this.comic});

  void _confirmDelete(BuildContext context, Comic comic) {
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
              Get.back(); // exit DetailScreen
            },
            child: Text("ลบรายการ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showSetTotalVolumesDialog(BuildContext context, Comic comic) {
    final currentCount = comic.volumes.length;
    final textController = TextEditingController(text: "$currentCount");
    int targetCount = currentCount;
    final isConfirmEnabled = false.obs;
    final warningText = "".obs;

    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "กำหนดจำนวนเล่มทั้งหมด",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ระบุจำนวนเล่มทั้งหมดที่ต้องการ (ปัจจุบันมี $currentCount เล่ม):",
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
            SizedBox(height: 14),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: InputDecoration(
                labelText: "จำนวนเล่มทั้งหมด",
                suffixText: "เล่ม",
                filled: true,
                fillColor: Color(0xFF141414),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              onChanged: (val) {
                final parsed = int.tryParse(val.trim());
                if (parsed != null && parsed > 0 && parsed != currentCount) {
                  targetCount = parsed;
                  isConfirmEnabled.value = true;
                  if (targetCount < currentCount) {
                    final diff = currentCount - targetCount;
                    warningText.value = "⚠️ จะตัดเล่มที่ ${targetCount + 1} - $currentCount (รวม $diff เล่ม) ออกจากคลัง";
                  } else {
                    final diff = targetCount - currentCount;
                    warningText.value = "✨ จะเพิ่มเล่มที่ ${currentCount + 1} - $targetCount (เพิ่ม $diff เล่ม) เข้าคลัง";
                  }
                } else {
                  targetCount = parsed ?? 0;
                  isConfirmEnabled.value = false;
                  warningText.value = "";
                }
              },
            ),
            Obx(() {
              if (warningText.value.isEmpty) return SizedBox.shrink();
              final isReducing = targetCount > 0 && targetCount < currentCount;
              return Container(
                margin: EdgeInsets.only(top: 12),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isReducing ? Colors.red.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isReducing ? Colors.red.withValues(alpha: 0.4) : Colors.green.withValues(alpha: 0.4)),
                ),
                child: Text(
                  warningText.value,
                  style: TextStyle(
                    color: isReducing ? Colors.redAccent : Colors.greenAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
          ),
          Obx(() {
            final isEnabled = isConfirmEnabled.value;
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled ? Colors.red : Colors.grey[800],
                disabledBackgroundColor: Colors.grey[850],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isEnabled
                  ? () {
                      isConfirmEnabled.value = false; // Disable immediately upon press
                      controller.setTotalVolumes(comic, targetCount);
                      Get.back();
                    }
                  : null,
              child: Text(
                "บันทึก",
                style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showEditDetailsSheet(BuildContext context, Comic comic) {
    String newTitle = comic.title;
    String newNote = comic.note;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        decoration: BoxDecoration(color: Color(0xFF1A1A1A), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red), 
            onPressed: () => _confirmDelete(context, comic),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: LayoutBuilder(builder: (context, constraints) {
            double chipWidth = constraints.maxWidth > 600 ? 80 : (constraints.maxWidth - 60) / 3.5;
            
            return Obx(() {
              // Find the live instance of this comic to react to list refreshes
              final liveComic = controller.comicList.firstWhereOrNull((c) => c.id == comic.id) ?? comic;
              double imgWidth = constraints.maxWidth > 500 ? 180 : constraints.maxWidth * 0.40;
              final ownedCount = liveComic.volumes.where((v) => v.isOwned).length;

              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                      onTap: () => controller.updateCoverImage(liveComic),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Hero(
                          tag: 'cover_${liveComic.id}',
                          child: liveComic.coverPath.isEmpty 
                            ? Container(width: imgWidth, height: imgWidth * 1.5, color: Color(0xFF1A1A1A), child: Icon(Icons.add_a_photo, color: Colors.grey))
                            : Image.file(
                                File(liveComic.coverPath),
                                width: imgWidth,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: imgWidth,
                                  height: imgWidth * 1.5,
                                  color: Color(0xFF1A1A1A),
                                  child: Icon(Icons.broken_image, color: Colors.grey[700]),
                                ),
                              ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        children: [
                          Expanded(child: Text(liveComic.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                          IconButton(
                            icon: Icon(Icons.edit_outlined, size: 20, color: Colors.grey),
                            onPressed: () => _showEditDetailsSheet(context, liveComic),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(liveComic.note.isEmpty ? "ไม่มีหมายเหตุ" : liveComic.note, style: TextStyle(color: Colors.grey, fontSize: 14)),
                      SizedBox(height: 14),

                      // Unified Volume Stepper & Direct Setter
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFF141414),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[850]!),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 18, color: liveComic.volumes.isNotEmpty ? Colors.redAccent : Colors.grey[700]),
                              onPressed: liveComic.volumes.isNotEmpty ? () => controller.removeVolume(liveComic) : null,
                              tooltip: "ลด 1 เล่ม",
                              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                            InkWell(
                              onTap: () => _showSetTotalVolumesDialog(context, liveComic),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Color(0xFF222222),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey[800]!),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${liveComic.volumes.length}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text("เล่ม", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                                    SizedBox(width: 4),
                                    Icon(Icons.edit, size: 12, color: Colors.grey[500]),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 18, color: Colors.greenAccent),
                              onPressed: () => controller.addVolume(liveComic),
                              tooltip: "เพิ่ม 1 เล่ม",
                              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ])),
                  ]),
                  SizedBox(height: 28),

                  // Volumes Header & Owned Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("VOLUMES CHECKLIST", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                      Text(
                        "สะสมแล้ว $ownedCount จาก ${liveComic.volumes.length} เล่ม",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Bulk Action Buttons for Ownership
                  Row(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey[800]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        icon: Icon(Icons.select_all, size: 16, color: Colors.greenAccent),
                        label: Text("เลือกทั้งหมด", style: TextStyle(fontSize: 12)),
                        onPressed: () => controller.setAllVolumesOwned(liveComic, true),
                      ),
                      SizedBox(width: 8),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.grey[800]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        icon: Icon(Icons.deselect_outlined, size: 16, color: Colors.orangeAccent),
                        label: Text("ยกเลิกทั้งหมด", style: TextStyle(fontSize: 12)),
                        onPressed: () => controller.setAllVolumesOwned(liveComic, false),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Volumes Wrap Grid
                  Wrap(
                    spacing: 8, 
                    runSpacing: 12,
                    children: liveComic.volumes.map((vol) => SizedBox(
                      width: chipWidth, 
                      child: ChoiceChip(
                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                        label: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text("${vol.number}", style: TextStyle(fontSize: 14)),
                        ),
                        selected: vol.isOwned,
                        onSelected: (val) {
                          controller.toggleVolumeOwned(liveComic, vol, val);
                        },
                        selectedColor: Colors.red,
                        backgroundColor: Color(0xFF1A1A1A),
                        showCheckmark: false, 
                        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    )).toList(),
                  ),
                ]),
              );
            });
          }),
        ),
      ),
    );
  }
}