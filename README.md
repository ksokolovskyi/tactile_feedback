# Tactile feedback on iOS, Android and MacOS

This package gives you the ability to add a tactile feedback for some actions inside your Flutter application.

To see example of the following functionality on a device or simulator:

```bash
cd example/
flutter run --release
```

## Usage

Just call the `TactileFeedback.impact();` method and user will feel the feedback.

```dart
import 'package:flutter/material.dart';
import 'package:tactile_feedback/tactile_feedback.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('tactile_feedback example'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;
              final side = size.shortestSide / 2;

              return GestureDetector(
                onTap: () => TactileFeedback.impact(),
                child: MouseRegion(
                  onEnter: (_) => TactileFeedback.impact(),
                  onExit: (_) => TactileFeedback.impact(),
                  cursor: SystemMouseCursors.noDrop,
                  child: Container(
                    width: side,
                    height: side,
                    color: Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```