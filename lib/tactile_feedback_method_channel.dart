import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tactile_feedback/api.g.dart';

import 'tactile_feedback_platform_interface.dart';

/// An implementation of [TactileFeedbackPlatform] that uses [pigeon] generated
/// method channel calls for macOS platform and [HapticFeedback] Flutter API for
/// iOS and android
class MethodChannelTactileFeedback extends TactileFeedbackPlatform {
  final TactileFeedbackApi _api;

  final bool _isWeb;

  MethodChannelTactileFeedback({
    required bool isWeb,
  })  : _api = TactileFeedbackApi(),
        _isWeb = isWeb;

  @override
  Future<void> impact() async {
    if (_isWeb) {
      // do nothing
      return;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return HapticFeedback.mediumImpact();

      case TargetPlatform.macOS:
        return _api.impact();

      default:
      // do nothing
    }
  }
}
