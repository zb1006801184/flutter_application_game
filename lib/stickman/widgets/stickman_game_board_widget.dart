import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../bean/stickman_enemy_bean.dart';
import '../bean/stickman_level_bean.dart';
import '../bean/stickman_player_bean.dart';
/// 火柴人闯关场景画布（含相机跟随）
class StickmanGameBoardWidget extends StatelessWidget {
  /// 关卡数据
  final StickmanLevelBean level;

  /// 玩家
  final StickmanPlayerBean player;

  /// 敌人列表
  final List<StickmanEnemyBean> enemies;

  /// 剩余无敌毫秒（用于闪烁）
  final int invincibleMsLeft;

  const StickmanGameBoardWidget({
    super.key,
    required this.level,
    required this.player,
    required this.enemies,
    required this.invincibleMsLeft,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: CustomPaint(
            size: Size(constraints.maxWidth, constraints.maxHeight),
            painter: _StickmanBoardPainter(
              level: level,
              player: player,
              enemies: enemies,
              invincibleMsLeft: invincibleMsLeft,
              viewWidth: constraints.maxWidth,
              viewHeight: constraints.maxHeight,
            ),
          ),
        );
      },
    );
  }
}

/// 场景绘制器
class _StickmanBoardPainter extends CustomPainter {
  final StickmanLevelBean level;
  final StickmanPlayerBean player;
  final List<StickmanEnemyBean> enemies;
  final int invincibleMsLeft;
  final double viewWidth;
  final double viewHeight;

  _StickmanBoardPainter({
    required this.level,
    required this.player,
    required this.enemies,
    required this.invincibleMsLeft,
    required this.viewWidth,
    required this.viewHeight,
  });

  /// 世界坐标统一缩放（高度铺满视口）
  double get _scale => viewHeight / level.height;

  /// 相机世界 X：玩家中心始终对齐屏幕水平中心（不做关卡边界夹取）
  double get _cameraX {
    final playerCenterX = player.x + StickmanPlayerBean.width / 2;
    // screenX = (worldX - cameraX) * scale
    // viewWidth/2 = (playerCenterX - cameraX) * scale
    return playerCenterX - viewWidth / (2 * _scale);
  }

  double _sx(double worldX) => (worldX - _cameraX) * _scale;

  double _sy(double worldY) => worldY * _scale;

  double _sw(double worldW) => worldW * _scale;

  double _sh(double worldH) => worldH * _scale;

  @override
  void paint(Canvas canvas, Size size) {
    // 背景渐变条带
    final bg = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFB8D4E8), Color(0xFFE8F0E0)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    // 远景横线
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1;
    for (var i = 1; i < 6; i++) {
      final y = size.height * i / 7;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    _drawPlatforms(canvas);
    _drawSpikes(canvas);
    _drawGoal(canvas);
    for (final enemy in enemies) {
      _drawEnemy(canvas, enemy);
    }
    // 无敌时闪烁
    final hideBlink =
        invincibleMsLeft > 0 && (invincibleMsLeft ~/ 80).isOdd;
    if (!hideBlink) {
      _drawStickman(
        canvas,
        player.x,
        player.y,
        facingRight: player.facingRight,
        isAttacking: player.isAttacking,
        walkPhase: player.walkPhase,
        color: const Color(0xFF222222),
      );
    }
  }

  void _drawPlatforms(Canvas canvas) {
    final fill = Paint()..color = const Color(0xFF6B8F71);
    final edge = Paint()
      ..color = const Color(0xFF4A6B50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final p in level.platforms) {
      final rect = Rect.fromLTWH(_sx(p.x), _sy(p.y), _sw(p.w), _sh(p.h));
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        edge,
      );
    }
  }

  void _drawSpikes(Canvas canvas) {
    final paint = Paint()..color = const Color(0xFFC62828);
    for (final s in level.spikes) {
      final path = Path();
      final left = _sx(s.x);
      final bottom = _sy(s.bottom);
      final top = _sy(s.y);
      final w = _sw(s.w);
      // 三个三角尖刺
      final seg = w / 3;
      for (var i = 0; i < 3; i++) {
        path.moveTo(left + i * seg, bottom);
        path.lineTo(left + i * seg + seg / 2, top);
        path.lineTo(left + (i + 1) * seg, bottom);
        path.close();
      }
      canvas.drawPath(path, paint);
    }
  }

  void _drawGoal(Canvas canvas) {
    final g = level.goal;
    final pole = Paint()
      ..color = const Color(0xFF5D4037)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final flag = Paint()..color = const Color(0xFFFFC107);
    final px = _sx(g.x + 4);
    final top = _sy(g.y);
    final bottom = _sy(g.bottom);
    canvas.drawLine(Offset(px, top), Offset(px, bottom), pole);
    final flagPath = Path()
      ..moveTo(px, top)
      ..lineTo(px + _sw(22), top + _sh(10))
      ..lineTo(px, top + _sh(20))
      ..close();
    canvas.drawPath(flagPath, flag);
  }

  void _drawEnemy(Canvas canvas, StickmanEnemyBean enemy) {
    // 巡逻时按位移驱动走路相位
    final phase = enemy.x * 0.28;
    _drawStickman(
      canvas,
      enemy.x,
      enemy.y,
      facingRight: enemy.movingRight,
      isAttacking: false,
      walkPhase: phase,
      color: const Color(0xFFB71C1C),
      height: StickmanEnemyBean.height,
      width: StickmanEnemyBean.width,
    );
  }

  /// 绘制火柴人（含走路抬腿摆臂）
  void _drawStickman(
    Canvas canvas,
    double worldX,
    double worldY, {
    required bool facingRight,
    required bool isAttacking,
    required double walkPhase,
    required Color color,
    double width = StickmanPlayerBean.width,
    double height = StickmanPlayerBean.height,
  }) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final left = _sx(worldX);
    final top = _sy(worldY);
    final w = _sw(width);
    final h = _sh(height);
    final cx = left + w / 2;
    final headR = h * 0.12;
    final headC = Offset(cx, top + headR + 2);
    canvas.drawCircle(headC, headR, paint);

    final neck = Offset(cx, headC.dy + headR);
    final hip = Offset(cx, top + h * 0.55);
    canvas.drawLine(neck, hip, paint);

    // 走路摆动：前后腿 / 手臂反向
    final swing = math.sin(walkPhase);
    final strideX = w * 0.32 * swing;
    final strideY = h * 0.04 * swing.abs();
    final footY = top + h;

    // 左腿（相对朝向的后侧）与右腿
    canvas.drawLine(
      hip,
      Offset(cx - strideX, footY - strideY),
      paint,
    );
    canvas.drawLine(
      hip,
      Offset(cx + strideX, footY - (h * 0.04 - strideY)),
      paint,
    );

    // 手臂
    final shoulder = Offset(cx, top + h * 0.28);
    final dir = facingRight ? 1.0 : -1.0;
    if (isAttacking) {
      canvas.drawLine(
        shoulder,
        Offset(cx + dir * w * 0.85, shoulder.dy + h * 0.05),
        paint,
      );
      canvas.drawLine(
        shoulder,
        Offset(cx - dir * w * 0.2, shoulder.dy + h * 0.2),
        paint,
      );
    } else {
      // 手臂与腿反向摆动
      final armSwing = -swing;
      canvas.drawLine(
        shoulder,
        Offset(
          cx - w * 0.22 + armSwing * w * 0.28,
          shoulder.dy + h * 0.22,
        ),
        paint,
      );
      canvas.drawLine(
        shoulder,
        Offset(
          cx + w * 0.22 - armSwing * w * 0.28,
          shoulder.dy + h * 0.22,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StickmanBoardPainter oldDelegate) {
    return true;
  }
}