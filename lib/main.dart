import 'package:booknest/pages/home_page.dart';
import 'package:booknest/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "",
        appId: "",
        messagingSenderId: "",
        projectId: "",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookNest',
        theme: ThemeData(
          textTheme: GoogleFonts.leagueSpartanTextTheme(),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 193, 219, 179)),
          useMaterial3: true,
        ),
        home: const HomePage());
  }
}
