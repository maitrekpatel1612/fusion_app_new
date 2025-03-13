// lib/examination/examination_router.dart
import 'package:flutter/material.dart';

// Importing screens for different functionalities in the Examination module.
import 'announcements/create_announcement_screen.dart';
import 'announcements/browse_announcement_screen.dart';
import 'grades/submit_grades/submit_grades_screen.dart';
import 'grades/verify_grades/verify_grades_screen.dart';
import 'grades/update_grades/update_grades_screen.dart';
import 'transcript/generate_transcript_screen.dart';
import 'transcript/transcript_list_screen.dart';
import 'transcript/transcript_preview_screen.dart';
import 'dashboard_screen.dart';

class ExaminationRouter {
  // Set the initial route for the Examination module.
  static const String initialRoute = '/dashboard';

  // Define the route map with paths and their corresponding screen widgets.
  static Map<String, WidgetBuilder> get routes {
    return {
      '/dashboard': (context) => const DashboardScreen(),
      '/examination/createAnnouncement': (context) => const CreateAnnouncementScreen(),
      '/examination/browse': (context) => const BrowseAnnouncementScreen(),
      '/examination/submitGrades': (context) => const SubmitGradesScreen(),
      '/examination/verifyGrades': (context) => const VerifyGradesScreen(),
      '/examination/updateGrades': (context) => const UpdateGradesScreen(),
      '/examination/generateTranscript': (context) => const GenerateTranscriptScreen(),
      '/examination/transcriptList': (context) => const TranscriptListScreen(),
      '/examination/transcriptPreview': (context) => const TranscriptPreviewScreen(),
    };
  }
}
