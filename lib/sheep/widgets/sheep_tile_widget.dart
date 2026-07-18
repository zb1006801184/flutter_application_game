import 'package:flutter/material.dart';

import '../enum/sheep_tile_type.dart';

/// 羊了个羊 - 单个方块视图
class SheepTileWidget extends StatelessWidget {
  /// 图案类型
  final SheepTileType type;

  /// 边长
  final double size;

  /// 是否被覆盖（不可点击时灰显）
  final bool dimmed;

  /// 是否已被消除（用于槽位消除动画占位，暂不使用）
  final bool removed;

  /// 点击回调
  final VoidCallback? onTap;

  const SheepTileWidget({
    super.key,
    required this.type,
    required this.size,
    this.dimmed = false,
    this.removed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 被覆盖方块保持较高不透明度，确保图案清晰可辨；仅通过描边与阴影区分可点击性
    final bgAlpha = dimmed ? 0.78 : 1.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: type.color.withValues(alpha: bgAlpha),
        borderRadius: BorderRadius.circular(size * 0.18),
        border: Border.all(
          color: dimmed
              ? Colors.white.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.95),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dimmed ? 0.08 : 0.22),
            blurRadius: dimmed ? 1.5 : 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Center(
        child: Opacity(
          opacity: dimmed ? 0.85 : 1.0,
          child: Text(
            type.emoji,
            style: TextStyle(
              fontSize: size * 0.55,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
