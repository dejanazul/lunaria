class VideoItem {
  final String id;
  final String title;
  final String thumbnail;
  final String channel;
  final int views;
  final bool isLocked;
  final bool isFavorite;
  final String description;
  final List<VideoChapter> chapters;

  VideoItem({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.channel,
    required this.views,
    required this.isLocked,
    required this.isFavorite,
    required this.description,
    required this.chapters,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      channel: json['channel'],
      views: json['views'] ?? 0,
      isLocked: json['isLocked'] ?? true,
      isFavorite: json['isFavorite'] ?? false,
      description: json['description'] ?? '',
      chapters:
          (json['chapters'] as List? ?? [])
              .map((c) => VideoChapter.fromJson(c))
              .toList(),
    );
  }
}

class VideoChapter {
  final String title;
  final String thumbnail;
  final String time;

  VideoChapter({
    required this.title,
    required this.thumbnail,
    required this.time,
  });

  factory VideoChapter.fromJson(Map<String, dynamic> json) {
    return VideoChapter(
      title: json['title'],
      thumbnail: json['thumbnail'],
      time: json['time'],
    );
  }
}
