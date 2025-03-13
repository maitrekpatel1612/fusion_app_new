// lib/examination/announcements/announcement_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'announcement_model.dart';

class AnnouncementService {
  static final AnnouncementService _instance = AnnouncementService._internal();
  static const String _storageKey = 'announcements';

  factory AnnouncementService() => _instance;

  AnnouncementService._internal();

  // Fetch all announcements
  Future<List<Announcement>> fetchAnnouncements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedData = prefs.getString(_storageKey);
      
      if (storedData == null) return [];
      
      final List<dynamic> jsonList = json.decode(storedData);
      return jsonList.map((json) => Announcement.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching announcements: $e');
      return [];
    }
  }

  // Create a new announcement
  Future<void> createAnnouncement(Announcement announcement) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? storedData = prefs.getString(_storageKey);
      
      List<Map<String, dynamic>> announcements = [];
      if (storedData != null) {
        announcements = List<Map<String, dynamic>>.from(json.decode(storedData));
      }
      
      announcements.insert(0, announcement.toJson());
      await prefs.setString(_storageKey, json.encode(announcements));
    } catch (e) {
      print('Error creating announcement: $e');
      throw Exception('Failed to create announcement');
    }
  }

  // Get announcement by ID
  Future<Announcement?> getAnnouncementById(String id) async {
    try {
      final announcements = await fetchAnnouncements();
      return announcements.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }
}
