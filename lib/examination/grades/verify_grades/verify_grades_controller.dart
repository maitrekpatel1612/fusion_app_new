// lib/examination/grades/verify_grades/verify_grades_controller.dart
import '../../grade_model.dart';
import '../../grades_service.dart';

class VerifyGradesController {
  final GradesService _gradesService = GradesService();

  Future<void> verifyGrade(Grade grade) async {
    // Verify the grade via the service (you might add additional logic as needed)
    await _gradesService.verifyGrade(grade.studentId, grade.subject);
  }
}
