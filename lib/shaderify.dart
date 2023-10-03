library shaderify;

import 'dart:ui' as ui;
import 'package:flutter_shaders/flutter_shaders.dart';

import 'package:flutter/widgets.dart';

final start = DateTime.now().millisecondsSinceEpoch.abs();

class ShaderWidget extends StatefulWidget {
  const ShaderWidget({super.key, required this.shaderPath});

  final String shaderPath;

  @override
  State<ShaderWidget> createState() => _ShaderWidgetState();
}

class _ShaderWidgetState extends State<ShaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late DateTime start;

  ui.Offset mousePos = const Offset(0, 0);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 365),
    )..repeat();

    start = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ShaderBuilder(
        assetKey: widget.shaderPath,
        (_, shader, __) => MouseRegion(
          onHover: (mouse) => setState(() {
            mousePos = mouse.localPosition;
          }),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, __) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: ShaderPainter(
                  shader: shader,
                  mousePos: mousePos,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader, required this.mousePos});
  final ui.FragmentShader shader;
  final Offset mousePos;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    shader.setFloat(2, mousePos.dx);
    shader.setFloat(3, mousePos.dy);

    var now = DateTime.now().millisecondsSinceEpoch.abs();
    var time = (now - start) / 1000.0;
    shader.setFloat(4, time);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
