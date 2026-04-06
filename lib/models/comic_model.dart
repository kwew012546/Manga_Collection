import 'package:get/get.dart';

class Volume {
  int number;
  var isOwned = false.obs;
  Volume({required this.number, bool owned = false}) {
    isOwned.value = owned;
  }
  Map<String, dynamic> toJson() => {'number': number, 'isOwned': isOwned.value};
}

class Comic {
  String id;
  var title = "".obs;
  var note = "".obs;
  var coverPath = "".obs;
  var volumes = <Volume>[].obs;

  Comic({required this.id, required String title, String note = "", String coverPath = "", int totalVol = 0}) {
    this.title.value = title;
    this.note.value = note;
    this.coverPath.value = coverPath;
    // ทุกเล่มที่เพิ่มใหม่สถานะเริ่มต้นคือ "มีแล้ว" (owned: true)
    this.volumes.value = List.generate(totalVol, (i) => Volume(number: i + 1, owned: true));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title.value,
        'note': note.value,
        'coverPath': coverPath.value,
        'volumes': volumes.map((v) => v.toJson()).toList(),
      };

  factory Comic.fromJson(Map<String, dynamic> json) {
    var comic = Comic(
      id: json['id'],
      title: json['title'],
      note: json['note'] ?? "",
      coverPath: json['coverPath'] ?? "",
    );
    var volData = json['volumes'] as List;
    comic.volumes.value = volData.map((v) => Volume(number: v['number'], owned: v['isOwned'])).toList();
    return comic;
  }
}