// lib/examination/announcements/announcement_widget.dart
import 'package:flutter/material.dart';
import 'announcement_model.dart';
import 'package:intl/intl.dart';

class AnnouncementWidget extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementWidget({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.yMMMd().format(announcement.date);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: const Text(announcement.title),
        subtitle: Text(
            '${announcement.department} - ${announcement.programme}\n$formattedDate'),
        isThreeLine: true,
        onTap: () {
          _showAnnouncementDetails(context);
        },
      ),
    );
  }

  void _showAnnouncementDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(announcement.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Programme: ${announcement.programme}'),
            Text('Department: ${announcement.department}'),
            const SizedBox(height: 8),
            Text(announcement.description),
            const SizedBox(height: 8),
            Text('Published on: $formattedDate'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
