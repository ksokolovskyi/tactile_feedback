import 'tactile_feedback_platform_interface.dart';

abstract class TactileFeedback {
  static Future<void> impact() {
    return TactileFeedbackPlatform.instance.impact();
  }
}
