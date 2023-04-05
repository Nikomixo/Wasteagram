import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'screens/home.dart';
import 'screens/post_entry_form.dart';
import 'screens/detailed_post.dart';

class App extends StatelessWidget {
  const App({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {   
    try {
      // throw StateError("Example Error!!");

      return MaterialApp(
        title: 'Wasteagram',
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        navigatorObservers: <NavigatorObserver>[observer],
        routes: {
          '/': (context) => const Home(),
          'entry': (context) => const PostEntryForm(),
          'detailed': (context) => const DetailedPost()
        }
      );
    } catch (exception, stackTrace) {
      Sentry.captureException(exception, stackTrace: stackTrace);
      throw StateError("Error has occured");
    }
  }
}