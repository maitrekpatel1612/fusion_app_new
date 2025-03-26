// lib/examination/transcript/transcript_service.dart
import 'dart:async';
import 'transcript_model.dart';
import '../grades/grade_model.dart';
import 'package:uuid/uuid.dart';

class TranscriptService {
  static final TranscriptService _instance = TranscriptService._internal();

  factory TranscriptService() => _instance;

  TranscriptService._internal();

  // Simulated in-memory storage for transcripts.
  final List<Transcript> _transcripts = [
    Transcript(
      studentId: 'S1001',
      studentName: 'John Doe',
      programme: 'B.Tech',
      department: 'CSE',
      semester: '6',
      academicYear: '2023-24',
      spi: 8.67,
      grades: [
        SubjectGrade(
          code: 'CS301',
          name: 'Data Structures',
          credits: 4,
          grade: 'A',
        ),
        SubjectGrade(
          code: 'CS302',
          name: 'Algorithms',
          credits: 4,
          grade: 'B+',
        ),
        SubjectGrade(
          code: 'CS303',
          name: 'Operating Systems',
          credits: 4,
          grade: 'A-',
        ),
      ],
    ),
    // You can add more dummy transcripts here
  ];

  // Fetch transcripts based on search criteria (simulated filtering)
  Future<List<Transcript>> fetchTranscripts({
    String? programme,
    String? department,
    String? semester,
    String? studentId,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    List<Transcript> results = _transcripts.where((t) {
      bool matches = true;
      if (programme != null && programme.isNotEmpty) {
        matches =
            matches && t.programme.toLowerCase() == programme.toLowerCase();
      }
      if (department != null && department.isNotEmpty) {
        matches =
            matches && t.department.toLowerCase() == department.toLowerCase();
      }
      if (semester != null && semester.isNotEmpty) {
        matches = matches && t.semester == semester;
      }
      if (studentId != null && studentId.isNotEmpty) {
        matches =
            matches && t.studentId.toLowerCase() == studentId.toLowerCase();
      }
      return matches;
    }).toList();

    return results;
  }

  Future<List<Map<String, dynamic>>> getTranscript({
    required String academicYear,
    required String spi,
    required String id,
    required List<String> courses,
    required double gpa,
    required String generatedDate,
  }) async {
    // Implementation
    return [
      {
        'academicYear': academicYear,
        'spi': spi,
        'id': id,
        'courses': courses,
        'gpa': gpa,
        'generatedDate': generatedDate,
      }
    ];
  }
}
