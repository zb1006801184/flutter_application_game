import 'package:flutter/material.dart';

import '../bean/tetris_block_bean.dart';
import '../enum/tetris_block_type.dart';
import '../provider/tetris_provider.dart';

/// 俄罗斯方块棋盘组件
class TetrisGameBoardWidget extends StatelessWidget {
  /// 棋盘数据
  final List<List<TetrisBlockType?>> board;

  /// 当前下落方块
  final TetrisBlockBean? current;

  const TetrisGameBoardWidget({
    super.key,
    required this.board,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    // 合并当前方块到一份拷贝中用于绘制
    final display = _mergeCurrent();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellSize = _calcCellSize(constraints.maxWidth, constraints.maxHeight);

        return Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade700),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(kTetrisRows, (r) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(kTetrisCols, (c) {
                    return _buildCell(display[r][c], cellSize);
                  }),
                );
              }),
            ),
          ),
        );
      },
    );
  }

  /// 将当前下落方块合并到棋盘拷贝中用于显示
  List<List<TetrisBlockType?>> _mergeCurrent() {
    final copy = board
        .map((row) => List<TetrisBlockType?>.from(row))
        .toList();
    if (current == null) return copy;
    final m = current!.matrix;
    for (int r = 0; r < m.length; r++) {
      for (int c = 0; c < m[r].length; c++) {
        if (m[r][c] == 0) continue;
        final br = current!.row + r;
        final bc = current!.col + c;
        if (br >= 0 && br < kTetrisRows && bc >= 0 && bc < kTetrisCols) {
          copy[br][bc] = current!.type;
        }
      }
    }
    return copy;
  }

  /// 单个格子
  Widget _buildCell(TetrisBlockType? type, double size) {
    final color = type?.color ?? Colors.transparent;
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: type == null
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
      ),
    );
  }

  /// 根据可用空间计算格子大小，适配屏幕
  ///
  /// 需扣除容器 padding(8)、border(2) 以及每个格子的 margin(每格 2)，
  /// 否则总尺寸会略大于可用空间导致溢出
  double _calcCellSize(double maxW, double maxH) {
    const double padding = 8; // Container padding 两侧
    const double border = 2; // Border 两侧
    const double cellMargin = 2; // 每个格子两侧 margin
    final widthOverhead = padding + border + kTetrisCols * cellMargin;
    final heightOverhead = padding + border + kTetrisRows * cellMargin;
    final sizeByWidth = (maxW - widthOverhead) / kTetrisCols;
    final sizeByHeight = (maxH - heightOverhead) / kTetrisRows;
    final size = sizeByWidth < sizeByHeight ? sizeByWidth : sizeByHeight;
    return size.clamp(10.0, 30.0);
  }
}
