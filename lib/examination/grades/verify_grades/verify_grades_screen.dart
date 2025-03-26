// lib/examination/grades/verify_grades/verify_grades_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class VerifyGradesScreen extends StatefulWidget {
  const VerifyGradesScreen({super.key});

  @override
  VerifyGradesScreenState createState() => VerifyGradesScreenState();
}

class VerifyGradesScreenState extends State<VerifyGradesScreen> {
  String? _selectedCourse;
  String? _selectedAcademicYear;
  bool _showResults = false;

  final List<String> _courses = [
    'Select Select',
    'CS101',
    'CS102',
    'CS103',
    'CS104',
    'CS2003'
  ];
  final List<String> _academicYears = [
    'Select Academic Year',
    '2021-2022',
    '2022-2023',
    '2023-2024'
  ];

  // Sample data for the table
  final List<Map<String, dynamic>> _gradesData = [
    {
      'studentId': '22BCS184',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS188',
      'batch': 'bcs',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS201',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS001',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS202',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS123',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS184',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
    {
      'studentId': '22BCS184',
      'batch': '2022',
      'semester': '1',
      'courseId': 'CS2003',
      'remarks': 'S',
      'grade': 'A+'
    },
  ];

  // Grade distribution for pie chart
  final Map<String, int> _gradeDistribution = {
    'A/A+': 6,
    'B/B+': 1,
    'C/C+': 1,
    'D/D+': 1,
    'F': 1,
  };

  void _search() {
    // In a real app, you would implement search functionality
    setState(() {
      _showResults = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades loaded successfully')),
    );
  }

  void _verifyGrades() {
    // In a real app, you would implement verification functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades verified')),
    );
  }

  void _downloadGrades() {
    // In a real app, you would implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grades downloaded')),
    );
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
            Icon(Icons.verified, size: 20),
            SizedBox(width: 8),
            Text(
              'Verify Grades',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info card
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue[100],
                        radius: 24,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Depavanshi Kumari',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Student',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
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
              ),

              // Course dropdown
              const Text(
                'Course*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedCourse ?? 'Select Select',
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                  ),
                  items: _courses.map((course) {
                    return DropdownMenuItem(
                      value: course,
                      child: Text(course),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCourse = value;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
              const SizedBox(height: 16),

              // Academic Year dropdown
              const Text(
                'Academic Year*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedAcademicYear ?? 'Select Academic Year',
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                  ),
                  items: _academicYears.map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAcademicYear = value;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down),
                ),
              ),
              const SizedBox(height: 24),

              // Search button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Search'),
                ),
              ),

              if (_showResults) ...[
                const SizedBox(height: 32),

                // Grades table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        WidgetStateProperty.all(Colors.blue.shade50),
                    columns: const [
                      DataColumn(
                          label: Text('Student ID',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Batch',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Semester',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Course ID',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Remarks',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(
                          label: Text('Grades',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _gradesData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data['studentId'])),
                          DataCell(Text(data['batch'])),
                          DataCell(Text(data['semester'])),
                          DataCell(Text(data['courseId'])),
                          DataCell(Text(data['remarks'])),
                          DataCell(Text(data['grade'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 32),

                // Grade distribution legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('A/A+', Colors.blue),
                    const SizedBox(width: 16),
                    _buildLegendItem('B/B+', Colors.pink),
                    const SizedBox(width: 16),
                    _buildLegendItem('C/C+', Colors.teal),
                    const SizedBox(width: 16),
                    _buildLegendItem('D/D+', Colors.purple),
                    const SizedBox(width: 16),
                    _buildLegendItem('F', Colors.orange),
                  ],
                ),

                const SizedBox(height: 24),

                // Pie chart
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: _gradeDistribution['A/A+']!.toDouble(),
                          color: Colors.blue,
                          radius: 80,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: _gradeDistribution['B/B+']!.toDouble(),
                          color: Colors.pink,
                          radius: 80,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: _gradeDistribution['C/C+']!.toDouble(),
                          color: Colors.teal,
                          radius: 80,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: _gradeDistribution['D/D+']!.toDouble(),
                          color: Colors.purple,
                          radius: 80,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: _gradeDistribution['F']!.toDouble(),
                          color: Colors.orange,
                          radius: 80,
                          showTitle: false,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _verifyGrades,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text('Verify'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _downloadGrades,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text('Download'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
