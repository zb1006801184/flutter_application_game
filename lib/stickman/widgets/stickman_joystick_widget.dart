import 'package:flutter/material.dart';

/// 虚拟摇杆（仅输出水平分量 -1～1）
class StickmanJoystickWidget extends StatefulWidget {
  /// 水平输入变化回调
  final ValueChanged<double> onChanged;

  const StickmanJoystickWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<StickmanJoystickWidget> createState() => _StickmanJoystickWidgetState();
}

class _StickmanJoystickWidgetState extends State<StickmanJoystickWidget> {
  /// 摇杆底座半径
  static const double _baseRadius = 48;

  /// 摇杆钮半径
  static const double _knobRadius = 20;

  /// 相对中心的偏移
  Offset _offset = Offset.zero;

  void _update(Offset local) {
    final center = const Offset(_baseRadius, _baseRadius);
    var delta = local - center;
    final maxDist = _baseRadius - _knobRadius;
    if (delta.distance > maxDist) {
      delta = Offset.fromDirection(delta.direction, maxDist);
    }
    setState(() => _offset = delta);
    // 仅取水平分量
    final horizontal = (delta.dx / maxDist).clamp(-1.0, 1.0);
    widget.onChanged(horizontal);
  }

  void _reset() {
    setState(() => _offset = Offset.zero);
    widget.onChanged(0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _baseRadius * 2,
      height: _baseRadius * 2,
      child: GestureDetector(
        onPanStart: (d) => _update(d.localPosition),
        onPanUpdate: (d) => _update(d.localPosition),
        onPanEnd: (_) => _reset(),
        onPanCancel: _reset,
        child: CustomPaint(
          painter: _JoystickPainter(offset: _offset),
        ),
      ),
    );
  }
}

/// 摇杆绘制
class _JoystickPainter extends CustomPainter {
  final Offset offset;

  _JoystickPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final base = Paint()..color = Colors.black.withValues(alpha: 0.12);
    final ring = Paint()
      ..color = Colors.deepOrange.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final knob = Paint()..color = Colors.deepOrange.withValues(alpha: 0.85);

    canvas.drawCircle(center, size.width / 2, base);
    canvas.drawCircle(center, size.width / 2 - 1, ring);
    canvas.drawCircle(center + offset, 20, knob);
  }

  @override
  bool shouldRepaint(covariant _JoystickPainter oldDelegate) {
    return oldDelegate.offset != offset;
  }
}
