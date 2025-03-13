import 'package:flutter/material.dart';
import '../sidebar_menu.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Examination'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      drawer: const SidebarMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Feature cards
            _buildFeatureCard(
              context,
              'Announcement',
              Icons.announcement,
              '/examination/browse',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Submit Grades',
              Icons.assignment,
              '/examination/submitGrades',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Verify Grades',
              Icons.verified,
              '/examination/verifyGrades',
              Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              context,
              'Generate Transcript',
              Icons.description,
              '/examination/generateTranscript',
              Colors.blue,
            ),
          ],
        ),
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

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 