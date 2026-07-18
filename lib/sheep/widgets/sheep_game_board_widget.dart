import 'package:flutter/material.dart';

import '../bean/sheep_tile_bean.dart';
import 'sheep_tile_widget.dart';

/// 羊了个羊 - 棋盘视图
///
/// 根据每个方块的连续坐标 ([SheepTileBean.posX]/[posY]) 计算其在 Stack
/// 中的位置，层级越高绘制越靠上，被覆盖的方块灰显且不可点击。
class SheepGameBoardWidget extends StatelessWidget {
  /// 全部方块
  final List<SheepTileBean> tiles;

  /// 判断方块是否可点击
  final bool Function(SheepTileBean) isClickable;

  /// 点击回调
  final void Function(int tileId) onTap;

  const SheepGameBoardWidget({
    super.key,
    required this.tiles,
    required this.isClickable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tiles.isEmpty) {
      return const SizedBox.shrink();
    }

    // 计算连续坐标的包围盒
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
    for (final t in tiles) {
      if (t.isRemoved || t.isInSlot) continue;
      if (t.posX < minX) minX = t.posX;
      if (t.posY < minY) minY = t.posY;
      if (t.posX + 1 > maxX) maxX = t.posX + 1;
      if (t.posY + 1 > maxY) maxY = t.posY + 1;
    }
    final gridWidth = maxX - minX;
    final gridHeight = maxY - minY;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 依据可用空间与网格比例计算单元格边长，保留 4 像素内边距
        final padding = 4.0;
        final availableW = constraints.maxWidth - padding * 2;
        final availableH = constraints.maxHeight - padding * 2;
        final cell = (availableW / gridWidth).clamp(0.0, availableH / gridHeight);
        final boardW = gridWidth * cell + padding * 2;
        final boardH = gridHeight * cell + padding * 2;

        // 按层级升序绘制，保证上层覆盖下层
        final sorted = tiles
            .where((t) => !t.isRemoved && !t.isInSlot)
            .toList()
          ..sort((a, b) => a.layer.compareTo(b.layer));

        return Center(
          child: SizedBox(
            width: boardW,
            height: boardH,
            child: Stack(
              clipBehavior: Clip.none,
              children: sorted.map((t) {
                final left = padding + (t.posX - minX) * cell;
                final top = padding + (t.posY - minY) * cell;
                final clickable = isClickable(t);
                return Positioned(
                  left: left,
                  top: top,
                  child: SheepTileWidget(
                    type: t.type,
                    size: cell,
                    dimmed: !clickable,
                    onTap: clickable ? () => onTap(t.id) : null,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
