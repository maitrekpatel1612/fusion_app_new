// lib/examination/grade_model.dart

class Grade {
  final String studentId;
  final String studentName;
  final String subject;
  final String grade;
  final String programme;
  final String department;
  final String semester;

  Grade({
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.grade,
    required this.programme,
    required this.department,
    required this.semester,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      subject: json['subject'] as String,
      grade: json['grade'] as String,
      programme: json['programme'] as String,
      department: json['department'] as String,
      semester: json['semester'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'subject': subject,
      'grade': grade,
      'programme': programme,
      'department': department,
      'semester': semester,
    };
  }
} 