import 'package:flutter/material.dart';

import '../bean/mine_sweeper_cell_bean.dart';
import 'mine_sweeper_cell_widget.dart';

/// 扫雷棋盘组件
class MineSweeperGameBoardWidget extends StatelessWidget {
  final List<List<MineSweeperCellBean>> board;
  final void Function(int row, int col) onCellTap;
  final void Function(int row, int col) onCellLongPress;

  const MineSweeperGameBoardWidget({
    super.key,
    required this.board,
    required this.onCellTap,
    required this.onCellLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (board.isEmpty) return const SizedBox.shrink();

    final rows = board.length;
    final cols = board[0].length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据可用空间计算格子大小
        final maxWidth = constraints.maxWidth - 16;
        final maxHeight = constraints.maxHeight - 16;
        final cellSize = _calcCellSize(rows, cols, maxWidth, maxHeight);

        return Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(rows, (r) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(cols, (c) {
                        return MineSweeperCellWidget(
                          cell: board[r][c],
                          size: cellSize,
                          onTap: () => onCellTap(r, c),
                          onLongPress: () => onCellLongPress(r, c),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 计算格子大小，适配屏幕
  double _calcCellSize(int rows, int cols, double maxW, double maxH) {
    final sizeByWidth = maxW / cols;
    final sizeByHeight = maxH / rows;
    final size = sizeByWidth < sizeByHeight ? sizeByWidth : sizeByHeight;
    return size.clamp(24.0, 40.0);
  }
}
