import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.blue),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // DASHBOARD section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'DASHBOARD',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  'Dashboard',
                  Icons.dashboard_outlined,
                  () => Navigator.pushReplacementNamed(context, '/dashboard'),
                ),
                _buildMenuItem(
                  context,
                  'Orders',
                  Icons.shopping_cart_outlined,
                  () {},
                ),
                _buildMenuItem(
                  context,
                  'Orders',
                  Icons.shopping_cart_outlined,
                  () {},
                ),

                const SizedBox(height: 16),

                // EXAMINATION section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'EXAMINATION',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  'Examination',
                  Icons.school_outlined,
                  () => Navigator.pushReplacementNamed(context, '/dashboard'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildMenuItem(
                    context,
                    'Announcement',
                    Icons.campaign_outlined,
                    () => Navigator.pushNamed(context, '/examination/browse'),
                    isHighlighted: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildMenuItem(
                    context,
                    'Submit Grades',
                    Icons.assignment_outlined,
                    () => Navigator.pushNamed(
                        context, '/examination/submitGrades'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildMenuItem(
                    context,
                    'Verify Grades',
                    Icons.verified_outlined,
                    () => Navigator.pushNamed(
                        context, '/examination/verifyGrades'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildMenuItem(
                    context,
                    'Generate Transcript',
                    Icons.description_outlined,
                    () => Navigator.pushNamed(
                        context, '/examination/generateTranscript'),
                  ),
                ),

                const Divider(height: 32),

                // SETTINGS section
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  'Profile',
                  Icons.person_outline,
                  () {},
                ),
                _buildMenuItem(
                  context,
                  'Settings',
                  Icons.settings_outlined,
                  () {},
                ),
                _buildMenuItem(
                  context,
                  'Help',
                  Icons.help_outline,
                  () {},
                ),
                _buildMenuItem(
                  context,
                  'Log out',
                  Icons.logout_outlined,
                  () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isHighlighted = false,
  }) {
    final Color backgroundColor =
        isHighlighted ? Colors.blue.withAlpha(128) : Colors.transparent;

    final Color iconColor =
        isHighlighted ? Colors.blue : Colors.grey.withAlpha(128);

    final Color textColor = isHighlighted ? Colors.blue : Colors.black;

    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
