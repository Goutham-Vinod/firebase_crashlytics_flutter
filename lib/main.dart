import 'dart:developer';
import 'dart:ui';

import 'package:crashlytics_test/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterError.onError = (errorDetails) {
    log("FlutterError : ${errorDetails.toString()}");
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    log("Platform Dispatcher, error : ${error.toString()}, stack : ${stack.toString()}");
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  print("Throwing a test crash");
                  throw Exception();
                },
                child: const Text('Throw Test Exception')),
            ElevatedButton(
                onPressed: () {
                  print("Throwing a test crash");

                  FirebaseCrashlytics.instance.crash();
                },
                child: const Text('Crash me')),
          ],
        )),
      ),
    );
  }
}
