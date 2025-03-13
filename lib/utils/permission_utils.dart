import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class PermissionUtils {
  static Future<bool> checkAndRequestStoragePermission(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        if (await _isAndroid11OrHigher()) {
          // For Android 11+, request manage external storage permission
          final status = await Permission.manageExternalStorage.status;
          if (status.isGranted) return true;

          if (status.isDenied) {
            final result = await Permission.manageExternalStorage.request();
            if (result.isGranted) return true;
          }
        } else {
          // For Android 10 and below, request storage permission
          final status = await Permission.storage.status;
          if (status.isGranted) return true;

          if (status.isDenied) {
            final result = await Permission.storage.request();
            if (result.isGranted) return true;
          }
        }
      } else {
        // For iOS and other platforms
        final status = await Permission.storage.status;
        if (status.isGranted) return true;

        final result = await Permission.storage.request();
        return result.isGranted;
      }

      // If permission is permanently denied
      if (context.mounted) {
        final shouldOpenSettings = await _showPermissionExplanationDialog(context);
        if (shouldOpenSettings) {
          await openAppSettings();
        }
      }
      return false;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return false;
    }
  }

  static Future<bool> _isAndroid11OrHigher() async {
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkVersion();
      return sdkInt >= 30; // Android 11 is API level 30
    }
    return false;
  }

  static Future<int> _getAndroidSdkVersion() async {
    try {
      return int.parse(Platform.version.split('.')[0]);
    } catch (e) {
      return 0;
    }
  }

  static Future<bool> _showPermissionExplanationDialog(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This app needs storage permission to:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Upload and download files'),
              Text('• Save announcements and attachments'),
              Text('• Access and manage documents'),
              SizedBox(height: 12),
              Text(
                'Please grant storage permission to continue using these features.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Not Now'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Open Settings'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  static Future<bool> ensurePermissionsForFileOperation(BuildContext context) async {
    final hasPermission = await checkAndRequestStoragePermission(context);
    if (!hasPermission && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is required to perform this operation'),
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
    return true;
  }

  // Helper method to request permissions at app startup
  static Future<void> requestInitialPermissions(BuildContext context) async {
    // Wait a bit for the app to settle
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      await checkAndRequestStoragePermission(context);
    }
  }
}