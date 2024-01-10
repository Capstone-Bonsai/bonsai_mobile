import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const App());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => FutureBuilder(
              future: autoLoginFuture(context),
              builder: (context, snapshot) {
                // Check if the Future has completed
                if (snapshot.connectionState == ConnectionState.done) {
                  // Navigate to your default page widget
                  return const CircularProgressIndicator();
                } else {
                  // Display a loading indicator or placeholder while the Future is still running
                  return const CircularProgressIndicator();
                }
              },
            ),
      }
    );
  }
}
