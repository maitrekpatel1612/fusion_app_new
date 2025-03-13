// lib/examination/grades/update_grades/update_grades_controller.dart
import '../../grade_model.dart';
import '../../grades_service.dart';

class UpdateGradesController {
  final GradesService _gradesService = GradesService();

  Future<void> updateGrade({
    required Grade grade,
    required String newGradeValue,
  }) async {
    // Create an updated Grade instance with the new grade value
    Grade updatedGrade = Grade(
      studentId: grade.studentId,
      studentName: grade.studentName,
      subject: grade.subject,
      grade: newGradeValue,
      programme: grade.programme,
      department: grade.department,
      semester: grade.semester,
    );

    // Update the grade via the service
    await _gradesService.updateGrade(updatedGrade);
  }
}
