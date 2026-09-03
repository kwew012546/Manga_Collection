class Volume {
  int number;
  bool isOwned;

  Volume({required this.number, this.isOwned = false});

  Map<String, dynamic> toJson() => {
        'number': number,
        'isOwned': isOwned,
      };

  factory Volume.fromJson(Map<String, dynamic> json) => Volume(
        number: json['number'],
        isOwned: json['isOwned'] ?? false,
      );
}

class Comic {
  String id;
  String title;
  String note;
  String coverPath;
  List<Volume> volumes;

  Comic({
    required this.id,
    required this.title,
    this.note = "",
    this.coverPath = "",
    required this.volumes,
  });

  // Helper factory for creating new comics with generated volumes
  factory Comic.create({
    required String id,
    required String title,
    String note = "",
    String coverPath = "",
    int totalVol = 0,
  }) {
    return Comic(
      id: id,
      title: title,
      note: note,
      coverPath: coverPath,
      volumes: List.generate(totalVol, (i) => Volume(number: i + 1, isOwned: true)),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'coverPath': coverPath,
        'volumes': volumes.map((v) => v.toJson()).toList(),
      };

  factory Comic.fromJson(Map<String, dynamic> json) {
    var volData = json['volumes'] as List? ?? [];
    return Comic(
      id: json['id'],
      title: json['title'],
      note: json['note'] ?? "",
      coverPath: json['coverPath'] ?? "",
      volumes: volData.map((v) => Volume.fromJson(v)).toList(),
    );
  }
}