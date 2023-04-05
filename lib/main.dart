import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://1017d2d8af5a4e6596735d098f21ab81@o4504868055875584.ingest.sentry.io/4504868125999104';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const App()),
  );
}



