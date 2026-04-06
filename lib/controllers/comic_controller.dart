import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manga_library/models/comic_model.dart';

class ComicController extends GetxController {
  var comicList = <Comic>[].obs;
  var recentlyOpened = <Comic>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    List? storedComics = box.read<List>('comics');
    if (storedComics != null) {
      comicList.assignAll(storedComics.map((e) => Comic.fromJson(e)).toList());
    }

    List? storedRecentIds = box.read<List>('recent_ids');
    if (storedRecentIds != null) {
      for (var id in storedRecentIds) {
        var found = comicList.firstWhereOrNull((c) => c.id == id);
        if (found != null) recentlyOpened.add(found);
      }
    }

    ever(comicList, (_) => _saveToDisk());
    ever(recentlyOpened, (_) => _saveRecentToDisk());
  }

  void _saveToDisk() => box.write('comics', comicList.map((e) => e.toJson()).toList());
  void _saveRecentToDisk() => box.write('recent_ids', recentlyOpened.map((e) => e.id).toList());

  void addComic(String title, int volCount, String imagePath, String note) {
    comicList.add(Comic(id: DateTime.now().toString(), title: title, totalVol: volCount, coverPath: imagePath, note: note));
  }

  void deleteComic(String id) {
    comicList.removeWhere((c) => c.id == id);
    recentlyOpened.removeWhere((c) => c.id == id);
    Get.back();
  }

  void addToRecent(Comic comic) {
    recentlyOpened.removeWhere((item) => item.id == comic.id);
    recentlyOpened.insert(0, comic);
    if (recentlyOpened.length > 8) recentlyOpened.removeLast();
    _saveRecentToDisk();
  }

  void addVolume(Comic comic) {
    comic.volumes.add(Volume(number: comic.volumes.length + 1, owned: true));
    _saveToDisk();
  }

  void removeVolume(Comic comic) {
    if (comic.volumes.isNotEmpty) {
      comic.volumes.removeLast();
      _saveToDisk();
    }
  }

  Future<void> updateCoverImage(Comic comic) async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      comic.coverPath.value = img.path;
      _saveToDisk();
      comicList.refresh();
    }
  }
}