import '../enum/mine_sweeper_cell_status.dart';

/// 扫雷单元格数据模型
class MineSweeperCellBean {
  /// 是否是雷
  final bool isMine;

  /// 周围雷的数量
  final int adjacentMines;

  /// 格子状态
  final MineSweeperCellStatus status;

  const MineSweeperCellBean({
    this.isMine = false,
    this.adjacentMines = 0,
    this.status = MineSweeperCellStatus.closed,
  });

  /// 复制并修改属性
  MineSweeperCellBean copyWith({
    bool? isMine,
    int? adjacentMines,
    MineSweeperCellStatus? status,
  }) {
    return MineSweeperCellBean(
      isMine: isMine ?? this.isMine,
      adjacentMines: adjacentMines ?? this.adjacentMines,
      status: status ?? this.status,
    );
  }
}
