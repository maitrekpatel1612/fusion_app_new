// lib/examination/grades/grade_model.dart
class Grade {
  final String studentId;
  final String studentName;
  final String subject;
  final String grade;
  final String programme;
  final String department;
  final int semester;

  Grade({
    required this.studentId,
    required this.studentName,
    required this.subject,
    required this.grade,
    required this.programme,
    required this.department,
    required this.semester,
  });
}
