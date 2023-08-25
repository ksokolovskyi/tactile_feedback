import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tactile_feedback/tactile_feedback_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const flutterPlatformChannel = OptionalMethodChannel(
    'flutter/platform',
    JSONMethodCodec(),
  );

  const hapticVibrateMethod = 'HapticFeedback.vibrate';
  const hapticMediumImpactArgument = 'HapticFeedbackType.mediumImpact';

  const tactileFeedbackChannel = BasicMessageChannel<Object?>(
    'dev.flutter.pigeon.TactileFeedbackApi.impact',
    StandardMessageCodec(),
  );

  group('MethodChannelTactileFeedback', () {
    late MethodChannelTactileFeedback platform;

    setUp(() {
      platform = MethodChannelTactileFeedback(isWeb: false);
    });

    group('impact', () {
      test('does nothing when called on web', () async {
        platform = MethodChannelTactileFeedback(isWeb: true);

        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        var marker = 0;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockDecodedMessageHandler(
          tactileFeedbackChannel,
          (_) async {
            marker += 1;
            return [];
          },
        );

        await platform.impact();

        debugDefaultTargetPlatformOverride = null;

        expect(marker, equals(0));
      });

      test(
          'does nothing '
          'when debugDefaultPlatform is not TargetPlatform.iOS, '
          'TargetPlatform.android or TargetPlatform.macOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

        var marker = 0;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          flutterPlatformChannel,
          (_) {
            marker += 1;
            return null;
          },
        );

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockDecodedMessageHandler(
          tactileFeedbackChannel,
          (_) async {
            marker += 1;
            return null;
          },
        );

        await platform.impact();

        debugDefaultTargetPlatformOverride = null;

        expect(marker, equals(0));
      });

      test(
          'calls HapticFeedback.mediumImpact() '
          'when debugDefaultPlatform is TargetPlatform.iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        var marker = 0;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          flutterPlatformChannel,
          (call) {
            final argument = call.arguments;

            if (argument is! String) {
              return null;
            }

            if (call.method != hapticVibrateMethod ||
                argument != hapticMediumImpactArgument) {
              return null;
            }

            marker += 1;

            return null;
          },
        );

        await platform.impact();

        debugDefaultTargetPlatformOverride = null;

        expect(marker, equals(1));
      });

      test(
          'calls HapticFeedback.mediumImpact() '
          'when debugDefaultPlatform is TargetPlatform.android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        var marker = 0;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          flutterPlatformChannel,
          (call) {
            final argument = call.arguments;

            if (argument is! String) {
              return null;
            }

            if (call.method != hapticVibrateMethod ||
                argument != hapticMediumImpactArgument) {
              return null;
            }

            marker += 1;

            return null;
          },
        );

        await platform.impact();

        debugDefaultTargetPlatformOverride = null;

        expect(marker, equals(1));
      });

      test(
          'calls pigeon generated method channel '
          'when debugDefaultPlatform is TargetPlatform.macOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        var marker = 0;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockDecodedMessageHandler(
          tactileFeedbackChannel,
          (_) async {
            marker += 1;
            return [];
          },
        );

        await platform.impact();

        debugDefaultTargetPlatformOverride = null;

        expect(marker, equals(1));
      });

      test(
          'throws PlatformException '
          'when unable to establish connection with pigeon generated method channel',
          () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockDecodedMessageHandler(
          tactileFeedbackChannel,
          null,
        );

        try {
          await platform.impact();
          fail('PlatformException was not thrown');
        } catch (e) {
          expect(
            e,
            isA<PlatformException>()
                .having(
                  (e) => e.code,
                  'code',
                  equals('channel-error'),
                )
                .having(
                  (e) => e.message,
                  'message',
                  equals('Unable to establish connection on channel.'),
                ),
          );
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      });

      test(
          'throws PlatformException '
          'when pigeon generated method channel returns exception data',
          () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockDecodedMessageHandler(
          tactileFeedbackChannel,
          (_) async {
            return ['code', 'message', 'details'];
          },
        );

        try {
          await platform.impact();
          fail('PlatformException was not thrown');
        } catch (e) {
          expect(
            e,
            isA<PlatformException>()
                .having(
                  (e) => e.code,
                  'code',
                  equals('code'),
                )
                .having(
                  (e) => e.message,
                  'message',
                  equals('message'),
                )
                .having(
                  (e) => e.details,
                  'details',
                  equals('details'),
                ),
          );
        } finally {
          debugDefaultTargetPlatformOverride = null;
        }
      });
    });
  });
}
