import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class FileUtils {
  static const String _baseFolder = 'Digident';
  static const String _moduleFolder = 'Examination';

  /// Check storage permission
  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.storage.request();
    return result.isGranted;
  }

  /// Get the base storage directory for the app
  static Future<String> getBaseStorageDir() async {
    if (!await checkStoragePermission()) {
      throw Exception('Storage permission not granted');
    }

    if (Platform.isAndroid) {
      final downloadsDir = Directory('/storage/emulated/0/Download');
      return downloadsDir.path;
    } else {
      final downloadsDir = await getDownloadsDirectory();
      return downloadsDir?.path ?? (await getTemporaryDirectory()).path;
    }
  }

  /// Get the downloads directory path
  static Future<String?> getDownloadPath() async {
    if (!await checkStoragePermission()) {
      return null;
    }

    final directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  /// Create the directory structure if it doesn't exist
  static Future<String> getModuleDirectory(String section) async {
    final baseDir = await getBaseStorageDir();
    final path = '$baseDir/$_baseFolder/$_moduleFolder/$section';
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return path;
  }

  /// Generate a filename with timestamp
  static String generateFileName(String baseName, String extension) {
    final timestamp = DateFormat('ddMMyyyy').format(DateTime.now());
    return '${baseName}_$timestamp.$extension';
  }

  /// Save a file to the specified path
  static Future<bool> saveFile(String filePath, List<int> bytes) async {
    try {
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save a file to the appropriate module directory
  static Future<File> saveModuleFile(String section, String fileName, List<int> bytes) async {
    if (!await checkStoragePermission()) {
      throw Exception('Storage permission not granted');
    }

    final dirPath = await getModuleDirectory(section);
    final file = File('$dirPath/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Open a file using the default system handler
  static Future<bool> openFile(String filePath) async {
    try {
      final result = await OpenFile.open(filePath);
      return result.type == ResultType.done;
    } catch (e) {
      return false;
    }
  }

  /// Check if a file exists
  static Future<bool> fileExists(String section, String fileName) async {
    final dirPath = await getModuleDirectory(section);
    final file = File('$dirPath/$fileName');
    return await file.exists();
  }

  /// Get file extension from mime type
  static String getExtensionFromMime(String mimeType) {
    switch (mimeType.toLowerCase()) {
      case 'application/pdf':
        return 'pdf';
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return 'xlsx';
      case 'application/vnd.ms-excel':
        return 'xls';
      case 'image/jpeg':
        return 'jpg';
      case 'image/png':
        return 'png';
      default:
        return 'bin';
    }
  }

  /// Get mime type from file extension
  static String getMimeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  /// Get file name from path
  static String getFileName(String filePath) {
    return filePath.split(Platform.pathSeparator).last;
  }

  /// Get file extension from path
  static String getFileExtension(String path) {
    return path.split('.').last;
  }
} 