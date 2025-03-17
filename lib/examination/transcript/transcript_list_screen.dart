import 'package:flutter/material.dart';

class TranscriptListScreen extends StatefulWidget {
  const TranscriptListScreen({super.key});

  @override
  TranscriptListScreenState createState() => TranscriptListScreenState();
}

class TranscriptListScreenState extends State<TranscriptListScreen> {
  final List<Map<String, dynamic>> _studentsData = [
    {
      'studentId': '22BCS184',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS186',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS187',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS201',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS202',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS203',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS204',
      'batch': '2023-24',
    },
    {
      'studentId': '22BCS205',
      'batch': '2023-24',
    },
  ];

  void _downloadTranscript(String studentId) {
    // Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading transcript for $studentId')),
    );
  }

  void _previewTranscript(String studentId) {
    Navigator.pushNamed(
      context,
      '/examination/transcriptPreview',
      arguments: studentId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.description, size: 20),
            SizedBox(width: 8),
            Text('Student Transcripts', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      body: Column(
        children: [
          // User info card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    radius: 24,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Depavanshi Kumari',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Student',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu),
                    label: const Text('Menu'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Table header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Student ID',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Batch',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Table content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _studentsData.length,
              itemBuilder: (context, index) {
                final student = _studentsData[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withAlpha(128),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            student['studentId'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            student['batch'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              TextButton.icon(
                                onPressed: () =>
                                    _previewTranscript(student['studentId']),
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Preview'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    _downloadTranscript(student['studentId']),
                                icon: const Icon(Icons.download, size: 16),
                                label: const Text('Download'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
