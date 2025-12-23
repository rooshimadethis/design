import 'package:flutter/material.dart';
import 'layout_shell.dart';
import 'theme.dart';

void main() {
  runApp(const MarshmallowPrototypeApp());
}

class MarshmallowPrototypeApp extends StatelessWidget {
  const MarshmallowPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MarshmallowTheme.theme,
      home: const LayoutShell(),
    );
  }
}
