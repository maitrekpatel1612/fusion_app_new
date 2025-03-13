// lib/examination/transcript/transcript_controller.dart
import 'transcript_model.dart';
import 'transcript_service.dart';

class TranscriptController {
  final TranscriptService _transcriptService = TranscriptService();

  Future<List<Transcript>> getTranscripts({
    String? programme,
    String? department,
    int? semester,
    String? studentId,
  }) {
    return _transcriptService.fetchTranscripts(
      programme: programme,
      department: department,
      semester: semester,
      studentId: studentId,
    );
  }
}
