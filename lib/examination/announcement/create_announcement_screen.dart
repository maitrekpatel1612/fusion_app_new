import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/file_utils.dart';
import '../../widgets/user_info_card.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  State<CreateAnnouncementScreen> createState() => _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _selectedFile;
  bool _isLoading = false;

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Future<void> _submitAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_selectedFile != null) {
        final fileName = FileUtils.generateFileName(
          'announcement_attachment',
          _selectedFile!.path.split('.').last,
        );
        
        final bytes = await _selectedFile!.readAsBytes();
        await FileUtils.saveFile('Announcements', fileName, bytes);
      }

      // TODO: Add API call to submit announcement

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement created successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating announcement: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserInfoCard(title: 'Create New Announcement'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _pickFile,
                      icon: const Icon(Icons.attach_file),
                      label: Text(_selectedFile != null
                          ? 'File selected: ${_selectedFile!.name}'
                          : 'Attach File'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitAnnouncement,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Create Announcement'),
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

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
} 