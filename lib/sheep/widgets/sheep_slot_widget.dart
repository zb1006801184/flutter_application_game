import 'package:flutter/material.dart';

import '../bean/sheep_tile_bean.dart';
import 'sheep_tile_widget.dart';

/// 羊了个羊 - 底部槽位视图
///
/// 固定 [capacity] 个格子，按进入顺序展示已选方块；空格子以虚线占位。
class SheepSlotWidget extends StatelessWidget {
  /// 槽位中的方块（按进入顺序）
  final List<SheepTileBean> slot;

  /// 槽位容量
  final int capacity;

  const SheepSlotWidget({
    super.key,
    required this.slot,
    required this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(capacity, (index) {
        if (index < slot.length) {
          final tile = slot[index];
          return SheepTileWidget(type: tile.type, size: 44);
        }
        return _buildEmptySlot();
      }),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.4),
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
    );
  }
}
