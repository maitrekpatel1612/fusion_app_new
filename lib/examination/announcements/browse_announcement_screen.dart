// lib/examination/announcements/browse_announcement_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/file_utils.dart';
import 'announcement_model.dart';
import 'announcement_service.dart';
import 'dart:io';
import '../../utils/permission_utils.dart';

class BrowseAnnouncementScreen extends StatefulWidget {
  const BrowseAnnouncementScreen({super.key});

  @override
  State<BrowseAnnouncementScreen> createState() => _BrowseAnnouncementScreenState();
}

class _BrowseAnnouncementScreenState extends State<BrowseAnnouncementScreen> {
  late Future<List<Announcement>> _announcementsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() => _isLoading = true);
    try {
      _announcementsFuture = AnnouncementService().fetchAnnouncements();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading announcements: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openAttachment(String? attachmentPath, String? attachmentName) async {
    if (attachmentPath == null || attachmentName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No attachment available')),
      );
      return;
    }

    if (!await PermissionUtils.ensurePermissionsForFileOperation(context)) {
      return;
    }

    try {
      final file = File(attachmentPath);
      if (!await file.exists()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Attachment file not found')),
          );
        }
        return;
      }

      // Try to open the file using platform-specific method
      try {
        await FileUtils.openFile(file.path);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error opening file: $e')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing attachment: $e')),
        );
      }
    }
  }

  void _viewAnnouncementDetails(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Programme: ${announcement.programme}\n'
                'Department: ${announcement.department}\n',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(announcement.description),
              const SizedBox(height: 16),
              Text(
                'Posted on: ${DateFormat('MMM d, yyyy').format(announcement.date)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              if (announcement.attachmentPath != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _openAttachment(announcement.attachmentPath, announcement.attachmentName),
                  icon: const Icon(Icons.attachment),
                  label: Text(announcement.attachmentName ?? 'View Attachment'),
                ),
              ],
            ],
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Announcements'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadAnnouncements();
        },
        child: FutureBuilder<List<Announcement>>(
          future: _announcementsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading announcements'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadAnnouncements,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final announcements = snapshot.data ?? [];
            if (announcements.isEmpty) {
              return const Center(child: Text('No announcements found'));
            }

            return ListView.builder(
              itemCount: announcements.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final announcement = announcements[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    title: Text(
                      announcement.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM d, yyyy').format(announcement.date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: announcement.attachmentPath != null
                        ? const Icon(Icons.attachment)
                        : null,
                    onTap: () => _viewAnnouncementDetails(announcement),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/examination/createAnnouncement')
            .then((_) => _loadAnnouncements()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
