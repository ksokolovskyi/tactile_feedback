import 'package:flutter_test/flutter_test.dart';
import 'package:tactile_feedback/tactile_feedback.dart';
import 'package:tactile_feedback/tactile_feedback_platform_interface.dart';
import 'package:tactile_feedback/tactile_feedback_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTactileFeedbackPlatform
    with MockPlatformInterfaceMixin
    implements TactileFeedbackPlatform {
  final Function() callback;

  MockTactileFeedbackPlatform(this.callback);

  @override
  Future<void> impact() async {
    callback();
  }
}

class NotImplementedTactileFeedbackPlatform extends TactileFeedbackPlatform {
  NotImplementedTactileFeedbackPlatform();
}

void main() {
  test('MethodChannelTactileFeedback is the default instance', () {
    expect(
      TactileFeedbackPlatform.instance,
      isInstanceOf<MethodChannelTactileFeedback>(),
    );
  });

  group('impact', () {
    test(
        'throws UnimplementedError '
        'when not overridden', () async {
      TactileFeedbackPlatform.instance =
          NotImplementedTactileFeedbackPlatform();

      try {
        await TactileFeedback.impact();
        fail('UnimplementedError was not thrown');
      } catch (e) {
        expect(
          e,
          isA<UnimplementedError>().having(
            (e) => e.message,
            'message',
            'impact() has not been implemented.',
          ),
        );
      }
    });

    test('calls impact method of the provided instance', () async {
      var marker = 0;

      final mockPlatform = MockTactileFeedbackPlatform(() {
        marker += 1;
      });

      TactileFeedbackPlatform.instance = mockPlatform;

      await TactileFeedback.impact();

      expect(marker, 1);
    });
  });
}
