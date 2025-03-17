// lib/examination/common/role_based_widget.dart
import 'package:flutter/material.dart';

enum UserRole { admin, dean, student }

class RoleBasedWidget extends StatelessWidget {
  final UserRole userRole;
  final Widget adminWidget;
  final Widget deanWidget;
  final Widget studentWidget;

  const RoleBasedWidget({
    super.key,
    required this.userRole,
    required this.adminWidget,
    required this.deanWidget,
    required this.studentWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (userRole) {
      case UserRole.admin:
        return adminWidget;
      case UserRole.dean:
        return deanWidget;
      case UserRole.student:
        return studentWidget;
    }
  }
}

const String admin = 'admin';
const String dean = 'dean';
const String student = 'student';
