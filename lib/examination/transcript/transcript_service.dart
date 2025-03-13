// lib/examination/transcript/transcript_service.dart
import 'dart:async';
import 'transcript_model.dart';
import '../grade_model.dart';
import 'package:uuid/uuid.dart';

class TranscriptService {
  static final TranscriptService _instance = TranscriptService._internal();

  factory TranscriptService() => _instance;

  TranscriptService._internal();

  // Simulated in-memory storage for transcripts.
  final List<Transcript> _transcripts = [
    Transcript(
      id: const Uuid().v4(),
      studentId: 'S1001',
      studentName: 'John Doe',
      programme: 'B.Tech',
      department: 'CSE',
      semester: 6,
      grades: [
        Grade(
          studentId: 'S1001',
          studentName: 'John Doe',
          subject: 'Data Structures',
          grade: 'A',
          programme: 'B.Tech',
          department: 'CSE',
          semester: 6,
        ),
        Grade(
          studentId: 'S1001',
          studentName: 'John Doe',
          subject: 'Algorithms',
          grade: 'B+',
          programme: 'B.Tech',
          department: 'CSE',
          semester: 6,
        ),
        Grade(
          studentId: 'S1001',
          studentName: 'John Doe',
          subject: 'Operating Systems',
          grade: 'A-',
          programme: 'B.Tech',
          department: 'CSE',
          semester: 6,
        ),
      ],
      courses: ['Data Structures', 'Algorithms', 'Operating Systems'],
      gpa: 8.67,
      generatedDate: DateTime.now(),
    ),
    // You can add more dummy transcripts here
  ];

  // Fetch transcripts based on search criteria (simulated filtering)
  Future<List<Transcript>> fetchTranscripts({
    String? programme,
    String? department,
    int? semester,
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
      if (semester != null) {
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
}
