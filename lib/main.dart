// lib/main.dart
import 'package:flutter/material.dart';
import 'examination/examination_router.dart';
import 'utils/permission_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IIIDMJ Examination Module',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF0078D7),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0078D7),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          // Request permissions when app starts
          PermissionUtils.requestInitialPermissions(context);
          return const AppStartup(child: RouterWrapper());
        },
      ),
    );
  }
}

class RouterWrapper extends StatelessWidget {
  const RouterWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context),
      initialRoute: ExaminationRouter.initialRoute,
      routes: ExaminationRouter.routes,
    );
  }
}

class AppStartup extends StatefulWidget {
  final Widget child;

  const AppStartup({super.key, required this.child});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await PermissionUtils.requestInitialPermissions(context);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}