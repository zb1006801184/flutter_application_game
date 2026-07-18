import 'package:flutter/material.dart';

/// 俄罗斯方块控制按钮组件
///
/// 提供左移、右移、旋转、软降、硬降五种操作
class TetrisControlPadWidget extends StatelessWidget {
  /// 左移回调
  final VoidCallback onLeft;

  /// 右移回调
  final VoidCallback onRight;

  /// 旋转回调
  final VoidCallback onRotate;

  /// 软降回调
  final VoidCallback onSoftDrop;

  /// 硬降回调
  final VoidCallback onHardDrop;

  const TetrisControlPadWidget({
    super.key,
    required this.onLeft,
    required this.onRight,
    required this.onRotate,
    required this.onSoftDrop,
    required this.onHardDrop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.rotate_right, '旋转', onRotate),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.arrow_back, '左移', onLeft),
            const SizedBox(width: 12),
            _buildButton(Icons.arrow_downward, '软降', onSoftDrop),
            const SizedBox(width: 12),
            _buildButton(Icons.arrow_forward, '右移', onRight),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(Icons.vertical_align_bottom, '硬降', onHardDrop),
          ],
        ),
      ],
    );
  }

  /// 单个控制按钮
  Widget _buildButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.deepPurple.withValues(alpha: 0.4)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.deepPurple, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}
