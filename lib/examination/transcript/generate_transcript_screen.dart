import 'package:flutter/material.dart';
import '../../utils/document_utils.dart';
import '../../utils/file_utils.dart';
import '../../utils/file_picker_utils.dart';
import '../../widgets/user_info_card.dart';

class GenerateTranscriptScreen extends StatefulWidget {
  const GenerateTranscriptScreen({super.key});

  @override
  State<GenerateTranscriptScreen> createState() =>
      _GenerateTranscriptScreenState();
}

class _GenerateTranscriptScreenState extends State<GenerateTranscriptScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCourse;
  String? _selectedYear;
  String? _selectedFilePath;
  bool _isLoading = false;
  List<Map<String, dynamic>>? _parsedData;

  final List<String> _courses = ['B.Tech CSE', 'B.Tech ECE', 'B.Tech ME'];
  final List<String> _years = ['2020-21', '2021-22', '2022-23', '2023-24'];

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
          _parsedData = null;
        });
        await _parseData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  Future<void> _parseData() async {
    if (_selectedFilePath == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await DocumentUtils.parseTranscriptData(_selectedFilePath!);
      setState(() => _parsedData = data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error parsing data: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _downloadTemplate() async {
    if (_selectedCourse == null || _selectedYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select course and year')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final file = await DocumentUtils.generateTranscriptTemplate(
        course: _selectedCourse!,
        year: _selectedYear!,
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

  Future<void> _generateTranscript() async {
    if (!mounted) return;
    final context = this.context; // Store context before async gap

    if (!_formKey.currentState!.validate() || _parsedData == null) return;

    setState(() => _isLoading = true);
    try {
      final file = await DocumentUtils.generateTranscript(
        studentName: 'Deepansud Kumari',
        studentId: '12345',
        course: _selectedCourse!,
        year: _selectedYear!,
        data: _parsedData!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transcript generated successfully')),
        );
        await FileUtils.openFile(file.path);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating transcript: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Transcript'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserInfoCard(title: 'Generate Transcript'),
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
                      value: _selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Academic Year',
                        border: OutlineInputBorder(),
                      ),
                      items: _years.map((year) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedYear = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an academic year';
                        }
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
                            label: const Text('Upload Data'),
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
                    if (_parsedData != null) ...[
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
                          itemCount: _parsedData!.length,
                          itemBuilder: (context, index) {
                            final semester = _parsedData![index];
                            return ExpansionTile(
                              title: Text('Semester ${semester['semester']}'),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: semester['subjects'].length,
                                  itemBuilder: (context, subIndex) {
                                    final subject =
                                        semester['subjects'][subIndex];
                                    return ListTile(
                                      title: Text(subject['name']),
                                      trailing: Text(
                                        '${subject['grade']} (${subject['credits']} credits)',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading || _parsedData == null
                          ? null
                          : _generateTranscript,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Generate Transcript'),
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
