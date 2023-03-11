import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tactile_feedback/tactile_feedback_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelTactileFeedback();

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
    group('impact', () {
      test(
          'throws UnimplementedError '
          'when debugDefaultPlatform is not TargetPlatform.iOS, '
          'TargetPlatform.android or TargetPlatform.macOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

        try {
          await platform.impact();
          fail('UnimplementedError was not thrown');
        } catch (e) {
          expect(
            e,
            isA<UnimplementedError>().having(
              (e) => e.message,
              'message',
              'TargetPlatform.fuchsia platform is not supported',
            ),
          );
        }
      });

      test(
          'calls HapticFeedback.mediumImpact() '
          'when debugDefaultPlatform is TargetPlatform.iOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

        var marker = 0;

        flutterPlatformChannel.setMockMethodCallHandler(
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

        flutterPlatformChannel.setMockMethodCallHandler(null);

        expect(marker, 1);
      });

      test(
          'calls HapticFeedback.mediumImpact() '
          'when debugDefaultPlatform is TargetPlatform.android', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;

        var marker = 0;

        flutterPlatformChannel.setMockMethodCallHandler(
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

        flutterPlatformChannel.setMockMethodCallHandler(null);

        expect(marker, 1);
      });

      test(
          'calls pigeon generated method channel '
          'when debugDefaultPlatform is TargetPlatform.macOS', () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        var marker = 0;

        tactileFeedbackChannel.setMockMessageHandler(
          (_) async {
            marker += 1;
            return [];
          },
        );

        await platform.impact();

        tactileFeedbackChannel.setMockMessageHandler(null);

        expect(marker, 1);
      });

      test(
          'throws PlatformException '
          'when unable to establish connection with pigeon generated method channel',
          () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        tactileFeedbackChannel.setMockMessageHandler(
          (_) async {
            return null;
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
                  'channel-error',
                )
                .having(
                  (e) => e.message,
                  'message',
                  'Unable to establish connection on channel.',
                ),
          );
        } finally {
          tactileFeedbackChannel.setMockMessageHandler(null);
        }
      });

      test(
          'throws PlatformException '
          'when pigeon generated method channel returns exception data',
          () async {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

        tactileFeedbackChannel.setMockMessageHandler(
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
                .having((e) => e.code, 'code', 'code')
                .having((e) => e.message, 'message', 'message')
                .having((e) => e.details, 'details', 'details'),
          );
        } finally {
          tactileFeedbackChannel.setMockMessageHandler(null);
        }
      });
    });
  });
}
