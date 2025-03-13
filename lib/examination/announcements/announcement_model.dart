// lib/examination/announcements/announcement_model.dart

class Announcement {
  final String id;
  final String title;
  final String description;
  final String programme;
  final String department;
  final DateTime date;
  final String? attachmentPath;
  final String? attachmentName;

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.programme,
    required this.department,
    required this.date,
    this.attachmentPath,
    this.attachmentName,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      programme: json['programme'] as String,
      department: json['department'] as String,
      date: DateTime.parse(json['date'] as String),
      attachmentPath: json['attachmentPath'] as String?,
      attachmentName: json['attachmentName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'programme': programme,
      'department': department,
      'date': date.toIso8601String(),
      'attachmentPath': attachmentPath,
      'attachmentName': attachmentName,
    };
  }
}
