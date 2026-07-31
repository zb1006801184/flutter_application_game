import 'package:flutter/material.dart';

/// 跳跃 / 攻击按钮区
class StickmanActionPadWidget extends StatelessWidget {
  /// 跳跃回调
  final VoidCallback onJump;

  /// 攻击回调
  final VoidCallback onAttack;

  const StickmanActionPadWidget({
    super.key,
    required this.onJump,
    required this.onAttack,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          label: '攻',
          color: Colors.redAccent,
          onTap: onAttack,
        ),
        const SizedBox(width: 16),
        _buildButton(
          label: '跳',
          color: Colors.deepOrange,
          onTap: onJump,
        ),
      ],
    );
  }

  /// 圆形动作按钮
  Widget _buildButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.7), width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
