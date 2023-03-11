import Cocoa
import FlutterMacOS

private class TactileFeedback: NSObject, TactileFeedbackApi {
    func impact() throws {
        NSHapticFeedbackManager.defaultPerformer.perform(
            NSHapticFeedbackManager.FeedbackPattern.alignment,
            performanceTime: NSHapticFeedbackManager.PerformanceTime.now
        )
    }
}

public class TactileFeedbackPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        TactileFeedbackApiSetup.setUp(
            binaryMessenger: registrar.messenger,
            api: TactileFeedback()
        )
    }
}
