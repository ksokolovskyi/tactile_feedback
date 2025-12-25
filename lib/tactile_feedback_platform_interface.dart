// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tactile_feedback/api.g.dart';

import 'tactile_feedback_method_channel.dart';

abstract class TactileFeedbackPlatform extends PlatformInterface
    implements TactileFeedbackApi {
  /// Constructs a TactileFeedbackPlatform.
  TactileFeedbackPlatform() : super(token: _token);

  static final Object _token = Object();

  static TactileFeedbackPlatform _instance = MethodChannelTactileFeedback(
    isWeb: kIsWeb,
  );

  /// The default instance of [TactileFeedbackPlatform] to use.
  ///
  /// Defaults to [MethodChannelTactileFeedback].
  static TactileFeedbackPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TactileFeedbackPlatform] when
  /// they register themselves.
  static set instance(TactileFeedbackPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @override
  Future<void> impact() {
    throw UnimplementedError('impact() has not been implemented.');
  }

  @override
  BinaryMessenger? get pigeonVar_binaryMessenger => throw UnimplementedError();

  @override
  String get pigeonVar_messageChannelSuffix => throw UnimplementedError();
}
