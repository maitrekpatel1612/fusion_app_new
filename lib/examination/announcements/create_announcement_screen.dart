// lib/examination/announcements/create_announcement_screen.dart
import 'package:flutter/material.dart';
import 'announcement_service.dart';
import 'announcement_model.dart';
import 'package:uuid/uuid.dart';
import '../sidebar_menu.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/file_utils.dart';
import '../../utils/permission_utils.dart';

class CreateAnnouncementScreen extends StatefulWidget {
  const CreateAnnouncementScreen({super.key});

  @override
  _CreateAnnouncementScreenState createState() =>
      _CreateAnnouncementScreenState();
}

class _CreateAnnouncementScreenState extends State<CreateAnnouncementScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedProgramme;
  String? _selectedBatch;
  String? _selectedDepartment;
  XFile? _selectedFile;
  bool _isLoading = false;
  
  late TabController _tabController;
  
  final List<String> _programmes = ['B.Tech', 'M.Tech', 'PhD'];
  final List<String> _batches = ['2021', '2022', '2023', '2024'];
  final List<String> _departments = ['CSE', 'ECE', 'ME', 'CE', 'EE'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickFile() async {
    if (!await PermissionUtils.ensurePermissionsForFileOperation(context)) {
      return;
    }
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      
      if (file != null) {
        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void _publishAnnouncement() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedProgramme == null || _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select programme and department')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? attachmentPath;
      String? attachmentName;

      if (_selectedFile != null) {
        if (!await PermissionUtils.ensurePermissionsForFileOperation(context)) {
          setState(() => _isLoading = false);
          return;
        }
        
        final fileName = FileUtils.generateFileName(
          'announcement_attachment',
          _selectedFile!.path.split('.').last,
        );
        
        final bytes = await _selectedFile!.readAsBytes();
        final file = await FileUtils.saveModuleFile('Announcements', fileName, bytes);
        
        attachmentPath = file.path;
        attachmentName = _selectedFile!.name;
      }

      final announcement = Announcement(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        programme: _selectedProgramme!,
        department: _selectedDepartment!,
        date: DateTime.now(),
        attachmentPath: attachmentPath,
        attachmentName: attachmentName,
      );

      await AnnouncementService().createAnnouncement(announcement);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement Published Successfully')),
        );
        Navigator.pushReplacementNamed(context, '/examination/browse');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error publishing announcement: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tabController.dispose();
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
            Icon(Icons.campaign, size: 20),
            SizedBox(width: 8),
            Text(
              'Announcement',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // User profile header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue[100],
                  child: const Icon(Icons.person, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Depavanshi Kumari',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'AcadAdmin',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SidebarMenu(),
                      ),
                    );
                  },
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
          
          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _tabController.index == 0 ? Colors.blue : Colors.blue.withAlpha(25),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_active,
                                color: _tabController.index == 0 ? Colors.white : Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Make New',
                                style: TextStyle(
                                  color: _tabController.index == 0 ? Colors.white : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: _tabController.index == 1 ? Colors.blue : Colors.blue.withAlpha(25),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: _tabController.index == 1 ? Colors.white : Colors.blue,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Browse',
                                style: TextStyle(
                                  color: _tabController.index == 1 ? Colors.white : Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    indicatorColor: Colors.transparent,
                    onTap: (index) {
                      setState(() {});
                      if (index == 1) {
                        // Navigate to browse screen
                        Navigator.pushNamed(context, '/examination/browse');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Form
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Make New tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Programme field
                        const Text(
                          'Programme*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedProgramme,
                            decoration: InputDecoration(
                              hintText: 'Select Programme',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            items: _programmes.map((programme) {
                              return DropdownMenuItem(
                                value: programme,
                                child: Text(programme),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedProgramme = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a programme';
                              }
                              return null;
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Batch field
                        const Text(
                          'Batch*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedBatch,
                            decoration: InputDecoration(
                              hintText: 'Select Batch',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            items: _batches.map((batch) {
                              return DropdownMenuItem(
                                value: batch,
                                child: Text(batch),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedBatch = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a batch';
                              }
                              return null;
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Department field
                        const Text(
                          'Department*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            value: _selectedDepartment,
                            decoration: InputDecoration(
                              hintText: 'Select Department',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            items: _departments.map((department) {
                              return DropdownMenuItem(
                                value: department,
                                child: Text(department),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDepartment = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a department';
                              }
                              return null;
                            },
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Title field
                        const Text(
                          'Title*',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Enter announcement title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        // Description field
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Write here...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLines: 6,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Attach Files
                        const Text(
                          'Attach Files',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _isLoading ? null : _pickFile,
                          icon: const Icon(Icons.attach_file),
                          label: Text(_selectedFile != null 
                            ? 'Selected: ${_selectedFile!.name}'
                            : 'Attach File'),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Publish button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _publishAnnouncement,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Publish',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Browse tab (placeholder, will navigate to browse screen)
                const Center(
                  child: Text('Redirecting to browse screen...'),
                ),
              ],
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
