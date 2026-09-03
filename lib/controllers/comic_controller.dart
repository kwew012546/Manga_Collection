import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:manga_library/models/comic_model.dart';

class ComicController extends GetxController {
  var comicList = <Comic>[].obs;
  var recentlyOpened = <Comic>[].obs;
  final box = GetStorage();

  // Search & Filter State
  var searchQuery = "".obs;
  var filterIndex = 0.obs; // 0: ทั้งหมด, 1: สะสมไม่ครบ, 2: สะสมครบแล้ว

  @override
  void onInit() {
    super.onInit();
    
    // Safety Try-Catch for reading comics list
    try {
      List? storedComics = box.read<List>('comics');
      if (storedComics != null) {
        comicList.assignAll(storedComics.map((e) => Comic.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error loading stored comics list: $e");
      // If data is corrupted, clear it to prevent continuous crashes
      box.remove('comics');
    }

    // Safety Try-Catch for reading recently opened IDs
    try {
      List? storedRecentIds = box.read<List>('recent_ids');
      if (storedRecentIds != null) {
        for (var id in storedRecentIds) {
          var found = comicList.firstWhereOrNull((c) => c.id == id);
          if (found != null) recentlyOpened.add(found);
        }
      }
    } catch (e) {
      print("Error loading stored recent list: $e");
      box.remove('recent_ids');
    }

    ever(comicList, (_) => _saveToDisk());
    ever(recentlyOpened, (_) => _saveRecentToDisk());
  }

  void _saveToDisk() {
    try {
      box.write('comics', comicList.map((e) => e.toJson()).toList());
    } catch (e) {
      print("Error saving comics list to disk: $e");
    }
  }

  void _saveRecentToDisk() {
    try {
      box.write('recent_ids', recentlyOpened.map((e) => e.id).toList());
    } catch (e) {
      print("Error saving recent IDs to disk: $e");
    }
  }

  // Collection Statistics Getters
  int get totalComics => comicList.length;
  int get totalVolumes => comicList.fold(0, (sum, c) => sum + c.volumes.length);
  int get totalOwnedVolumes => comicList.fold(0, (sum, c) => sum + c.volumes.where((v) => v.isOwned).length);
  double get completionPercentage => totalVolumes == 0 ? 0.0 : (totalOwnedVolumes / totalVolumes) * 100;

  // Getter for filtered comics
  List<Comic> get filteredComics {
    return comicList.where((comic) {
      final matchesSearch = comic.title.toLowerCase().contains(searchQuery.value.toLowerCase());
      if (!matchesSearch) return false;

      if (filterIndex.value == 1) {
        // สะสมไม่ครบ (มีอย่างน้อย 1 เล่มที่ยังไม่มี)
        return comic.volumes.any((v) => !v.isOwned);
      } else if (filterIndex.value == 2) {
        // สะสมครบแล้ว (มีอย่างน้อย 1 เล่ม และมีครบทุกเล่ม)
        return comic.volumes.isNotEmpty && comic.volumes.every((v) => v.isOwned);
      }
      return true; // ทั้งหมด
    }).toList();
  }

  // Copy cover image permanently to app documents directory
  Future<String> _saveImagePermanently(String tempPath, String comicId) async {
    if (tempPath.isEmpty) return "";
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileExt = tempPath.contains('.') ? tempPath.split('.').last : 'jpg';
      final permanentFile = File('${appDir.path}/cover_${comicId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt');
      await File(tempPath).copy(permanentFile.path);
      return permanentFile.path;
    } catch (e) {
      print("Error saving permanent image: $e");
      return tempPath; // fallback to original path if copy fails
    }
  }

  Future<void> addComic(String title, int volCount, String imagePath, String note) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    String permanentPath = imagePath;
    if (imagePath.isNotEmpty) {
      permanentPath = await _saveImagePermanently(imagePath, id);
    }

    comicList.add(Comic.create(
      id: id,
      title: title,
      totalVol: volCount,
      coverPath: permanentPath,
      note: note,
    ));
  }

  void deleteComic(String id) {
    comicList.removeWhere((c) => c.id == id);
    recentlyOpened.removeWhere((c) => c.id == id);
  }

  void addToRecent(Comic comic) {
    recentlyOpened.removeWhere((item) => item.id == comic.id);
    recentlyOpened.insert(0, comic);
    if (recentlyOpened.length > 8) recentlyOpened.removeLast();
    _saveRecentToDisk();
  }

  void addVolume(Comic comic) {
    comic.volumes.add(Volume(number: comic.volumes.length + 1, isOwned: true));
    _saveToDisk();
    comicList.refresh();
    recentlyOpened.refresh();
  }

  void removeVolume(Comic comic) {
    if (comic.volumes.isNotEmpty) {
      comic.volumes.removeLast();
      _saveToDisk();
      comicList.refresh();
      recentlyOpened.refresh();
    }
  }

  // Unified Total Volumes Setter (Add or Remove arbitrary volume count)
  void setTotalVolumes(Comic comic, int targetCount) {
    if (targetCount <= 0 || targetCount == comic.volumes.length) return;

    if (targetCount > comic.volumes.length) {
      int currentLength = comic.volumes.length;
      int toAdd = targetCount - currentLength;
      for (int i = 1; i <= toAdd; i++) {
        comic.volumes.add(Volume(number: currentLength + i, isOwned: true));
      }
    } else {
      comic.volumes.removeRange(targetCount, comic.volumes.length);
    }

    _saveToDisk();
    comicList.refresh();
    recentlyOpened.refresh();
  }

  void toggleVolumeOwned(Comic comic, Volume volume, bool isOwned) {
    volume.isOwned = isOwned;
    _saveToDisk();
    comicList.refresh();
    recentlyOpened.refresh();
  }

  // Bulk Actions for ownership
  void setAllVolumesOwned(Comic comic, bool isOwned) {
    for (var v in comic.volumes) {
      v.isOwned = isOwned;
    }
    _saveToDisk();
    comicList.refresh();
    recentlyOpened.refresh();
  }

  void addMultipleVolumes(Comic comic, int countToAdd) {
    if (countToAdd <= 0) return;
    int currentLength = comic.volumes.length;
    for (int i = 1; i <= countToAdd; i++) {
      comic.volumes.add(Volume(number: currentLength + i, isOwned: true));
    }
    _saveToDisk();
    comicList.refresh();
    recentlyOpened.refresh();
  }

  void updateComicDetails(Comic comic, String title, String note) {
    comic.title = title;
    comic.note = note;
    _saveToDisk();
    comicList.refresh();
    recentlyOpened.refresh();
  }

  Future<void> updateCoverImage(Comic comic) async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img != null) {
        final permanentPath = await _saveImagePermanently(img.path, comic.id);
        comic.coverPath = permanentPath;
        _saveToDisk();
        comicList.refresh();
        recentlyOpened.refresh();
      }
    } catch (e) {
      print("Error picking cover image: $e");
    }
  }
}