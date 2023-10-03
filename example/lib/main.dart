import 'package:flutter/widgets.dart';
import 'package:shaderify/shaderify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: ShaderWidget(shaderPath: "shaders/myshader.frag"),
    );
  }
}
