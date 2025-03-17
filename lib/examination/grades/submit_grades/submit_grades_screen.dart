import 'package:flutter/material.dart';
import '../../../utils/document_utils.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/file_picker_utils.dart';
import '../../../widgets/user_info_card.dart';

class SubmitGradesScreen extends StatefulWidget {
  const SubmitGradesScreen({super.key});

  @override
  State<SubmitGradesScreen> createState() => _SubmitGradesScreenState();
}

class _SubmitGradesScreenState extends State<SubmitGradesScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCourse;
  String? _selectedSemester;
  String? _selectedFilePath;
  bool _isLoading = false;
  List<Map<String, dynamic>>? _parsedGrades;

  final List<String> _courses = ['B.Tech CSE', 'B.Tech ECE', 'B.Tech ME'];
  final List<String> _semesters = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '5th',
    '6th',
    '7th',
    '8th'
  ];

  Future<void> _pickFile() async {
    try {
      final filePath = await FilePickerUtils.pickFile(
        context,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (filePath != null) {
        if (!DocumentUtils.verifyExcelFormat(filePath)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid Excel format')),
            );
          }
          return;
        }

        setState(() {
          _selectedFilePath = filePath;
          _parsedGrades = null;
        });
        await _parseGrades();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _parseGrades() async {
    if (_selectedFilePath == null) return;

    setState(() => _isLoading = true);
    try {
      final grades =
          await DocumentUtils.parseGradesFromExcel(_selectedFilePath!);
      setState(() => _parsedGrades = grades);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing grades: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadTemplate() async {
    if (_selectedCourse == null || _selectedSemester == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select course and semester')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final subjects = [
        'Mathematics',
        'Physics',
        'Chemistry'
      ]; // Replace with actual subjects
      final file = await DocumentUtils.generateGradeTemplate(
        course: _selectedCourse!,
        semester: _selectedSemester!,
        subjects: subjects,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Template saved to: ${file.path}')),
        );
        await FileUtils.openFile(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating template: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _submitGrades() async {
    if (!mounted) return;
    final context = this.context; // Store context before async gap

    if (!_formKey.currentState!.validate() || _parsedGrades == null) return;

    setState(() => _isLoading = true);
    try {
      // TODO: Add API call to submit grades

      // Generate PDF gradesheet
      final file = await DocumentUtils.generateGradesheet(
        studentName: 'Deepansud Kumari',
        studentId: '12345',
        course: _selectedCourse!,
        semester: _selectedSemester!,
        grades: _parsedGrades!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Grades submitted successfully')),
      );
      await FileUtils.openFile(file.path);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting grades: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Grades'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserInfoCard(title: 'Submit Grades'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCourse,
                      decoration: const InputDecoration(
                        labelText: 'Course',
                        border: OutlineInputBorder(),
                      ),
                      items: _courses.map((course) {
                        return DropdownMenuItem(
                          value: course,
                          child: Text(course),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedCourse = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Please select a course';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedSemester,
                      decoration: const InputDecoration(
                        labelText: 'Semester',
                        border: OutlineInputBorder(),
                      ),
                      items: _semesters.map((semester) {
                        return DropdownMenuItem(
                          value: semester,
                          child: Text(semester),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedSemester = value);
                      },
                      validator: (value) {
                        if (value == null) return 'Please select a semester';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _downloadTemplate,
                            icon: const Icon(Icons.download),
                            label: const Text('Download Template'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _pickFile,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload Grades'),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedFilePath != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Selected file: ${FileUtils.getFileName(_selectedFilePath!)}',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                    if (_parsedGrades != null) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Preview:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _parsedGrades!.length,
                          itemBuilder: (context, index) {
                            final grade = _parsedGrades![index];
                            return ListTile(
                              title: Text(grade['subject']),
                              trailing: Text(
                                '${grade['grade']} (${grade['credits']} credits)',
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading || _parsedGrades == null
                          ? null
                          : _submitGrades,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Submit Grades'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
