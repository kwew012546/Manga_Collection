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
        title: Text(
          "MANGA COLLECTION",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddComicSheet(context),
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 800),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Dashboard Card
                Obx(() => _buildStatisticsCard()),
                SizedBox(height: 24),

                // Recently Read Header
                Text(
                  "RECENTLY READ",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 12),

                // Recently Read List or Empty State
                Obx(() {
                  if (controller.recentlyOpened.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        color: Color(0xFF141414),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[900]!),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history, size: 48, color: Colors.grey[800]),
                          SizedBox(height: 8),
                          Text("ยังไม่มีประวัติการอ่าน", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.recentlyOpened.length,
                    separatorBuilder: (context, index) => Divider(color: Colors.grey[900], height: 24, thickness: 1),
                    itemBuilder: (context, index) {
                      var comic = controller.recentlyOpened[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          controller.addToRecent(comic);
                          Get.to(() => DetailScreen(comic: comic));
                        },
                        child: Row(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Hero(
                              tag: 'cover_${comic.id}',
                              child: comic.coverPath.isEmpty
                                  ? Container(width: 60, height: 90, color: Color(0xFF1A1A1A), child: Icon(Icons.book, color: Colors.grey))
                                  : Image.file(
                                      File(comic.coverPath),
                                      width: 60,
                                      height: 90,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        width: 60,
                                        height: 90,
                                        color: Color(0xFF1A1A1A),
                                        child: Icon(Icons.broken_image, color: Colors.grey[700], size: 24),
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(comic.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 6),
                            Builder(builder: (context) {
                              int owned = comic.volumes.where((v) => v.isOwned).length;
                              return Text("สะสมแล้ว $owned จาก ${comic.volumes.length} เล่ม", style: TextStyle(color: Colors.redAccent, fontSize: 13));
                            }),
                            SizedBox(height: 4),
                            Text(comic.note.isEmpty ? "ไม่มีหมายเหตุ" : comic.note, style: TextStyle(color: Colors.grey, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ])),
                          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[800]),
                        ]),
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final totalComics = controller.totalComics;
    final totalOwned = controller.totalOwnedVolumes;
    final totalVols = controller.totalVolumes;
    final pct = controller.completionPercentage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[850]!),
        gradient: LinearGradient(
          colors: [Color(0xFF241111), Color(0xFF181818)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart_outline, color: Colors.red, size: 20),
              SizedBox(width: 8),
              Text(
                "COLLECTION STATS",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.1,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                ),
                child: Text(
                  "${pct.toStringAsFixed(1)}%",
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("มังงะทั้งหมด", "$totalComics", "เรื่อง"),
              Container(width: 1, height: 32, color: Colors.grey[800]),
              _buildStatItem("สะสมแล้ว", "$totalOwned / $totalVols", "เล่ม"),
            ],
          ),
          SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: totalVols == 0 ? 0.0 : (totalOwned / totalVols),
              backgroundColor: Colors.grey[900],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(width: 4),
            Text(unit, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ],
    );
  }
}