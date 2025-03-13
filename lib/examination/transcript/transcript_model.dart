// lib/examination/transcript/transcript_model.dart
import '../grade_model.dart';

class Course {
  final String code;
  final String name;
  final int credits;
  final String grade;

  Course({
    required this.code,
    required this.name,
    required this.credits,
    required this.grade,
  });
}

class Transcript {
  final String studentId;
  final String studentName;
  final String programme;
  final String department;
  final String semester;
  final String academicYear;
  final double spi;
  final List<SubjectGrade> grades;

  Transcript({
    required this.studentId,
    required this.studentName,
    required this.programme,
    required this.department,
    required this.semester,
    required this.academicYear,
    required this.spi,
    required this.grades,
  });

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      programme: json['programme'] as String,
      department: json['department'] as String,
      semester: json['semester'] as String,
      academicYear: json['academicYear'] as String,
      spi: json['spi'] as double,
      grades: (json['grades'] as List)
          .map((grade) => SubjectGrade.fromJson(grade as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'programme': programme,
      'department': department,
      'semester': semester,
      'academicYear': academicYear,
      'spi': spi,
      'grades': grades.map((grade) => grade.toJson()).toList(),
    };
  }

  // Calculate GPA from grades
  static double calculateGPA(List<Grade> grades) {
    if (grades.isEmpty) return 0.0;
    
    double totalPoints = 0.0;
    for (var grade in grades) {
      switch (grade.grade) {
        case 'A':
          totalPoints += 10.0;
          break;
        case 'A-':
          totalPoints += 9.0;
          break;
        case 'B+':
          totalPoints += 8.0;
          break;
        case 'B':
          totalPoints += 7.0;
          break;
        case 'B-':
          totalPoints += 6.0;
          break;
        case 'C+':
          totalPoints += 5.0;
          break;
        case 'C':
          totalPoints += 4.0;
          break;
        case 'D':
          totalPoints += 3.0;
          break;
        case 'F':
          totalPoints += 0.0;
          break;
        default:
          totalPoints += 0.0;
      }
    }
    
    return totalPoints / grades.length;
  }
}

class SubjectGrade {
  final String code;
  final String name;
  final int credits;
  final String grade;

  SubjectGrade({
    required this.code,
    required this.name,
    required this.credits,
    required this.grade,
  });

  factory SubjectGrade.fromJson(Map<String, dynamic> json) {
    return SubjectGrade(
      code: json['code'] as String,
      name: json['name'] as String,
      credits: json['credits'] as int,
      grade: json['grade'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'credits': credits,
      'grade': grade,
    };
  }
}
