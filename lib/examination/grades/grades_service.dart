// lib/examination/grades/grades_service.dart
import 'dart:async';
import 'grade_model.dart';

class GradesService {
  static final GradesService _instance = GradesService._internal();

  factory GradesService() => _instance;

  GradesService._internal();

  final List<Grade> _grades = [];

  // Fetch all grades (simulate network delay)
  Future<List<Grade>> fetchGrades() async {
    await Future.delayed(const Duration(seconds: 1));
    return _grades;
  }

  // Submit a new grade
  Future<void> submitGrade(Grade grade) async {
    await Future.delayed(const Duration(seconds: 1));
    _grades.add(grade);
  }

  // Update an existing grade
  Future<void> updateGrade(Grade updatedGrade) async {
    await Future.delayed(const Duration(seconds: 1));
    int index = _grades.indexWhere((g) =>
        g.studentId == updatedGrade.studentId &&
        g.subject == updatedGrade.subject);
    if (index != -1) {
      _grades[index] = updatedGrade;
    }
  }

  // Simulate grade verification (for simplicity, no actual flag is updated)
  Future<void> verifyGrade(String studentId, String subject) async {
    await Future.delayed(const Duration(seconds: 1));
    // In a real implementation, you might update a verification flag here.
  }
}
