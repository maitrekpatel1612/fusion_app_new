// lib/examination/grades/submit_grades/submit_grades_controller.dart
import '../../grade_model.dart';
import '../../grades_service.dart';

class SubmitGradesController {
  final GradesService _gradesService = GradesService();

  Future<void> submitGrade({
    required String studentId,
    required String studentName,
    required String subject,
    required String grade,
    required String programme,
    required String department,
    required String semester,
  }) async {
    // Create a new Grade instance
    Grade newGrade = Grade(
      studentId: studentId,
      studentName: studentName,
      subject: subject,
      grade: grade,
      programme: programme,
      department: department,
      semester: semester,
    );

    // Submit the grade via the service
    await _gradesService.submitGrade(newGrade);
  }
}
