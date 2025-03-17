import 'dart:io';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'file_utils.dart';

class DocumentUtils {
  /// Generate a PDF document
  static Future<File> generatePDF({
    required String section,
    required String fileName,
    required Future<void> Function(pw.Document) builder,
  }) async {
    final pdf = pw.Document();
    await builder(pdf);

    final bytes = await pdf.save();
    final fullFileName = FileUtils.generateFileName(fileName, 'pdf');
    return FileUtils.saveModuleFile(section, fullFileName, bytes);
  }

  /// Generate a gradesheet PDF
  static Future<File> generateGradesheet({
    required String studentName,
    required String studentId,
    required String course,
    required String semester,
    required List<Map<String, dynamic>> grades,
  }) async {
    return generatePDF(
      section: 'Grades',
      fileName: 'gradesheet_$studentId',
      builder: (pdf) async {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Header(
                    level: 0,
                    child: pw.Text('Grade Sheet',
                        style: const pw.TextStyle(fontSize: 24)),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('Student Name: $studentName'),
                  pw.Text('Student ID: $studentId'),
                  pw.Text('Course: $course'),
                  pw.Text('Semester: $semester'),
                  pw.SizedBox(height: 20),
                  pw.Table.fromTextArray(
                    headers: ['Subject', 'Grade', 'Credits'],
                    data: grades
                        .map((grade) => [
                              grade['subject'],
                              grade['grade'],
                              grade['credits'].toString(),
                            ])
                        .toList(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Read Excel file and parse grades
  static Future<List<Map<String, dynamic>>> parseGradesFromExcel(
      String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final excel = Excel.decodeBytes(bytes);

    final List<Map<String, dynamic>> grades = [];
    for (var table in excel.tables.keys) {
      final sheet = excel.tables[table]!;
      // Skip header row
      for (var row in sheet.rows.skip(1)) {
        if (row.isEmpty) continue;
        grades.add({
          'subject': row[0]?.value?.toString() ?? '',
          'grade': row[1]?.value?.toString() ?? '',
          'credits': double.tryParse(row[2]?.value?.toString() ?? '0') ?? 0,
        });
      }
      break; // Only process first sheet
    }
    return grades;
  }

  /// Generate Excel template for grade submission
  static Future<File> generateGradeTemplate({
    required String course,
    required String semester,
    required List<String> subjects,
  }) async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];

    // Add headers
    sheet.getRangeByIndex(1, 1).setText('Subject');
    sheet.getRangeByIndex(1, 2).setText('Grade');
    sheet.getRangeByIndex(1, 3).setText('Credits');

    // Add subjects
    for (var i = 0; i < subjects.length; i++) {
      sheet.getRangeByIndex(i + 2, 1).setText(subjects[i]);
    }

    final bytes = workbook.saveAsStream();
    workbook.dispose();

    final fileName = FileUtils.generateFileName(
      'grade_template_${course}_$semester',
      'xlsx',
    );
    return FileUtils.saveModuleFile('Templates', fileName, bytes);
  }

  /// Verify Excel file format
  static bool verifyExcelFormat(String filePath) {
    try {
      final bytes = File(filePath).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      return excel.tables.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> parseTranscriptData(
      String filePath) async {
    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables.values.first;

    final List<Map<String, dynamic>> semesters = [];
    Map<String, dynamic>? currentSemester;

    for (var row in sheet.rows.skip(1)) {
      // Skip header row
      final semester = row[0]?.value?.toString();
      if (semester != null && semester.isNotEmpty) {
        if (currentSemester != null) {
          semesters.add(currentSemester);
        }
        currentSemester = {
          'semester': semester,
          'subjects': <Map<String, dynamic>>[],
        };
      }

      if (currentSemester != null &&
          row[1]?.value?.toString().isNotEmpty == true) {
        currentSemester['subjects'].add({
          'name': row[1]?.value?.toString() ?? '',
          'credits': row[2]?.value?.toString() ?? '',
          'grade': row[3]?.value?.toString() ?? '',
        });
      }
    }

    if (currentSemester != null) {
      semesters.add(currentSemester);
    }

    return semesters;
  }

  static Future<File> generateTranscriptTemplate(
      {required String course, required String year}) async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Add headers
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        'Semester';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        'Subject';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        'Credits';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        'Grade';

    // Example data
    int currentRow = 1;
    for (int semester = 1; semester <= 8; semester++) {
      sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: currentRow))
          .value = semester.toString();
      currentRow += 6; // Space for 5 subjects per semester
    }

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('Failed to encode Excel file');
    }

    final fileName = FileUtils.generateFileName(
      'transcript_template_${course.replaceAll(' ', '_')}',
      'xlsx',
    );
    return FileUtils.saveModuleFile('Templates', fileName, bytes);
  }

  static Future<File> generateTranscript({
    required String studentName,
    required String studentId,
    required String course,
    required String year,
    required List<Map<String, dynamic>> data,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Academic Transcript',
                    style: pw.TextStyle(
                        fontSize: 20, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Student Name: $studentName'),
              pw.Text('Student ID: $studentId'),
              pw.Text('Course: $course'),
              pw.Text('Academic Year: $year'),
              pw.SizedBox(height: 20),
              ...data.map((semester) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Semester ${semester['semester']}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Text('Subject'),
                            pw.Text('Credits'),
                            pw.Text('Grade'),
                          ],
                        ),
                        ...(semester['subjects'] as List<Map<String, dynamic>>)
                            .map((subject) {
                          return pw.TableRow(
                            children: [
                              pw.Text(subject['name']),
                              pw.Text(subject['credits']),
                              pw.Text(subject['grade']),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final fileName = FileUtils.generateFileName(
      'transcript_$studentId',
      'pdf',
    );
    return FileUtils.saveModuleFile('Transcripts', fileName, bytes);
  }
}
