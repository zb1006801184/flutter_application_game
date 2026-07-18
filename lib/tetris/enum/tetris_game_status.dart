/// 俄罗斯方块游戏状态
enum TetrisGameStatus {
  /// 空闲，等待开始
  idle,

  /// 游戏进行中
  playing,

  /// 暂停
  paused,

  /// 游戏失败
  lost,
}
