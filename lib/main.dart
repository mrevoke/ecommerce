import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Homepage/home_page.dart'; // Import the HomePage widget

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase for web and other platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCo8eJrxlb6b0M_-isITqdPE5aQ3jTMR3U",
            authDomain: "ecommerce-3ea9f.firebaseapp.com",
            projectId: "ecommerce-3ea9f",
            storageBucket: "ecommerce-3ea9f.appspot.com",
            messagingSenderId: "556844493372",
            appId: "1:556844493372:web:c754279fed5931f7be7139",
            measurementId: "G-7C218D3TCC"));
  } else {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'your-api-key',
            appId: 'your-app-id',
            messagingSenderId: 'your-sender-id',
            projectId: 'ecommerce-3ea9f'));
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // Remove app header
    );
  }
}