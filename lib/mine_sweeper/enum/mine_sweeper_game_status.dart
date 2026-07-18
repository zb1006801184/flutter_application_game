/// 游戏状态枚举
enum MineSweeperGameStatus {
  /// 空闲，等待开始
  idle,

  /// 游戏进行中
  playing,

  /// 游戏胜利
  won,

  /// 游戏失败
  lost,
}
