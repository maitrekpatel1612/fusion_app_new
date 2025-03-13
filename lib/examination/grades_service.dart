import 'grade_model.dart';

class GradesService {
  // In-memory storage for grades (replace with actual database in production)
  static final List<Grade> _grades = [];

  // Fetch all grades
  Future<List<Grade>> fetchGrades() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _grades;
  }

  // Submit a new grade
  Future<void> submitGrade(Grade grade) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _grades.add(grade);
  }

  // Update an existing grade
  Future<void> updateGrade(Grade updatedGrade) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Find and update the grade
    final index = _grades.indexWhere(
      (g) => g.studentId == updatedGrade.studentId && g.subject == updatedGrade.subject
    );
    
    if (index != -1) {
      _grades[index] = updatedGrade;
    }
  }
  
  // Verify a grade
  Future<void> verifyGrade(String studentId, String subject) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real application, you would update a verification status field
    // For now, we'll just print a message
    print('Grade verified for student $studentId in subject $subject');
  }
} 