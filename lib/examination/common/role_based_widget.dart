// lib/examination/common/role_based_widget.dart
import 'package:flutter/material.dart';

enum UserRole { Admin, Dean, Student }

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
      case UserRole.Admin:
        return adminWidget;
      case UserRole.Dean:
        return deanWidget;
      case UserRole.Student:
        return studentWidget;
      default:
        return Container();
    }
  }
}
