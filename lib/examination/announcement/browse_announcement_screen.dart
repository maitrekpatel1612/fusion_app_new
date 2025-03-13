import 'package:flutter/material.dart';
import '../../utils/file_utils.dart';
import '../../widgets/user_info_card.dart';

class BrowseAnnouncementScreen extends StatefulWidget {
  const BrowseAnnouncementScreen({super.key});

  @override
  State<BrowseAnnouncementScreen> createState() => _BrowseAnnouncementScreenState();
}

class _BrowseAnnouncementScreenState extends State<BrowseAnnouncementScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      _announcements = [
        {
          'id': '1',
          'title': 'End Semester Examination Schedule',
          'description': 'The end semester examination will begin from...',
          'date': DateTime.now(),
          'attachmentPath': 'path/to/file.pdf',
        },
        // Add more sample announcements
      ];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading announcements: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openAttachment(String filePath) async {
    try {
      await FileUtils.openFile(filePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: $e')),
        );
      }
    }
  }

  void _viewAnnouncementDetails(Map<String, dynamic> announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(announcement['title']),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(announcement['description']),
              const SizedBox(height: 16),
              Text(
                'Posted on: ${announcement['date'].toString().split('.')[0]}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              if (announcement['attachmentPath'] != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _openAttachment(announcement['attachmentPath']),
                  icon: const Icon(Icons.attachment),
                  label: const Text('View Attachment'),
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
      body: Column(
        children: [
          const UserInfoCard(title: 'Browse Announcements'),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _announcements.isEmpty
                    ? const Center(child: Text('No announcements found'))
                    : ListView.builder(
                        itemCount: _announcements.length,
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final announcement = _announcements[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                announcement['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                announcement['description'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: announcement['attachmentPath'] != null
                                  ? const Icon(Icons.attachment)
                                  : null,
                              onTap: () => _viewAnnouncementDetails(announcement),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-announcement')
            .then((_) => _loadAnnouncements()),
        child: const Icon(Icons.add),
      ),
    );
  }
} 