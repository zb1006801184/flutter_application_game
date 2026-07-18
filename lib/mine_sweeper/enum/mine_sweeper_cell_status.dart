/// 格子状态枚举
enum MineSweeperCellStatus {
  /// 未打开
  closed,

  /// 已打开
  opened,

  /// 标记旗帜（怀疑有雷）
  flagged,
}
