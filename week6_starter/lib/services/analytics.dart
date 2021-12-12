import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void setLogEvent(FirebaseAnalytics analytics, String logName, bool success) {
  analytics.logEvent(
      name: logName,
      parameters: <String, dynamic> {
          'success': success,
      });
}

void setCurrentScreen(FirebaseAnalytics analytics, String screenName, String screenClass) {
  analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClass
  );
}