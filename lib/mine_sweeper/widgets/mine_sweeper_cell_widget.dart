import 'package:flutter/material.dart';

import '../bean/mine_sweeper_cell_bean.dart';
import '../enum/mine_sweeper_cell_status.dart';

/// 单个格子 UI 组件
class MineSweeperCellWidget extends StatelessWidget {
  final MineSweeperCellBean cell;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final double size;

  const MineSweeperCellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    required this.onLongPress,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Center(child: _buildContent()),
      ),
    );
  }

  /// 背景色
  Color get _backgroundColor {
    if (cell.status == MineSweeperCellStatus.opened) {
      if (cell.isMine) return Colors.red.shade100;
      return Colors.grey.shade200;
    }
    return Colors.blue.shade100;
  }

  /// 格子内容
  Widget? _buildContent() {
    switch (cell.status) {
      case MineSweeperCellStatus.closed:
        return null;
      case MineSweeperCellStatus.flagged:
        // 怀疑有雷：红色旗帜
        return Icon(Icons.flag, color: Colors.red, size: size * 0.6);
      case MineSweeperCellStatus.opened:
        if (cell.isMine) {
          return Icon(Icons.brightness_7, color: Colors.black, size: size * 0.6);
        }
        if (cell.adjacentMines > 0) {
          return Text(
            '${cell.adjacentMines}',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              color: _numberColor(cell.adjacentMines),
            ),
          );
        }
        return null;
    }
  }

  /// 数字颜色
  Color _numberColor(int count) {
    switch (count) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.brown;
      case 6:
        return Colors.teal;
      case 7:
        return Colors.black;
      case 8:
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
