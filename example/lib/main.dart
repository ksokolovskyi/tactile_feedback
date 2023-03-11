import 'package:flutter/material.dart';
import 'package:tactile_feedback/tactile_feedback.dart';

void main() {
  runApp(const MyApp());
}

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
