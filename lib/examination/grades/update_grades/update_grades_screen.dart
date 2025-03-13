// lib/examination/grades/update_grades/update_grades_screen.dart
import 'package:flutter/material.dart';
import '../../grades_service.dart';
import '../../grade_model.dart';
import 'package:intl/intl.dart';

class UpdateGradesScreen extends StatefulWidget {
  const UpdateGradesScreen({super.key});

  @override
  _UpdateGradesScreenState createState() => _UpdateGradesScreenState();
}

class _UpdateGradesScreenState extends State<UpdateGradesScreen> {
  late Future<List<Grade>> _gradesFuture;
  final _gradeUpdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGrades();
  }

  void _loadGrades() {
    _gradesFuture = GradesService().fetchGrades();
  }

  Future<void> _updateGrade(Grade grade, String newGrade) async {
    Grade updatedGrade = Grade(
      studentId: grade.studentId,
      studentName: grade.studentName,
      subject: grade.subject,
      grade: newGrade,
      programme: grade.programme,
      department: grade.department,
      semester: grade.semester,
    );
    await GradesService().updateGrade(updatedGrade);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grade updated for ${grade.studentName}')),
      );
    }
    _loadGrades();
    setState(() {});
  }

  @override
  void dispose() {
    _gradeUpdateController.dispose();
    super.dispose();
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
            Icon(Icons.edit_note, size: 20),
            SizedBox(width: 8),
            Text('Update Grades (Dean)', style: TextStyle(fontSize: 16)),
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
                        'Dean',
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
          
          // Grades list
          Expanded(
            child: FutureBuilder<List<Grade>>(
              future: _gradesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading grades',
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ],
                    ),
                  );
                }
                final grades = snapshot.data;
                if (grades == null || grades.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.grade, size: 48, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No grades available'),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: grades.length,
                  itemBuilder: (context, index) {
                    final grade = grades[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Row(
                          children: [
                            Text(
                              grade.studentName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                grade.studentId,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.book, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(grade.subject),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.grade, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  'Current Grade: ${grade.grade}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _gradeUpdateController.text = grade.grade;
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Update Grade for ${grade.studentName}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _gradeUpdateController,
                                      decoration: const InputDecoration(
                                        labelText: 'New Grade',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Current Grade: ${grade.grade}',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _updateGrade(grade, _gradeUpdateController.text);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Update'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
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
