import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerUtils {
  static Future<String?> pickFile(BuildContext context, {List<String>? allowedExtensions}) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission not granted');
    }

    final result = await showDialog<String>(
      context: context,
      builder: (context) => _FilePickerDialog(allowedExtensions: allowedExtensions),
    );

    return result;
  }
}

class _FilePickerDialog extends StatefulWidget {
  final List<String>? allowedExtensions;

  const _FilePickerDialog({this.allowedExtensions});

  @override
  _FilePickerDialogState createState() => _FilePickerDialogState();
}

class _FilePickerDialogState extends State<_FilePickerDialog> {
  Directory? _currentDirectory;
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    try {
      if (_currentDirectory == null) {
        final externalDir = await getExternalStorageDirectory();
        _currentDirectory = Directory(externalDir?.path ?? '/storage/emulated/0');
      }
      _files = await _currentDirectory!.list().toList();
      _files.sort((a, b) {
        if (a is Directory && b is File) return -1;
        if (a is File && b is Directory) return 1;
        return a.path.compareTo(b.path);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading files: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isAllowedFile(String path) {
    if (widget.allowedExtensions == null) return true;
    final extension = path.split('.').last.toLowerCase();
    return widget.allowedExtensions!.contains(extension);
  }

  void _navigateToDirectory(Directory directory) {
    setState(() {
      _currentDirectory = directory;
      _loadFiles();
    });
  }

  void _selectFile(String path) {
    Navigator.pop(context, path);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_currentDirectory?.path ?? 'Select File'),
      content: SizedBox(
        width: double.maxFinite,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (_currentDirectory?.parent != null)
                    ListTile(
                      leading: const Icon(Icons.folder),
                      title: const Text('..'),
                      onTap: () => _navigateToDirectory(_currentDirectory!.parent),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        final file = _files[index];
                        final isDirectory = file is Directory;
                        final name = file.path.split('/').last;

                        if (isDirectory) {
                          return ListTile(
                            leading: const Icon(Icons.folder),
                            title: Text(name),
                            onTap: () => _navigateToDirectory(file),
                          );
                        }

                        final isAllowed = _isAllowedFile(file.path);
                        return ListTile(
                          enabled: isAllowed,
                          leading: Icon(
                            Icons.insert_drive_file,
                            color: isAllowed ? null : Colors.grey,
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              color: isAllowed ? null : Colors.grey,
                            ),
                          ),
                          onTap: () => _selectFile(file.path),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
} 