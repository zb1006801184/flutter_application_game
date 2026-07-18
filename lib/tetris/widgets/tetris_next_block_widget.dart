import 'package:flutter/material.dart';

import '../enum/tetris_block_type.dart';

/// 下一个方块预览组件
class TetrisNextBlockWidget extends StatelessWidget {
  /// 下一个方块类型
  final TetrisBlockType? type;

  const TetrisNextBlockWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (r) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (c) {
              return _buildCell(type, r, c, 18);
            }),
          );
        }),
      ),
    );
  }

  /// 预览使用旋转状态 0 的矩阵
  Widget _buildCell(TetrisBlockType? type, int r, int c, double size) {
    if (type == null) {
      return _emptyCell(size);
    }
    final filled = _previewMatrix(type)[r][c] == 1;
    final color = filled ? type.color : Colors.transparent;
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: filled
            ? Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1)
            : null,
      ),
    );
  }

  /// 空格子
  Widget _emptyCell(double size) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(1),
    );
  }

  /// 取旋转状态 0 的矩阵，并补齐为 4×4 便于预览
  List<List<int>> _previewMatrix(TetrisBlockType type) {
    const all = <TetrisBlockType, List<List<int>>>{
      TetrisBlockType.i: [
        [0, 0, 0, 0],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      TetrisBlockType.o: [
        [0, 1, 1, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      TetrisBlockType.t: [
        [0, 1, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      TetrisBlockType.s: [
        [0, 1, 1, 0],
        [1, 1, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      TetrisBlockType.z: [
        [1, 1, 0, 0],
        [0, 1, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      TetrisBlockType.j: [
        [1, 0, 0, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
      TetrisBlockType.l: [
        [0, 0, 1, 0],
        [1, 1, 1, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ],
    };
    return all[type]!;
  }
}
